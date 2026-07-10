import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/cookie.dart' as domain;

/// Cookie 数据映射器
class CookieMapper {
  /// 将 Drift 数据类转换为 Domain 模型
  domain.Cookie fromTable(db.Cooky table) {
    return domain.Cookie(url: table.url, cookie: table.cookie);
  }

  /// 批量转换
  List<domain.Cookie> fromTableList(List<db.Cooky> tables) {
    return tables.map(fromTable).toList();
  }

  /// 将 Domain 模型转换为 Drift Companion（用于插入/更新）
  db.CookiesCompanion toCompanion(domain.Cookie model) {
    return db.CookiesCompanion(
      url: drift.Value(model.url),
      cookie: drift.Value(model.cookie),
    );
  }
}
