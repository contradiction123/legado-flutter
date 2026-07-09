import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/highlight_rule.dart' as domain;

/// 高亮规则数据映射器
class HighlightRuleMapper {
  /// 将 Drift 数据类转换为 Domain 模型
  domain.HighlightRule fromTable(db.HighlightRule table) {
    return domain.HighlightRule(
      id: table.id,
      name: table.name,
      pattern: table.pattern,
      sampleText: table.sampleText,
      targetScope: table.targetScope,
      enabled: table.enabled,
      position: table.position,
      textColor: table.textColor,
      bgColor: table.bgColor,
      underlineMode: table.underlineMode,
      underlineColor: table.underlineColor,
      underlineWidth: table.underlineWidth,
      underlineOffset: table.underlineOffset,
    );
  }

  /// 批量转换
  List<domain.HighlightRule> fromTableList(List<db.HighlightRule> tables) {
    return tables.map(fromTable).toList();
  }

  /// 将 Domain 模型转换为 Drift Companion（用于插入/更新）
  db.HighlightRulesCompanion toCompanion(domain.HighlightRule model) {
    return db.HighlightRulesCompanion(
      name: drift.Value(model.name),
      pattern: drift.Value(model.pattern),
      sampleText: drift.Value(model.sampleText),
      targetScope: drift.Value(model.targetScope),
      enabled: drift.Value(model.enabled),
      position: drift.Value(model.position),
      textColor: model.textColor != null
          ? drift.Value(model.textColor!)
          : const drift.Value.absent(),
      bgColor: model.bgColor != null
          ? drift.Value(model.bgColor!)
          : const drift.Value.absent(),
      underlineMode: drift.Value(model.underlineMode),
      underlineColor: model.underlineColor != null
          ? drift.Value(model.underlineColor!)
          : const drift.Value.absent(),
      underlineWidth: drift.Value(model.underlineWidth),
      underlineOffset: drift.Value(model.underlineOffset),
    );
  }
}
