import 'package:drift/drift.dart';

import '../../core/database/app_database.dart';

/// 章节数据访问对象
class ChapterDao {
  final AppDatabase _database;

  ChapterDao(this._database);

  /// 获取某本书的所有章节
  Future<List<BookChapter>> getByBookUrl(String bookUrl) {
    return (_database.select(_database.bookChapters)
          ..where((t) => t.bookUrl.equals(bookUrl))
          ..orderBy([(t) => OrderingTerm.asc(t.index)]))
        .get();
  }

  /// 通过 url + bookUrl 获取单个章节
  Future<BookChapter?> getByUrl(String url, String bookUrl) {
    return (_database.select(_database.bookChapters)
          ..where((t) => t.url.equals(url) & t.bookUrl.equals(bookUrl)))
        .getSingleOrNull();
  }

  /// 通过索引获取章节
  Future<BookChapter?> getByIndex(String bookUrl, int index) {
    return (_database.select(_database.bookChapters)
          ..where((t) => t.bookUrl.equals(bookUrl) & t.index.equals(index)))
        .getSingleOrNull();
  }

  /// 批量插入章节（忽略已存在的）
  Future<void> insertAll(List<BookChaptersCompanion> entries) async {
    for (final entry in entries) {
      await _database
          .into(_database.bookChapters)
          .insert(entry, mode: InsertMode.insertOrIgnore);
    }
  }

  /// 删除某本书的所有章节
  Future<int> deleteByBookUrl(String bookUrl) {
    return (_database.delete(
      _database.bookChapters,
    )..where((t) => t.bookUrl.equals(bookUrl))).go();
  }

  /// 获取章节总数
  Future<int> countByBookUrl(String bookUrl) async {
    final chapters = await getByBookUrl(bookUrl);
    return chapters.length;
  }
}
