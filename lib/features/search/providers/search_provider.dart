import 'dart:async';
import 'dart:collection';

import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/constants/book_type.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../data/repositories/book_source_repository.dart';
import '../../../../data/repositories/search_history_repository.dart';
import '../../../../domain/models/book_source.dart';
import '../../../../domain/models/search_book.dart';
import '../../../../engine/web_book/web_book.dart';

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
      return;
    }
    _current--;
  }
}

class SearchProvider extends StateNotifier<SearchState> {
  SearchProvider() : super(SearchState.initial());

  final WebBook _webBook = WebBook();
  final _Semaphore _semaphore = _Semaphore(5);
  int _activeSearchToken = 0;

  Future<void> loadHistory() async {
    final repository = await sl.getAsync<SearchHistoryRepository>();
    final items = await repository.getAll();
    state = state.copyWith(
      history: items.map((item) => item.word).toList(growable: false),
    );
  }

  Future<void> search(String keyword) async {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final searchToken = ++_activeSearchToken;
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
      final bookSourceRepository = await sl.getAsync<BookSourceRepository>();
      final historyRepository = await sl.getAsync<SearchHistoryRepository>();
      final sources = await _loadSearchableSources(bookSourceRepository);

      if (searchToken != _activeSearchToken) {
        return;
      }

      if (sources.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: '没有可搜索的小说书源，请先导入并启用支持搜索的文本书源',
        );
        return;
      }

      state = state.copyWith(totalSources: sources.length);
      await historyRepository.add(trimmed);
      await loadHistory();

      final aggregator = _SearchResultAggregator(trimmed);
      final futures = <Future<void>>[];
      var completed = 0;
      var failed = 0;

      for (final source in sources) {
        futures.add(
          _searchSingleSource(source, trimmed).then((result) {
            if (searchToken != _activeSearchToken) {
              return;
            }

            completed++;
            if (result.failed) {
              failed++;
            } else {
              aggregator.merge(result.books);
            }

            state = state.copyWith(
              results: aggregator.results,
              completedSources: completed,
              totalSources: sources.length,
            );
          }),
        );
      }

      await Future.wait(futures);
      if (searchToken != _activeSearchToken) {
        return;
      }

      state = state.copyWith(
        results: aggregator.results,
        isLoading: false,
        completedSources: completed,
        totalSources: sources.length,
        error: aggregator.results.isEmpty && failed == sources.length
            ? '所有书源搜索失败，请检查书源可用性或网络状态'
            : null,
      );
    } catch (e) {
      if (searchToken != _activeSearchToken) {
        return;
      }
      state = state.copyWith(isLoading: false, error: '搜索失败: $e');
    }
  }

  Future<List<BookSource>> _loadSearchableSources(
    BookSourceRepository repository,
  ) async {
    final enabledSources = await repository.getEnabled();
    final searchableSources = enabledSources.where(_isSearchableSource).toList();
    searchableSources.sort(_sortSources);

    final textSources = searchableSources
        .where((source) => source.bookSourceType == BookTypeConst.text)
        .toList(growable: false);
    if (textSources.isNotEmpty) {
      return textSources;
    }
    return searchableSources;
  }

  bool _isSearchableSource(BookSource source) {
    final searchUrl = source.searchUrl;
    final ruleSearch = source.ruleSearch;
    return searchUrl != null &&
        searchUrl.isNotEmpty &&
        ruleSearch != null &&
        ruleSearch.isNotEmpty;
  }

  int _sortSources(BookSource a, BookSource b) {
    final orderCompare = a.customOrder.compareTo(b.customOrder);
    if (orderCompare != 0) {
      return orderCompare;
    }
    final weightCompare = b.weight.compareTo(a.weight);
    if (weightCompare != 0) {
      return weightCompare;
    }
    return a.bookSourceName.compareTo(b.bookSourceName);
  }

  Future<_SourceSearchResult> _searchSingleSource(
    BookSource source,
    String keyword,
  ) async {
    await _semaphore.acquire();
    try {
      final books = await _webBook.searchBooks(source, keyword, 1);
      return _SourceSearchResult(books: books, failed: false);
    } catch (_) {
      return const _SourceSearchResult(books: [], failed: true);
    } finally {
      _semaphore.release();
    }
  }

  Future<void> clearHistory() async {
    final repository = await sl.getAsync<SearchHistoryRepository>();
    await repository.clear();
    state = state.copyWith(history: const []);
  }

  Future<void> removeHistory(String keyword) async {
    final repository = await sl.getAsync<SearchHistoryRepository>();
    await repository.delete(keyword);
    state = state.copyWith(
      history: state.history.where((item) => item != keyword).toList(),
    );
  }
}

class _SourceSearchResult {
  final List<SearchBook> books;
  final bool failed;

  const _SourceSearchResult({required this.books, required this.failed});
}

class _SearchResultAggregator {
  _SearchResultAggregator(this.keyword);

  final String keyword;
  final LinkedHashMap<String, SearchBook> _exactMatches =
      LinkedHashMap<String, SearchBook>();
  final LinkedHashMap<String, SearchBook> _kindMatches =
      LinkedHashMap<String, SearchBook>();
  final LinkedHashMap<String, SearchBook> _containsMatches =
      LinkedHashMap<String, SearchBook>();
  final LinkedHashMap<String, SearchBook> _otherMatches =
      LinkedHashMap<String, SearchBook>();

  List<SearchBook> get results => <SearchBook>[
    ..._exactMatches.values,
    ..._kindMatches.values,
    ..._containsMatches.values,
    ..._otherMatches.values,
  ];

  void merge(List<SearchBook> books) {
    for (final book in books) {
      final bucket = _selectBucket(book);
      final key = _buildKey(book);
      final current = bucket[key];
      if (current == null) {
        bucket[key] = book;
        continue;
      }
      bucket[key] = _pickPreferred(current, book);
    }
  }

  LinkedHashMap<String, SearchBook> _selectBucket(SearchBook book) {
    final lowerKeyword = keyword.toLowerCase();
    final lowerName = book.name.toLowerCase();
    final lowerAuthor = book.author.toLowerCase();
    final lowerKind = book.kind?.toLowerCase();

    if (lowerName == lowerKeyword || lowerAuthor == lowerKeyword) {
      return _exactMatches;
    }
    if (lowerKind != null && lowerKind.contains(lowerKeyword)) {
      return _kindMatches;
    }
    if (lowerName.contains(lowerKeyword) || lowerAuthor.contains(lowerKeyword)) {
      return _containsMatches;
    }
    return _otherMatches;
  }

  String _buildKey(SearchBook book) {
    return '${book.name.trim().toLowerCase()}::${book.author.trim().toLowerCase()}';
  }

  SearchBook _pickPreferred(SearchBook current, SearchBook incoming) {
    final preferred = _comparePriority(incoming, current) < 0
        ? incoming
        : current;
    final fallback = identical(preferred, incoming) ? current : incoming;

    return preferred.copyWith(
      coverUrl: preferred.coverUrl ?? fallback.coverUrl,
      intro: preferred.intro ?? fallback.intro,
      kind: preferred.kind ?? fallback.kind,
      wordCount: preferred.wordCount ?? fallback.wordCount,
      latestChapterTitle:
          preferred.latestChapterTitle ?? fallback.latestChapterTitle,
      respondTime: _mergeRespondTime(
        preferred.respondTime,
        fallback.respondTime,
      ),
    );
  }

  int _comparePriority(SearchBook a, SearchBook b) {
    final originOrderCompare = a.originOrder.compareTo(b.originOrder);
    if (originOrderCompare != 0) {
      return originOrderCompare;
    }

    final aRespond = a.respondTime < 0 ? 1 << 30 : a.respondTime;
    final bRespond = b.respondTime < 0 ? 1 << 30 : b.respondTime;
    final respondCompare = aRespond.compareTo(bRespond);
    if (respondCompare != 0) {
      return respondCompare;
    }

    return a.bookUrl.compareTo(b.bookUrl);
  }

  int _mergeRespondTime(int current, int incoming) {
    if (current < 0) {
      return incoming;
    }
    if (incoming < 0) {
      return current;
    }
    return current < incoming ? current : incoming;
  }
}

final searchProvider =
    StateNotifierProvider<SearchProvider, SearchState>((ref) {
  return SearchProvider();
});
