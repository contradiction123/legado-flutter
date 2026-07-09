import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/cache.dart' as domain;

/// 缓存数据映射器
class CacheMapper {
  /// 将 Drift 数据类转换为 Domain 模型
  domain.Cache fromTable(db.Cache table) {
    return domain.Cache(
      key: table.key,
      value: table.value,
      deadline: table.deadline,
    );
  }

  /// 批量转换
  List<domain.Cache> fromTableList(List<db.Cache> tables) {
    return tables.map(fromTable).toList();
  }

  /// 将 Domain 模型转换为 Drift Companion（用于插入/更新）
  db.CachesCompanion toCompanion(domain.Cache model) {
    return db.CachesCompanion(
      key: drift.Value(model.key),
      value: drift.Value(model.value),
      deadline: drift.Value(model.deadline),
    );
  }
}
