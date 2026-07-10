import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../data/dao/book_dao.dart';
import '../../../../data/dao/book_source_dao.dart';
import '../../../../data/mappers/book_mapper.dart';
import '../../../../data/repositories/book_repository.dart';
import '../../../../domain/models/book.dart';
import '../../../../domain/models/book_chapter.dart';
import '../../../../domain/models/book_source.dart';
import '../../../../domain/models/book_ext.dart';
import '../../../../engine/local_book/local_book.dart';
import '../../../../engine/web_book/web_book.dart';

/// 阅读器状态
class ReaderState {
  final Book book;
  final List<BookChapter> chapters;
  final int currentIndex;
  final Map<int, String> contents;
  final bool isLoading;
  final bool isLoadingChapters;
  final String? error;

  const ReaderState({
    required this.book,
    this.chapters = const [],
    this.currentIndex = 0,
    this.contents = const {},
    this.isLoading = false,
    this.isLoadingChapters = false,
    this.error,
  });

  ReaderState copyWith({
    Book? book,
    List<BookChapter>? chapters,
    int? currentIndex,
    Map<int, String>? contents,
    bool? isLoading,
    bool? isLoadingChapters,
    String? error,
  }) {
    return ReaderState(
      book: book ?? this.book,
      chapters: chapters ?? this.chapters,
      currentIndex: currentIndex ?? this.currentIndex,
      contents: contents ?? this.contents,
      isLoading: isLoading ?? this.isLoading,
      isLoadingChapters: isLoadingChapters ?? this.isLoadingChapters,
      error: error,
    );
  }

  /// 当前章节
  BookChapter? get currentChapter {
    if (chapters.isEmpty ||
        currentIndex < 0 ||
        currentIndex >= chapters.length) {
      return null;
    }
    return chapters[currentIndex];
  }

  /// 当前章节内容
  String? get currentContent => contents[currentIndex];

  /// 是否有上一章
  bool get hasPrevious => currentIndex > 0;

  /// 是否有下一章
  bool get hasNext => currentIndex < chapters.length - 1;
}

/// 阅读器状态管理器
class ReaderProvider extends StateNotifier<ReaderState> {
  ReaderProvider(Book book)
    : super(ReaderState(book: book, currentIndex: book.durChapterIndex)) {
    _init();
    _startAutoSave();
  }

  final _webBook = WebBook();
  BookSource? _source;

  /// 自动保存定时器（每 30 秒触发一次）
  Timer? _autoSaveTimer;

  /// 启动自动保存
  void _startAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      saveProgress().catchError((_) {});
    });
  }

  Future<void> _init() async {
    // 本地书籍使用 LocalBookManager
    if (state.book.isLocalBook) {
      await _initLocalBook();
      return;
    }

    try {
      final db = await databaseInstance;
      final sourceDao = BookSourceDao(db);

      final source = await sourceDao.getByUrl(state.book.origin);
      if (source == null) {
        state = state.copyWith(error: '未找到对应书源: ${state.book.origin}');
        return;
      }

      _source = source;

      // 加载章节列表
      await _loadChapters();
    } catch (e) {
      state = state.copyWith(error: '初始化阅读器失败: $e');
    }
  }

  /// 初始化本地书籍
  Future<void> _initLocalBook() async {
    try {
      state = state.copyWith(isLoadingChapters: true);
      final chapters = await localBookManager.getChapterList(state.book);
      state = state.copyWith(chapters: chapters, isLoadingChapters: false);

      // 加载当前章节内容
      await loadChapter(state.currentIndex);
    } catch (e) {
      state = state.copyWith(isLoadingChapters: false, error: '加载本地书籍失败: $e');
    }
  }

  /// 加载章节列表
  Future<void> _loadChapters() async {
    state = state.copyWith(isLoadingChapters: true);
    try {
      final source = _source;
      if (source == null) return;

      final chapters = await _webBook.getChapterList(source, state.book);
      state = state.copyWith(chapters: chapters, isLoadingChapters: false);

      // 加载当前章节内容
      await loadChapter(state.currentIndex);
    } catch (e) {
      state = state.copyWith(isLoadingChapters: false, error: '加载章节列表失败: $e');
    }
  }

  /// 加载指定章节内容
  Future<void> loadChapter(int index) async {
    if (index < 0 || index >= state.chapters.length) return;
    if (state.contents.containsKey(index)) {
      state = state.copyWith(currentIndex: index);
      return;
    }

    state = state.copyWith(isLoading: true, currentIndex: index);
    try {
      final chapter = state.chapters[index];

      String content;
      if (state.book.isLocalBook) {
        content = await localBookManager.getContent(state.book, chapter) ?? '';
      } else {
        final source = _source;
        if (source == null) return;
        content = await _webBook.getBookContent(source, chapter);
      }

      final newContents = Map<int, String>.from(state.contents);
      newContents[index] = content;

      state = state.copyWith(contents: newContents, isLoading: false);

      // 预加载相邻章节
      _preloadAdjacent(index);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '加载章节内容失败: $e');
    }
  }

  /// 预加载相邻章节
  void _preloadAdjacent(int index) {
    final preloadIndexes = [index - 1, index + 1];
    for (final i in preloadIndexes) {
      if (i >= 0 &&
          i < state.chapters.length &&
          !state.contents.containsKey(i)) {
        _preloadChapter(i);
      }
    }
  }

  Future<void> _preloadChapter(int index) async {
    try {
      final chapter = state.chapters[index];

      String content;
      if (state.book.isLocalBook) {
        content = await localBookManager.getContent(state.book, chapter) ?? '';
      } else {
        final source = _source;
        if (source == null) return;
        content = await _webBook.getBookContent(source, chapter);
      }

      final newContents = Map<int, String>.from(state.contents);
      newContents[index] = content;
      state = state.copyWith(contents: newContents);
    } catch (_) {
      // 预加载失败不影响阅读
    }
  }

  /// 上一章
  Future<void> goToPrevious() async {
    if (state.hasPrevious) {
      await loadChapter(state.currentIndex - 1);
    }
  }

  /// 下一章
  Future<void> goToNext() async {
    if (state.hasNext) {
      await loadChapter(state.currentIndex + 1);
    }
  }

  /// 保存阅读进度
  Future<void> saveProgress() async {
    try {
      final db = await databaseInstance;
      final bookRepo = BookRepository(BookDao(db), BookMapper());

      final chapter = state.currentChapter;
      final updatedBook = state.book.copyWith(
        durChapterIndex: state.currentIndex,
        durChapterTitle: chapter?.title,
        durChapterTime: DateTime.now().millisecondsSinceEpoch,
      );

      await bookRepo.save(updatedBook);
      state = state.copyWith(book: updatedBook);
    } catch (_) {
      // 保存失败不中断阅读
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}

/// 阅读器状态提供者（需外部传入 Book）
final readerProvider =
    StateNotifierProvider.family<ReaderProvider, ReaderState, Book>(
      (ref, book) => ReaderProvider(book),
    );
