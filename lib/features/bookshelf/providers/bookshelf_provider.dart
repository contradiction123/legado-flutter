import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../data/dao/book_dao.dart';
import '../../../../data/dao/book_group_dao.dart';
import '../../../../data/mappers/book_mapper.dart';
import '../../../../data/repositories/book_repository.dart';
import '../../../../domain/models/book.dart';
import '../../../../domain/models/book_group.dart';

/// 书架状态
class BookshelfState {
  final List<Book> books;
  final List<BookGroup> groups;
  final int selectedGroupId;
  final bool isGridView;
  final bool isLoading;
  final bool isEditMode;
  final Set<String> selectedBooks;
  final String? error;

  const BookshelfState({
    this.books = const [],
    this.groups = const [],
    this.selectedGroupId = 0,
    this.isGridView = true,
    this.isLoading = false,
    this.isEditMode = false,
    this.selectedBooks = const {},
    this.error,
  });

  BookshelfState copyWith({
    List<Book>? books,
    List<BookGroup>? groups,
    int? selectedGroupId,
    bool? isGridView,
    bool? isLoading,
    bool? isEditMode,
    Set<String>? selectedBooks,
    String? error,
  }) {
    return BookshelfState(
      books: books ?? this.books,
      groups: groups ?? this.groups,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      isGridView: isGridView ?? this.isGridView,
      isLoading: isLoading ?? this.isLoading,
      isEditMode: isEditMode ?? this.isEditMode,
      selectedBooks: selectedBooks ?? this.selectedBooks,
      error: error,
    );
  }

  /// 过滤后的书籍列表
  List<Book> get filteredBooks {
    if (selectedGroupId == 0) return books;
    return books.where((b) => b.group == selectedGroupId).toList();
  }

  /// 是否全部选中
  bool get isAllSelected {
    final filtered = filteredBooks;
    return filtered.isNotEmpty && selectedBooks.length == filtered.length;
  }

  factory BookshelfState.initial() => const BookshelfState();
}

/// 书架状态管理器
class BookshelfProvider extends StateNotifier<BookshelfState> {
  BookshelfProvider() : super(BookshelfState.initial()) {
    loadBooks();
  }

  /// 加载书籍和分组
  Future<void> loadBooks() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final db = await databaseInstance;
      final bookRepo = BookRepository(BookDao(db), BookMapper());
      final groupDao = BookGroupDao(db);

      final books = await bookRepo.getAll();
      final groups = await groupDao.getAll();

      state = state.copyWith(
        books: books,
        groups: groups,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: '加载书架失败: $e',
        isLoading: false,
      );
    }
  }

  /// 刷新书架
  Future<void> refresh() => loadBooks();

  /// 切换网格/列表视图
  void toggleViewMode() {
    state = state.copyWith(isGridView: !state.isGridView);
  }

  /// 选择分组
  void selectGroup(int groupId) {
    state = state.copyWith(
      selectedGroupId: groupId,
      selectedBooks: const {},
    );
  }

  /// 进入编辑模式
  void enterEditMode() {
    state = state.copyWith(isEditMode: true, selectedBooks: const {});
  }

  /// 退出编辑模式
  void exitEditMode() {
    state = state.copyWith(isEditMode: false, selectedBooks: const {});
  }

  /// 切换书籍选中状态
  void toggleBookSelection(String bookUrl) {
    final current = Set<String>.from(state.selectedBooks);
    if (current.contains(bookUrl)) {
      current.remove(bookUrl);
    } else {
      current.add(bookUrl);
    }
    state = state.copyWith(selectedBooks: current);
  }

  /// 全选当前分组
  void selectAll() {
    final all = state.filteredBooks.map((b) => b.bookUrl).toSet();
    state = state.copyWith(selectedBooks: all);
  }

  /// 取消全选
  void deselectAll() {
    state = state.copyWith(selectedBooks: const {});
  }

  /// 删除选中的书籍
  Future<void> deleteSelected() async {
    final toDelete = Set<String>.from(state.selectedBooks);
    if (toDelete.isEmpty) return;

    try {
      final db = await databaseInstance;
      final bookRepo = BookRepository(BookDao(db), BookMapper());

      for (final url in toDelete) {
        await bookRepo.deleteByUrl(url);
      }

      final remaining = state.books.where((b) => !toDelete.contains(b.bookUrl)).toList();
      state = state.copyWith(
        books: remaining,
        selectedBooks: const {},
        isEditMode: false,
      );
    } catch (e) {
      state = state.copyWith(error: '删除失败: $e');
    }
  }

  /// 将选中的书籍移动到指定分组
  Future<void> moveSelectedToGroup(int groupId) async {
    final toMove = Set<String>.from(state.selectedBooks);
    if (toMove.isEmpty) return;

    try {
      final db = await databaseInstance;
      final bookRepo = BookRepository(BookDao(db), BookMapper());

      final updatedBooks = <Book>[];
      for (final book in state.books) {
        if (toMove.contains(book.bookUrl)) {
          final updated = book.copyWith(group: groupId);
          await bookRepo.save(updated);
          updatedBooks.add(updated);
        } else {
          updatedBooks.add(book);
        }
      }

      state = state.copyWith(
        books: updatedBooks,
        selectedBooks: const {},
        isEditMode: false,
      );
    } catch (e) {
      state = state.copyWith(error: '移动分组失败: $e');
    }
  }

  /// 批量添加书籍到书架
  Future<int> addBooks(Iterable<Book> newBooks) async {
    if (newBooks.isEmpty) return 0;

    try {
      final db = await databaseInstance;
      final bookRepo = BookRepository(BookDao(db), BookMapper());

      var added = 0;
      for (final book in newBooks) {
        final success = await bookRepo.save(book);
        if (success) added++;
      }

      // 重新加载书架
      await loadBooks();
      return added;
    } catch (e) {
      state = state.copyWith(error: '添加书籍失败: $e');
      return 0;
    }
  }
}

/// 书架状态提供者
final bookshelfProvider =
    StateNotifierProvider<BookshelfProvider, BookshelfState>((ref) {
  return BookshelfProvider();
});
