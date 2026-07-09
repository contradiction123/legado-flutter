import 'package:drift/drift.dart';

import '../../core/database/app_database.dart' as db;
import '../../domain/models/book.dart';

/// 书籍 Table → Domain Model 映射器
class BookMapper {
  Book fromTable(db.Book row) {
    return Book(
      bookUrl: row.bookUrl,
      tocUrl: row.tocUrl,
      origin: row.origin,
      originName: row.originName,
      name: row.name,
      author: row.author,
      kind: row.kind,
      customTag: row.customTag,
      coverUrl: row.coverUrl,
      customCoverUrl: row.customCoverUrl,
      intro: row.intro,
      customIntro: row.customIntro,
      remark: row.remark,
      charset: row.charset,
      type: row.type,
      group: row.group,
      latestChapterTitle: row.latestChapterTitle,
      latestChapterTime: row.latestChapterTime,
      lastCheckTime: row.lastCheckTime,
      lastCheckCount: row.lastCheckCount,
      totalChapterNum: row.totalChapterNum,
      durChapterTitle: row.durChapterTitle,
      durChapterIndex: row.durChapterIndex,
      durChapterPos: row.durChapterPos,
      durChapterTime: row.durChapterTime,
      wordCount: row.wordCount,
      canUpdate: row.canUpdate,
      order: row.order,
      originOrder: row.originOrder,
      variable: row.variable,
      readConfig: row.readConfig,
      syncTime: row.syncTime,
    );
  }

  db.BooksCompanion toCompanion(Book book) {
    return db.BooksCompanion(
      bookUrl: Value(book.bookUrl),
      tocUrl: Value(book.tocUrl),
      origin: Value(book.origin),
      originName: Value(book.originName),
      name: Value(book.name),
      author: Value(book.author),
      kind: Value(book.kind),
      customTag: Value(book.customTag),
      coverUrl: Value(book.coverUrl),
      customCoverUrl: Value(book.customCoverUrl),
      intro: Value(book.intro),
      customIntro: Value(book.customIntro),
      remark: Value(book.remark),
      charset: Value(book.charset),
      type: Value(book.type),
      group: Value(book.group),
      latestChapterTitle: Value(book.latestChapterTitle),
      latestChapterTime: Value(book.latestChapterTime),
      lastCheckTime: Value(book.lastCheckTime),
      lastCheckCount: Value(book.lastCheckCount),
      totalChapterNum: Value(book.totalChapterNum),
      durChapterTitle: Value(book.durChapterTitle),
      durChapterIndex: Value(book.durChapterIndex),
      durChapterPos: Value(book.durChapterPos),
      durChapterTime: Value(book.durChapterTime),
      wordCount: Value(book.wordCount),
      canUpdate: Value(book.canUpdate),
      order: Value(book.order),
      originOrder: Value(book.originOrder),
      variable: Value(book.variable),
      readConfig: Value(book.readConfig),
      syncTime: Value(book.syncTime),
    );
  }

  List<Book> fromTableList(List<db.Book> rows) => rows.map(fromTable).toList();
}
