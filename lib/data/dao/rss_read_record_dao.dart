import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/rss_read_record.dart';

/// RSS 阅读记录数据访问对象
class RssReadRecordDao {
  final db.AppDatabase _database;

  RssReadRecordDao(this._database);

  /// 获取所有阅读记录
  Future<List<RssReadRecord>> getAll() async {
    final items = await _database.select(_database.rssReadRecords).get();
    return items.map(_fromTable).toList();
  }

  /// 根据 record key 获取记录
  Future<RssReadRecord?> getByRecord(String record) async {
    final item = await (_database.select(
      _database.rssReadRecords,
    )..where((t) => t.record.equals(record))).getSingleOrNull();
    return item != null ? _fromTable(item) : null;
  }

  /// 插入或替换阅读记录
  Future<void> insert(RssReadRecord record) async {
    await _database
        .into(_database.rssReadRecords)
        .insertOnConflictUpdate(
          db.RssReadRecordsCompanion(
            record: drift.Value(record.record),
            title: record.title != null
                ? drift.Value(record.title!)
                : drift.Value.absent(),
            readTime: record.readTime != null
                ? drift.Value(record.readTime!)
                : drift.Value.absent(),
            read: drift.Value(record.read),
            origin: drift.Value(record.origin),
            sort: drift.Value(record.sort),
            image: record.image != null
                ? drift.Value(record.image!)
                : drift.Value.absent(),
            type: drift.Value(record.type),
            durPos: drift.Value(record.durPos),
            pubDate: record.pubDate != null
                ? drift.Value(record.pubDate!)
                : drift.Value.absent(),
          ),
        );
  }

  RssReadRecord _fromTable(db.RssReadRecord table) {
    return RssReadRecord(
      record: table.record,
      title: table.title,
      readTime: table.readTime,
      read: table.read,
      origin: table.origin,
      sort: table.sort,
      image: table.image,
      type: table.type,
      durPos: table.durPos,
      pubDate: table.pubDate,
    );
  }
}
