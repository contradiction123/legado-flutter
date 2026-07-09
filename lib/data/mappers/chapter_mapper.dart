import 'package:drift/drift.dart';

import '../../core/database/app_database.dart' as db;
import '../../domain/models/book_chapter.dart';

/// 章节 Table → Domain Model 映射器
class ChapterMapper {
  BookChapter fromTable(db.BookChapter row) {
    return BookChapter(
      url: row.url,
      title: row.title,
      isVolume: row.isVolume,
      baseUrl: row.baseUrl,
      bookUrl: row.bookUrl,
      index: row.index,
      isVip: row.isVip,
      isPay: row.isPay,
      resourceUrl: row.resourceUrl,
      tag: row.tag,
      wordCount: row.wordCount,
      start: row.start,
      end: row.end,
      startFragmentId: row.startFragmentId,
      endFragmentId: row.endFragmentId,
      variable: row.variable,
      reviewImg: row.reviewImg,
    );
  }

  db.BookChaptersCompanion toCompanion(BookChapter chapter) {
    return db.BookChaptersCompanion(
      url: Value(chapter.url),
      title: Value(chapter.title),
      isVolume: Value(chapter.isVolume),
      baseUrl: Value(chapter.baseUrl),
      bookUrl: Value(chapter.bookUrl),
      index: Value(chapter.index),
      isVip: Value(chapter.isVip),
      isPay: Value(chapter.isPay),
      resourceUrl: Value(chapter.resourceUrl),
      tag: Value(chapter.tag),
      wordCount: Value(chapter.wordCount),
      start: Value(chapter.start),
      end: Value(chapter.end),
      startFragmentId: Value(chapter.startFragmentId),
      endFragmentId: Value(chapter.endFragmentId),
      variable: Value(chapter.variable),
      reviewImg: Value(chapter.reviewImg),
    );
  }

  List<BookChapter> fromTableList(List<db.BookChapter> rows) =>
      rows.map(fromTable).toList();
}
