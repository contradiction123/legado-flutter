import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/read_record.dart' as domain;

/// 阅读记录数据映射器
class ReadRecordMapper {
  /// 将 Drift 数据类转换为 Domain 模型
  domain.ReadRecord fromTable(db.ReadRecord table) {
    return domain.ReadRecord(
      deviceId: table.deviceId,
      bookName: table.bookName,
      bookAuthor: table.bookAuthor,
      readTime: table.readTime,
      lastRead: table.lastRead,
    );
  }

  /// 批量转换
  List<domain.ReadRecord> fromTableList(List<db.ReadRecord> tables) {
    return tables.map(fromTable).toList();
  }

  /// 将 Domain 模型转换为 Drift Companion
  db.ReadRecordsCompanion toCompanion(domain.ReadRecord model) {
    return db.ReadRecordsCompanion(
      deviceId: drift.Value(model.deviceId),
      bookName: drift.Value(model.bookName),
      bookAuthor: drift.Value(model.bookAuthor),
      readTime: drift.Value(model.readTime),
      lastRead: drift.Value(model.lastRead),
    );
  }
}
