import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../data/dao/book_source_dao.dart';
import '../../../../domain/models/book_source.dart';
import '../../../../domain/models/search_book.dart';
import '../../../../engine/web_book/web_book.dart';

/// 探索页面状态
class DiscoverState {
  final List<String> groups;
  final String selectedGroup;
  final Map<String, List<BookSource>> sourcesByGroup;
  final bool isLoading;
  final String? error;
  // 探索结果
  final List<SearchBook>? exploreResults;
  final String? exploreCategory;
  final bool isExploring;

  const DiscoverState({
    this.groups = const [],
    this.selectedGroup = '',
    this.sourcesByGroup = const {},
    this.isLoading = false,
    this.error,
    this.exploreResults,
    this.exploreCategory,
    this.isExploring = false,
  });

  DiscoverState copyWith({
    List<String>? groups,
    String? selectedGroup,
    Map<String, List<BookSource>>? sourcesByGroup,
    bool? isLoading,
    String? error,
    List<SearchBook>? exploreResults,
    bool clearExploreResults = false,
    String? exploreCategory,
    bool? isExploring,
  }) {
    return DiscoverState(
      groups: groups ?? this.groups,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      sourcesByGroup: sourcesByGroup ?? this.sourcesByGroup,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      exploreResults: clearExploreResults ? null : (exploreResults ?? this.exploreResults),
      exploreCategory: exploreCategory ?? this.exploreCategory,
      isExploring: isExploring ?? this.isExploring,
    );
  }

  List<BookSource> get currentSources =>
      sourcesByGroup[selectedGroup] ?? [];

  List<String> get allTabs => ['全部', ...groups];
}

/// 探索页面状态管理器
class DiscoverProvider extends StateNotifier<DiscoverState> {
  DiscoverProvider() : super(DiscoverState()) {
    load();
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  BookSourceDao? _dao;

  Future<BookSourceDao> _getDao() async {
    if (_dao == null) {
      final db = await databaseInstance;
      _dao = BookSourceDao(db);
    }
    return _dao!;
  }

  /// 加载所有分组和书源
  Future<void> load() async {
    state = state.copyWith(isLoading: true);
    try {
      final dao = await _getDao();
      if (_disposed) return;
      final groups = await dao.getDistinctGroups();
      final allSources = await dao.getEnabledExplore();

      if (!_disposed) {
        final sourcesByGroup = <String, List<BookSource>>{};
        for (final group in groups) {
          sourcesByGroup[group] =
              allSources.where((s) => s.bookSourceGroup == group).toList();
        }
        sourcesByGroup['全部'] = allSources;

        state = DiscoverState(
          groups: groups,
          selectedGroup: state.selectedGroup.isEmpty ? '全部' : state.selectedGroup,
          sourcesByGroup: sourcesByGroup,
          isLoading: false,
        );
      }
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(isLoading: false, error: '加载书源失败: $e');
      }
    }
  }

  /// 切换分组
  void selectGroup(String group) {
    state = state.copyWith(selectedGroup: group);
  }

  /// 探索指定分类
  ///
  /// [source] 书源
  /// [exploreUrl] 该分类的探索 URL（从 exploreUrl 中提取的行）
  Future<void> exploreCategory(BookSource source, String exploreUrl) async {
    if (exploreUrl.isEmpty) return;

    state = state.copyWith(
      isExploring: true,
      exploreCategory: _extractCategoryName(exploreUrl),
      clearExploreResults: true,
      error: null,
    );

    try {
      final webBook = WebBook();
      final results = await webBook.explore(source, url: exploreUrl);

      state = state.copyWith(
        exploreResults: results,
        isExploring: false,
      );
    } catch (e) {
      state = state.copyWith(
        isExploring: false,
        error: '探索失败: $e',
      );
    }
  }

  /// 清除探索结果，返回书源列表视图
  void clearExploreResults() {
    state = state.copyWith(
      clearExploreResults: true,
      exploreCategory: null,
      error: null,
    );
  }

  /// 从 URL 中提取可读的分类名称
  String _extractCategoryName(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return Uri.decodeComponent(uri.pathSegments.last);
    }
    final eqIdx = url.lastIndexOf('=');
    if (eqIdx >= 0 && eqIdx < url.length - 1) {
      return Uri.decodeComponent(url.substring(eqIdx + 1));
    }
    final slashIdx = url.lastIndexOf('/');
    if (slashIdx >= 0 && slashIdx < url.length - 1) {
      return Uri.decodeComponent(url.substring(slashIdx + 1));
    }
    return url;
  }
}

/// 探索页面 Provider
final discoverProvider =
    StateNotifierProvider<DiscoverProvider, DiscoverState>((ref) {
  return DiscoverProvider();
});
