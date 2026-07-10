import 'package:drift/drift.dart';

import '../../core/database/app_database.dart' as db;
import '../../domain/models/book_group.dart';
import '../mappers/book_group_mapper.dart';

/// 书籍分组数据访问对象
class BookGroupDao {
  final db.AppDatabase _database;

  BookGroupDao(this._database);

  /// 获取所有分组（按排序字段排列）
  Future<List<BookGroup>> getAll() async {
    final items = await (_database.select(
      _database.bookGroups,
    )..orderBy([(t) => OrderingTerm.asc(t.order)])).get();
    return items.map((e) => BookGroupMapper().fromTable(e)).toList();
  }

  /// 插入分组
  Future<int> insert(db.BookGroupsCompanion entry) {
    return _database.into(_database.bookGroups).insert(entry);
  }

  /// 更新分组
  Future<bool> update(db.BookGroupsCompanion entry) {
    return _database.update(_database.bookGroups).replace(entry);
  }

  /// 删除分组
  Future<int> delete(int groupId) {
    return (_database.delete(
      _database.bookGroups,
    )..where((t) => t.groupId.equals(groupId))).go();
  }
}
