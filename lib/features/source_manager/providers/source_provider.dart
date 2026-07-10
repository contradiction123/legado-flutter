import 'dart:convert';

import 'package:flutter_riverpod/legacy.dart';

import '../../../core/di/injection_container.dart';
import '../../../data/dao/book_source_dao.dart';
import '../../../data/repositories/book_source_repository.dart';
import '../../../domain/models/book_source.dart';

const _unset = Object();

/// 书源状态管理器
///
/// 使用懒初始化模式（同 ReadRecordProvider），在首次使用时自动创建 DAO。
class SourceProvider extends StateNotifier<SourceState> {
  SourceProvider() : super(SourceState.initial()) {
    loadSources();
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  BookSourceRepository? _repo;
  BookSourceDao? _dao;

  Future<BookSourceRepository> _getRepo() async {
    if (_repo == null) {
      final db = await databaseInstance;
      _dao = BookSourceDao(db);
      _repo = BookSourceRepository(_dao!);
    }
    return _repo!;
  }

  /// 加载书源列表
  Future<void> loadSources() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = await _getRepo();
      if (_disposed) return;
      final sources = await repo.getAll();
      if (_disposed) return;
      final groups = await repo.getDistinctGroups();
      if (!_disposed) {
        state = state.copyWith(
          sources: sources,
          groups: groups,
          isLoading: false,
          error: null,
        );
      }
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }
  }

  /// 切换书源启用状态
  Future<void> toggleEnabled(String url) async {
    final repo = await _getRepo();
    final source = state.sources.firstWhere((s) => s.bookSourceUrl == url);
    await repo.setEnabled(url, !source.enabled);
    await loadSources();
  }

  /// 搜索书源
  void search(String keyword) {
    state = state.copyWith(searchKeyword: keyword);
  }

  /// 按分组过滤
  void filterByGroup(String? group) {
    state = state.copyWith(selectedGroup: group);
  }

  /// 获取过滤后的书源列表
  List<BookSource> get filteredSources {
    var list = state.sources;
    if (state.searchKeyword.isNotEmpty) {
      list = list
          .where((s) => s.bookSourceName.contains(state.searchKeyword))
          .toList();
    }
    if (state.selectedGroup != null) {
      list = list
          .where((s) => s.bookSourceGroup == state.selectedGroup)
          .toList();
    }
    return list;
  }

  /// 导入书源（JSON 字符串）
  Future<int> importFromJson(String jsonString) async {
    try {
      final repo = await _getRepo();
      final decoded = jsonDecode(jsonString);
      final list = decoded is List ? decoded : [decoded];
      final sources = list
          .map((e) {
            if (e is Map<String, dynamic>) {
              return BookSource.fromJson(e);
            }
            if (e is String) {
              return BookSource.fromJson(jsonDecode(e) as Map<String, dynamic>);
            }
            return null;
          })
          .whereType<BookSource>()
          .toList();

      await repo.importAll(sources);
      await loadSources();
      return sources.length;
    } catch (e) {
      state = state.copyWith(error: '导入失败: $e');
      return 0;
    }
  }

  /// 保存书源（插入或更新）
  Future<void> saveSource(BookSource source) async {
    try {
      final repo = await _getRepo();
      await repo.save(source);
      await loadSources();
    } catch (e) {
      state = state.copyWith(error: '保存失败: $e');
      rethrow;
    }
  }

  /// 删除书源
  Future<void> deleteByUrl(String url) async {
    final repo = await _getRepo();
    await repo.deleteByUrl(url);
    await loadSources();
  }
}

/// 书源状态
class SourceState {
  final List<BookSource> sources;
  final List<String> groups;
  final String? selectedGroup;
  final String searchKeyword;
  final bool isLoading;
  final String? error;

  const SourceState({
    this.sources = const [],
    this.groups = const [],
    this.selectedGroup,
    this.searchKeyword = '',
    this.isLoading = false,
    this.error,
  });

  factory SourceState.initial() => const SourceState();

  SourceState copyWith({
    List<BookSource>? sources,
    List<String>? groups,
    Object? selectedGroup = _unset,
    String? searchKeyword,
    bool? isLoading,
    String? error,
  }) {
    return SourceState(
      sources: sources ?? this.sources,
      groups: groups ?? this.groups,
      selectedGroup: identical(selectedGroup, _unset)
          ? this.selectedGroup
          : selectedGroup as String?,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 书源状态提供者
///
/// 自动懒初始化 DAO+Repository，无需外部 DI 注入。
final sourceProvider = StateNotifierProvider<SourceProvider, SourceState>((
  ref,
) {
  return SourceProvider();
});
