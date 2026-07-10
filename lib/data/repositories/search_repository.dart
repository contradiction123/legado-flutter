import 'package:drift/drift.dart';

import '../../core/database/app_database.dart' as db;
import '../../data/dao/search_book_dao.dart';
import '../../domain/models/search_book.dart';

/// 搜索结果仓库
///
/// 封装 SearchBookDao，对外只暴露领域模型
///
/// SearchBookDao 仅提供基础的插入/清空操作，
/// 查询（search / getRecent）由本仓库直接操作 AppDatabase 完成。
class SearchRepository {
  final SearchBookDao _dao;
  final db.AppDatabase _database;

  SearchRepository(this._dao, this._database);

  /// 保存搜索结果
  Future<void> save(SearchBook book) async {
    await _dao.insert(_toCompanion(book));
  }

  /// 搜索（按书名或作者模糊匹配）
  Future<List<SearchBook>> search(String keyword) async {
    final rows =
        await (_database.select(_database.searchBooks)..where(
              (t) => t.name.contains(keyword) | t.author.contains(keyword),
            ))
            .get();
    return rows.map(_fromTable).toList();
  }

  /// 获取最近的搜索结果（按搜索时间倒序）
  Future<List<SearchBook>> getRecent() async {
    final rows = await (_database.select(
      _database.searchBooks,
    )..orderBy([(t) => OrderingTerm.desc(t.time)])).get();
    return rows.map(_fromTable).toList();
  }

  /// 清空搜索结果
  Future<void> clear() async {
    await _dao.clearAll();
  }

  /// 领域模型 → Drift Companion
  db.SearchBooksCompanion _toCompanion(SearchBook book) {
    return db.SearchBooksCompanion.insert(
      bookUrl: book.bookUrl,
      origin: book.origin,
      originName: book.originName,
      name: book.name,
      author: book.author,
      tocUrl: book.tocUrl,
    );
  }

  /// Drift 数据类 → 领域模型
  SearchBook _fromTable(db.SearchBook row) {
    return SearchBook(
      bookUrl: row.bookUrl,
      origin: row.origin,
      originName: row.originName,
      type: row.type,
      name: row.name,
      author: row.author,
      kind: row.kind,
      coverUrl: row.coverUrl,
      intro: row.intro,
      wordCount: row.wordCount,
      latestChapterTitle: row.latestChapterTitle,
      tocUrl: row.tocUrl,
      time: row.time,
      variable: row.variable,
      originOrder: row.originOrder,
      chapterWordCountText: row.chapterWordCountText,
      chapterWordCount: row.chapterWordCount,
      respondTime: row.respondTime,
    );
  }
}
