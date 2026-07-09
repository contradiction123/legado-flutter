import 'dart:convert';

import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/rss_source.dart' as domain;

/// RSS 订阅源数据映射器
class RssSourceMapper {
  /// 将 Drift 数据类转换为 Domain 模型
  domain.RssSource fromTable(db.RssSource table) {
    return domain.RssSource(
      sourceUrl: table.sourceUrl,
      sourceName: table.sourceName,
      sourceIcon: table.sourceIcon,
      sourceGroup: table.sourceGroup,
      sourceComment: table.sourceComment,
      enabled: table.enabled,
      jsLib: table.jsLib,
      header: table.header != null
          ? Map<String, String>.from(jsonDecode(table.header!))
          : null,
    );
  }

  /// 批量转换
  List<domain.RssSource> fromTableList(List<db.RssSource> tables) {
    return tables.map(fromTable).toList();
  }

  /// 将 Domain 模型转换为 Drift Companion（用于插入/更新）
  db.RssSourcesCompanion toCompanion(domain.RssSource model) {
    return db.RssSourcesCompanion(
      sourceUrl: drift.Value(model.sourceUrl),
      sourceName: drift.Value(model.sourceName),
      sourceIcon: drift.Value(model.sourceIcon),
      sourceGroup: model.sourceGroup != null
          ? drift.Value(model.sourceGroup!)
          : const drift.Value.absent(),
      sourceComment: model.sourceComment != null
          ? drift.Value(model.sourceComment!)
          : const drift.Value.absent(),
      enabled: drift.Value(model.enabled),
      jsLib: model.jsLib != null
          ? drift.Value(model.jsLib!)
          : const drift.Value.absent(),
      header: model.header != null
          ? drift.Value(jsonEncode(model.header))
          : const drift.Value.absent(),
    );
  }
}
