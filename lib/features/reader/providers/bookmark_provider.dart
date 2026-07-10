import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../data/dao/bookmark_dao.dart';
import '../../../../domain/models/bookmark.dart';

/// 书签状态
class BookmarkState {
  final List<Bookmark> bookmarks;
  final bool isLoading;
  final String? error;

  const BookmarkState({
    this.bookmarks = const [],
    this.isLoading = false,
    this.error,
  });

  BookmarkState copyWith({
    List<Bookmark>? bookmarks,
    bool? isLoading,
    String? error,
  }) {
    return BookmarkState(
      bookmarks: bookmarks ?? this.bookmarks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 书签状态管理器
class BookmarkProvider extends StateNotifier<BookmarkState> {
  BookmarkProvider() : super(BookmarkState());

  BookmarkDao? _dao;

  Future<BookmarkDao> _getDao() async {
    if (_dao == null) {
      final db = await databaseInstance;
      _dao = BookmarkDao(db);
    }
    return _dao!;
  }

  /// 加载某本书的所有书签
  Future<void> loadByBook(String bookName, String bookAuthor) async {
    state = state.copyWith(isLoading: true);
    try {
      final dao = await _getDao();
      final items = await dao.getByBook(bookName, bookAuthor);
      state = state.copyWith(bookmarks: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '加载书签失败: $e');
    }
  }

  /// 添加书签
  Future<bool> addBookmark(Bookmark bookmark) async {
    try {
      final dao = await _getDao();
      await dao.insert(bookmark);
      state = state.copyWith(bookmarks: [bookmark, ...state.bookmarks]);
      return true;
    } catch (e) {
      state = state.copyWith(error: '添加书签失败: $e');
      return false;
    }
  }

  /// 删除书签
  Future<bool> removeBookmark(int time) async {
    try {
      final dao = await _getDao();
      await dao.deleteByTime(time);
      state = state.copyWith(
        bookmarks: state.bookmarks.where((b) => b.time != time).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: '删除书签失败: $e');
      return false;
    }
  }

  /// 检查当前章节是否已有书签
  bool hasBookmarkAt(int chapterIndex) {
    return state.bookmarks.any((b) => b.chapterIndex == chapterIndex);
  }

  /// 获取当前章节的书签（用于删除）
  Bookmark? getBookmarkAt(int chapterIndex) {
    final matches = state.bookmarks.where(
      (b) => b.chapterIndex == chapterIndex,
    );
    return matches.isNotEmpty ? matches.first : null;
  }
}

/// 书签状态提供者
final bookmarkProvider = StateNotifierProvider<BookmarkProvider, BookmarkState>(
  (ref) {
    return BookmarkProvider();
  },
);
