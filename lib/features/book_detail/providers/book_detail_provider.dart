import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../data/dao/book_dao.dart';
import '../../../../data/dao/book_source_dao.dart';
import '../../../../data/mappers/book_mapper.dart';
import '../../../../data/repositories/book_repository.dart';
import '../../../../domain/models/book.dart';
import '../../../../domain/models/book_chapter.dart';
import '../../../../domain/models/book_source.dart';
import '../../../../domain/models/search_book.dart';
import '../../../../engine/web_book/web_book.dart';

/// 书籍详情状态
class BookDetailState {
  final SearchBook searchBook;
  final Book? book;
  final List<BookChapter> chapters;
  final bool isLoading;
  final bool isLoadingChapters;
  final bool isInBookshelf;
  final String? error;

  const BookDetailState({
    required this.searchBook,
    this.book,
    this.chapters = const [],
    this.isLoading = false,
    this.isLoadingChapters = false,
    this.isInBookshelf = false,
    this.error,
  });

  BookDetailState copyWith({
    SearchBook? searchBook,
    Book? book,
    List<BookChapter>? chapters,
    bool? isLoading,
    bool? isLoadingChapters,
    bool? isInBookshelf,
    String? error,
  }) {
    return BookDetailState(
      searchBook: searchBook ?? this.searchBook,
      book: book ?? this.book,
      chapters: chapters ?? this.chapters,
      isLoading: isLoading ?? this.isLoading,
      isLoadingChapters: isLoadingChapters ?? this.isLoadingChapters,
      isInBookshelf: isInBookshelf ?? this.isInBookshelf,
      error: error,
    );
  }
}

/// 书籍详情状态管理器
class BookDetailProvider extends StateNotifier<BookDetailState> {
  BookDetailProvider(SearchBook searchBook)
      : super(BookDetailState(searchBook: searchBook)) {
    _init();
  }

  final _webBook = WebBook();

  Future<void> _init() async {
    await _checkBookshelf();
    await loadBookInfo();
  }

  /// 检查是否在书架中
  Future<void> _checkBookshelf() async {
    try {
      final db = await databaseInstance;
      final bookRepo = BookRepository(BookDao(db), BookMapper());
      final existing = await bookRepo.getByUrl(state.searchBook.bookUrl);
      state = state.copyWith(isInBookshelf: existing != null);
    } catch (_) {
      // 忽略错误
    }
  }

  /// 加载书籍详细信息
  Future<void> loadBookInfo() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final db = await databaseInstance;
      final sourceDao = BookSourceDao(db);

      final source = await sourceDao.getByUrl(state.searchBook.origin);
      if (source == null) {
        state = state.copyWith(
          isLoading: false,
          error: '未找到对应书源: ${state.searchBook.origin}',
        );
        return;
      }

      final book = await _webBook.getBookInfo(source, state.searchBook);
      if (book != null) {
        state = state.copyWith(book: book, isLoading: false);
        // 同时加载章节列表
        await loadChapters(source, book);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载书籍信息失败: $e',
      );
    }
  }

  /// 加载章节列表
  Future<void> loadChapters(BookSource source, Book book) async {
    state = state.copyWith(isLoadingChapters: true);
    try {
      final chapters = await _webBook.getChapterList(source, book);
      state = state.copyWith(chapters: chapters, isLoadingChapters: false);
    } catch (e) {
      state = state.copyWith(isLoadingChapters: false);
    }
  }

  /// 加入书架
  Future<void> addToBookshelf() async {
    final book = state.book ?? searchBookToBook();
    try {
      final db = await databaseInstance;
      final bookRepo = BookRepository(BookDao(db), BookMapper());
      await bookRepo.save(book);
      state = state.copyWith(isInBookshelf: true);
    } catch (e) {
      state = state.copyWith(error: '加入书架失败: $e');
    }
  }

  /// 移出书架
  Future<void> removeFromBookshelf() async {
    try {
      final db = await databaseInstance;
      final bookRepo = BookRepository(BookDao(db), BookMapper());
      await bookRepo.deleteByUrl(state.searchBook.bookUrl);
      state = state.copyWith(isInBookshelf: false);
    } catch (e) {
      state = state.copyWith(error: '移出书架失败: $e');
    }
  }

  /// 从 SearchBook 构建基础 Book 对象（供外部使用）
  Book searchBookToBook() {
    return Book(
      bookUrl: state.searchBook.bookUrl,
      tocUrl: state.searchBook.tocUrl,
      origin: state.searchBook.origin,
      originName: state.searchBook.originName,
      name: state.searchBook.name,
      author: state.searchBook.author,
      coverUrl: state.searchBook.coverUrl,
      intro: state.searchBook.intro,
      latestChapterTitle: state.searchBook.latestChapterTitle,
    );
  }
}

/// 书籍详情状态提供者（需外部传入 SearchBook）
final bookDetailProvider = StateNotifierProvider.family<BookDetailProvider, BookDetailState, SearchBook>(
  (ref, searchBook) => BookDetailProvider(searchBook),
);
