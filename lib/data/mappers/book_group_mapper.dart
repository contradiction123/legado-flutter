import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/book_group.dart' as domain;

/// 书籍分组数据映射器
///
/// 负责在 Drift 数据类与 Domain 模型之间转换
class BookGroupMapper {
  /// 将 Drift 数据类转换为 Domain 模型
  domain.BookGroup fromTable(db.BookGroup table) {
    return domain.BookGroup(
      groupId: table.groupId,
      groupName: table.groupName,
      cover: table.cover,
      order: table.order,
      enableRefresh: table.enableRefresh,
      show: table.show,
      bookSort: table.bookSort,
      isPrivate: table.isPrivate,
    );
  }

  /// 将 Domain 模型转换为 Drift Companion（用于插入/更新）
  db.BookGroupsCompanion toCompanion(domain.BookGroup model) {
    return db.BookGroupsCompanion(
      groupId: drift.Value(model.groupId),
      groupName: drift.Value(model.groupName),
      cover: model.cover != null
          ? drift.Value(model.cover!)
          : const drift.Value.absent(),
      order: drift.Value(model.order),
      enableRefresh: drift.Value(model.enableRefresh),
      show: drift.Value(model.show),
      bookSort: drift.Value(model.bookSort),
      isPrivate: drift.Value(model.isPrivate),
    );
  }
}
