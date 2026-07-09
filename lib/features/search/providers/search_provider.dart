import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../data/dao/book_source_dao.dart';
import '../../../../domain/models/book_source.dart';
import '../../../../domain/models/search_book.dart';
import '../../../../engine/web_book/web_book.dart';

/// 搜索状态
class SearchState {
  final String keyword;
  final List<String> history;
  final List<SearchBook> results;
  final bool isLoading;
  final bool hasSearched;
  final int completedSources;
  final int totalSources;
  final String? error;

  const SearchState({
    this.keyword = '',
    this.history = const [],
    this.results = const [],
    this.isLoading = false,
    this.hasSearched = false,
    this.completedSources = 0,
    this.totalSources = 0,
    this.error,
  });

  SearchState copyWith({
    String? keyword,
    List<String>? history,
    List<SearchBook>? results,
    bool? isLoading,
    bool? hasSearched,
    int? completedSources,
    int? totalSources,
    String? error,
  }) {
    return SearchState(
      keyword: keyword ?? this.keyword,
      history: history ?? this.history,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      hasSearched: hasSearched ?? this.hasSearched,
      completedSources: completedSources ?? this.completedSources,
      totalSources: totalSources ?? this.totalSources,
      error: error,
    );
  }

  factory SearchState.initial() => const SearchState();
}

/// 简单的信号量，用于控制并发搜索源数
class _Semaphore {
  final int maxCount;
  int _current = 0;
  final _queue = <Completer<void>>[];

  _Semaphore(this.maxCount);

  Future<void> acquire() async {
    if (_current < maxCount) {
      _current++;
      return;
    }
    final completer = Completer<void>();
    _queue.add(completer);
    await completer.future;
  }

  void release() {
    if (_queue.isNotEmpty) {
      _queue.removeAt(0).complete();
    } else {
      _current--;
    }
  }
}

/// 搜索状态管理器
class SearchProvider extends StateNotifier<SearchState> {
  SearchProvider() : super(SearchState.initial());

  final _webBook = WebBook();
  final _semaphore = _Semaphore(5);

  /// 加载搜索历史（从内存，后续可接入数据库）
  Future<void> loadHistory() async {
    // TODO: 接入 SearchKeywordDao 持久化
    state = state.copyWith(history: const []);
  }

  /// 执行搜索
  Future<void> search(String keyword) async {
    if (keyword.trim().isEmpty) return;

    final trimmed = keyword.trim();
    state = state.copyWith(
      keyword: trimmed,
      isLoading: true,
      hasSearched: true,
      results: const [],
      completedSources: 0,
      totalSources: 0,
      error: null,
    );

    try {
      final db = await databaseInstance;
      final sourceDao = BookSourceDao(db);

      final sources = await sourceDao.getEnabled();

      if (sources.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: '没有可用的书源，请先导入或启用书源',
        );
        return;
      }

      state = state.copyWith(totalSources: sources.length);

      final allResults = <SearchBook>[];
      var completed = 0;

      // 分批并发搜索，每批最多 5 个
      final futures = <Future<void>>[];
      for (final source in sources) {
        futures.add(_searchSingleSource(source, trimmed, allResults, () {
          completed++;
          state = state.copyWith(completedSources: completed);
        }));
      }

      await Future.wait(futures);

      // 去重：按 bookUrl 去重，保留第一个
      final seen = <String>{};
      final unique = <SearchBook>[];
      for (final book in allResults) {
        if (seen.add(book.bookUrl)) {
          unique.add(book);
        }
      }

      // 更新历史记录
      final newHistory = [trimmed, ...state.history.where((h) => h != trimmed)];
      state = state.copyWith(
        results: unique,
        isLoading: false,
        history: newHistory.take(20).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '搜索失败: $e',
      );
    }
  }

  Future<void> _searchSingleSource(
    BookSource source,
    String keyword,
    List<SearchBook> accumulator,
    VoidCallback onComplete,
  ) async {
    await _semaphore.acquire();
    try {
      final results = await _webBook.searchBooks(source, keyword, 1);
      accumulator.addAll(results);
    } catch (_) {
      // 单个书源搜索失败不影响整体
    } finally {
      _semaphore.release();
      onComplete();
    }
  }

  /// 清空历史记录
  void clearHistory() {
    state = state.copyWith(history: const []);
  }

  /// 删除单条历史
  void removeHistory(String keyword) {
    state = state.copyWith(
      history: state.history.where((h) => h != keyword).toList(),
    );
  }
}

/// 搜索状态提供者
final searchProvider =
    StateNotifierProvider<SearchProvider, SearchState>((ref) {
  return SearchProvider();
});
