import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/replace_rule.dart' as domain;

/// 替换净化规则数据映射器
class ReplaceRuleMapper {
  /// 将 Drift 数据类转换为 Domain 模型
  domain.ReplaceRule fromTable(db.ReplaceRule table) {
    return domain.ReplaceRule(
      id: table.id,
      name: table.name,
      group: table.group,
      pattern: table.pattern,
      replacement: table.replacement,
      scope: table.scope,
      scopeTitle: table.scopeTitle,
      scopeContent: table.scopeContent,
      excludeScope: table.excludeScope,
      isEnabled: table.isEnabled,
      isRegex: table.isRegex,
      timeoutMillisecond: table.timeoutMillisecond,
      order: table.order,
    );
  }

  /// 批量转换
  List<domain.ReplaceRule> fromTableList(List<db.ReplaceRule> tables) {
    return tables.map(fromTable).toList();
  }

  /// 将 Domain 模型转换为 Drift Companion（用于插入/更新）
  db.ReplaceRulesCompanion toCompanion(domain.ReplaceRule model) {
    return db.ReplaceRulesCompanion(
      name: drift.Value(model.name),
      group: model.group != null
          ? drift.Value(model.group!)
          : const drift.Value.absent(),
      pattern: drift.Value(model.pattern),
      replacement: drift.Value(model.replacement),
      scope: model.scope != null
          ? drift.Value(model.scope!)
          : const drift.Value.absent(),
      scopeTitle: drift.Value(model.scopeTitle),
      scopeContent: drift.Value(model.scopeContent),
      excludeScope: model.excludeScope != null
          ? drift.Value(model.excludeScope!)
          : const drift.Value.absent(),
      isEnabled: drift.Value(model.isEnabled),
      isRegex: drift.Value(model.isRegex),
      timeoutMillisecond: drift.Value(model.timeoutMillisecond),
      order: drift.Value(model.order),
    );
  }
}
