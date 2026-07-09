import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/bookmark.dart' as domain;

/// 书签数据映射器
class BookmarkMapper {
  /// 将 Drift 数据类转换为 Domain 模型
  domain.Bookmark fromTable(db.Bookmark table) {
    return domain.Bookmark(
      time: table.time,
      bookName: table.bookName,
      bookAuthor: table.bookAuthor,
      chapterIndex: table.chapterIndex,
      chapterPos: table.chapterPos,
      chapterName: table.chapterName,
      bookText: table.bookText,
      content: table.content,
    );
  }

  /// 批量转换
  List<domain.Bookmark> fromTableList(List<db.Bookmark> tables) {
    return tables.map(fromTable).toList();
  }

  /// 将 Domain 模型转换为 Drift Companion
  db.BookmarksCompanion toCompanion(domain.Bookmark model) {
    return db.BookmarksCompanion(
      time: drift.Value(model.time ?? DateTime.now().millisecondsSinceEpoch),
      bookName: drift.Value(model.bookName),
      bookAuthor: drift.Value(model.bookAuthor),
      chapterIndex: drift.Value(model.chapterIndex),
      chapterPos: drift.Value(model.chapterPos),
      chapterName: drift.Value(model.chapterName),
      bookText: drift.Value(model.bookText),
      content: drift.Value(model.content),
    );
  }

  /// 创建新书签 Companion（不带 time，让数据库自动生成）
  db.BookmarksCompanion toNewCompanion(domain.Bookmark model) {
    return db.BookmarksCompanion(
      bookName: drift.Value(model.bookName),
      bookAuthor: drift.Value(model.bookAuthor),
      chapterIndex: drift.Value(model.chapterIndex),
      chapterPos: drift.Value(model.chapterPos),
      chapterName: drift.Value(model.chapterName),
      bookText: drift.Value(model.bookText),
      content: drift.Value(model.content),
    );
  }
}
