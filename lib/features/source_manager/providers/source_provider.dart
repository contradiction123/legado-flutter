import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/network/dio_client.dart';
import '../../../data/dao/book_source_dao.dart';
import '../../../data/repositories/book_source_repository.dart';
import '../../../domain/models/book_source.dart';
import '../utils/book_source_import_parser.dart';

const _unset = Object();

class SourceProvider extends StateNotifier<SourceState> {
  SourceProvider() : super(SourceState.initial()) {
    loadSources();
  }

  bool _disposed = false;
  BookSourceRepository? _repo;
  BookSourceDao? _dao;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<BookSourceRepository> _getRepo() async {
    if (_repo == null) {
      final db = await databaseInstance;
      _dao = BookSourceDao(db);
      _repo = BookSourceRepository(_dao!);
    }
    return _repo!;
  }

  Future<void> loadSources() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = await _getRepo();
      if (_disposed) return;
      final sources = await repo.getAll();
      if (_disposed) return;
      final groups = await repo.getDistinctGroups();
      if (_disposed) return;
      state = state.copyWith(
        sources: sources,
        groups: groups,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      if (_disposed) return;
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleEnabled(String url) async {
    final repo = await _getRepo();
    final source = state.sources.firstWhere((s) => s.bookSourceUrl == url);
    await repo.setEnabled(url, !source.enabled);
    await loadSources();
  }

  void search(String keyword) {
    state = state.copyWith(searchKeyword: keyword);
  }

  void filterByGroup(String? group) {
    state = state.copyWith(selectedGroup: group);
  }

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

  Future<int> importFromJson(String jsonString) async {
    try {
      final repo = await _getRepo();
      final sources = BookSourceImportParser.parseJsonText(jsonString);
      if (sources.isEmpty) {
        throw Exception('No valid book sources found');
      }

      await repo.importAll(sources);
      await loadSources();
      if (!_disposed) {
        state = state.copyWith(error: null);
      }
      return sources.length;
    } catch (e) {
      state = state.copyWith(error: 'Import failed: $e');
      rethrow;
    }
  }

  Future<int> importFromText(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw Exception('Content is empty');
    }

    if (_isUrl(trimmed)) {
      final body = await _fetchSourceText(trimmed);
      return importFromText(body);
    }

    if (trimmed.contains('ruleSearchUrl') || trimmed.contains('ruleFindUrl')) {
      throw Exception('Legacy source format is not supported');
    }

    if (trimmed.startsWith('[')) {
      return importFromJson(trimmed);
    }

    if (trimmed.startsWith('{')) {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic>) {
        final sourceUrls = decoded['sourceUrls'];
        if (sourceUrls is List) {
          var total = 0;
          for (final item in sourceUrls) {
            if (item is String && item.trim().isNotEmpty) {
              total += await importFromText(item);
            }
          }
          return total;
        }
      }
      return importFromJson(trimmed);
    }

    throw Exception('Unsupported source format');
  }

  Future<String> _fetchSourceText(String url) async {
    final dio = DioClient.instance.dio;
    final requestWithoutUa = url.endsWith('#requestWithoutUA');
    final requestUrl = requestWithoutUa
        ? url.substring(0, url.length - '#requestWithoutUA'.length)
        : url;
    final response = await dio.get<String>(
      requestUrl,
      options: requestWithoutUa
          ? Options(headers: const {'User-Agent': 'null'})
          : null,
    );
    final body = response.data;
    if (body == null || body.isEmpty) {
      throw Exception('Fetched source content is empty');
    }
    return body;
  }

  bool _isUrl(String text) {
    return text.startsWith('http://') || text.startsWith('https://');
  }

  Future<void> saveSource(BookSource source) async {
    try {
      final repo = await _getRepo();
      await repo.save(source);
      await loadSources();
    } catch (e) {
      state = state.copyWith(error: 'Save failed: $e');
      rethrow;
    }
  }

  Future<void> deleteByUrl(String url) async {
    final repo = await _getRepo();
    await repo.deleteByUrl(url);
    await loadSources();
  }
}

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

final sourceProvider = StateNotifierProvider<SourceProvider, SourceState>((ref) {
  return SourceProvider();
});
