import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../data/dao/book_source_dao.dart';
import '../../../../domain/models/book_source.dart';
import '../../../../domain/models/search_book.dart';
import '../../../../engine/web_book/web_book.dart';

/// 单个书源的测试结果
class SourceTestResult {
  /// 响应耗时（毫秒）
  final int responseTimeMs;

  /// 是否搜索成功（匹配到书籍）
  final bool success;

  /// 匹配到的搜索结果
  final SearchBook? searchResult;

  const SourceTestResult({
    required this.responseTimeMs,
    required this.success,
    this.searchResult,
  });
}

/// 换源状态
class ChangeSourceState {
  /// 所有待测试的书源列表（测试完成后按结果排序）
  final List<BookSource> sources;

  /// 书源URL -> 测试结果
  final Map<String, SourceTestResult> testResults;

  /// 是否正在测试
  final bool isLoading;

  /// 错误信息
  final String? error;

  const ChangeSourceState({
    this.sources = const [],
    this.testResults = const {},
    this.isLoading = false,
    this.error,
  });

  ChangeSourceState copyWith({
    List<BookSource>? sources,
    Map<String, SourceTestResult>? testResults,
    bool? isLoading,
    String? error,
  }) {
    return ChangeSourceState(
      sources: sources ?? this.sources,
      testResults: testResults ?? this.testResults,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  factory ChangeSourceState.initial() => const ChangeSourceState();
}

/// 简单的信号量，用于控制并发书源测试数
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

/// 换源状态管理器
///
/// 功能：
/// 1. 加载所有已启用的书源
/// 2. 并发测试每个书源是否能搜索到目标书籍（书名精确匹配）
/// 3. 记录每个书源的响应耗时，按结果排序（成功在前，按耗时升序）
/// 4. 提供获取成功/失败源列表的便捷方法
class ChangeSourceProvider extends StateNotifier<ChangeSourceState> {
  ChangeSourceProvider() : super(ChangeSourceState.initial());

  final _webBook = WebBook();

  /// 测试所有已启用书源是否能搜索到指定书籍
  ///
  /// [bookName] 书籍名称（作为搜索关键词）
  /// [bookAuthor] 书籍作者（用于辅助匹配，暂未使用）
  Future<void> testSources(String bookName, String bookAuthor) async {
    if (bookName.trim().isEmpty) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      testResults: const {},
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

      state = state.copyWith(sources: sources);

      // 并发测试所有书源，最大并发数 5
      final semaphore = _Semaphore(5);
      final results = <String, SourceTestResult>{};
      final futures = <Future<void>>[];

      for (final source in sources) {
        futures.add(_testSingleSource(
          source,
          bookName,
          results,
          semaphore,
        ));
      }

      await Future.wait(futures);

      // 按结果排序：成功在前（按响应时间升序），失败在后
      final sortedSources = List<BookSource>.from(sources);
      sortedSources.sort((a, b) {
        final aResult = results[a.bookSourceUrl];
        final bResult = results[b.bookSourceUrl];

        // 成功排前面，失败排后面
        if (aResult?.success == true && bResult?.success != true) return -1;
        if (aResult?.success != true && bResult?.success == true) return 1;

        // 都成功则按响应时间升序
        if (aResult?.success == true && bResult?.success == true) {
          return (aResult?.responseTimeMs ?? 0)
              .compareTo(bResult?.responseTimeMs ?? 0);
        }

        // 都失败则保持原顺序
        return 0;
      });

      state = state.copyWith(
        sources: sortedSources,
        testResults: results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '换源测试失败: $e',
      );
    }
  }

  /// 测试单个书源
  Future<void> _testSingleSource(
    BookSource source,
    String keyword,
    Map<String, SourceTestResult> accumulator,
    _Semaphore semaphore,
  ) async {
    await semaphore.acquire();
    final stopwatch = Stopwatch()..start();

    try {
      final results = await _webBook.searchBooks(source, keyword, 1);
      stopwatch.stop();

      // 在搜索结果中查找名称精确匹配的书籍
      SearchBook? matched;
      for (final book in results) {
        if (book.name == keyword) {
          matched = book;
          break;
        }
      }

      accumulator[source.bookSourceUrl] = SourceTestResult(
        responseTimeMs: stopwatch.elapsedMilliseconds,
        success: matched != null,
        searchResult: matched,
      );
    } catch (e) {
      stopwatch.stop();
      accumulator[source.bookSourceUrl] = SourceTestResult(
        responseTimeMs: stopwatch.elapsedMilliseconds,
        success: false,
      );
    } finally {
      semaphore.release();
    }
  }

  /// 获取所有测试通过（成功匹配）的书源列表，按响应时间升序排列
  List<BookSource> getSuccessfulSources() {
    return state.sources
        .where((s) => state.testResults[s.bookSourceUrl]?.success == true)
        .toList();
  }

  /// 获取所有测试失败（未匹配）的书源列表
  List<BookSource> getFailedSources() {
    return state.sources
        .where((s) => state.testResults[s.bookSourceUrl]?.success != true)
        .toList();
  }
}

/// 换源状态提供者
final changeSourceProvider =
    StateNotifierProvider<ChangeSourceProvider, ChangeSourceState>((ref) {
  return ChangeSourceProvider();
});
