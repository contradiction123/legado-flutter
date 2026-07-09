import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';

/// 书籍数据访问对象
class BookDao {
  final AppDatabase _database;

  BookDao(this._database);

  /// 获取所有书籍
  Future<List<Book>> getAll() {
    return _database.select(_database.books).get();
  }

  /// 根据 bookUrl 获取单本书
  Future<Book?> getByUrl(String url) {
    return (_database.select(_database.books)
          ..where((t) => t.bookUrl.equals(url)))
        .getSingleOrNull();
  }

  /// 按分组获取书籍
  Future<List<Book>> getByGroup(int group) {
    return (_database.select(_database.books)
          ..where((t) => t.group.equals(group)))
        .get();
  }

  /// 按名称搜索书籍（书架搜索）
  Future<List<Book>> search(String keyword) {
    return (_database.select(_database.books)
          ..where((t) => t.name.like('%$keyword%')))
        .get();
  }

  /// 插入书籍
  Future<int> insert(BooksCompanion entry) {
    return _database.into(_database.books).insert(entry);
  }

  /// 更新书籍
  Future<bool> update(BooksCompanion entry) {
    return _database.update(_database.books).replace(entry);
  }

  /// 删除书籍
  Future<int> deleteByUrl(String url) {
    return (_database.delete(_database.books)
          ..where((t) => t.bookUrl.equals(url)))
        .go();
  }

  /// 更新阅读进度
  Future<int> updateProgress(
    String bookUrl, {
    required int durChapterIndex,
    required int durChapterPos,
    String? durChapterTitle,
  }) {
    return (_database.update(_database.books)
          ..where((t) => t.bookUrl.equals(bookUrl)))
        .write(BooksCompanion(
          durChapterIndex: Value(durChapterIndex),
          durChapterPos: Value(durChapterPos),
          durChapterTitle: Value(durChapterTitle),
          durChapterTime: Value(DateTime.now().millisecondsSinceEpoch),
        ));
  }

  /// 获取书籍总数
  Future<int> count() {
    return _database.select(_database.books).get().then((l) => l.length);
  }

  /// 获取最近阅读的书籍
  Future<List<Book>> getRecentRead({int limitCount = 10}) async {
    final books = await (_database.select(_database.books)
          ..where((t) => t.durChapterTime.isBiggerThanValue(0))
          ..orderBy([(t) => OrderingTerm.desc(t.durChapterTime)]))
        .get();
    return books.take(limitCount).toList();
  }
}
