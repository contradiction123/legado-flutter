import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/dict_rule.dart';

/// 词典规则数据访问对象
///
/// 对标原：DictRuleDao.kt
class DictRuleDao {
  final db.AppDatabase _database;

  DictRuleDao(this._database);

  /// 获取所有词典规则
  Future<List<DictRule>> getAll() async {
    final items = await (_database.select(
      _database.dictRules,
    )..orderBy([(t) => drift.OrderingTerm(expression: t.sortNumber)])).get();
    return items.map(_fromTable).toList();
  }

  /// 获取所有启用的词典规则
  Future<List<DictRule>> getEnabled() async {
    final items =
        await (_database.select(_database.dictRules)
              ..where((t) => t.enabled.equals(true))
              ..orderBy([(t) => drift.OrderingTerm(expression: t.sortNumber)]))
            .get();
    return items.map(_fromTable).toList();
  }

  /// 按名称搜索
  Future<List<DictRule>> search(String key) async {
    final items =
        await (_database.select(_database.dictRules)
              ..where((t) => t.name.like('%$key%'))
              ..orderBy([(t) => drift.OrderingTerm(expression: t.sortNumber)]))
            .get();
    return items.map(_fromTable).toList();
  }

  /// 根据名称获取
  Future<DictRule?> getByName(String name) async {
    final item = await (_database.select(
      _database.dictRules,
    )..where((t) => t.name.equals(name))).getSingleOrNull();
    return item != null ? _fromTable(item) : null;
  }

  /// 插入
  Future<void> insert(DictRule rule) async {
    await _database
        .into(_database.dictRules)
        .insert(_toCompanion(rule), mode: drift.InsertMode.insertOrReplace);
  }

  /// 更新
  Future<void> update(DictRule rule) async {
    await (_database.update(
      _database.dictRules,
    )..where((t) => t.name.equals(rule.name))).write(_toCompanion(rule));
  }

  /// 删除
  Future<void> delete(String name) async {
    await (_database.delete(
      _database.dictRules,
    )..where((t) => t.name.equals(name))).go();
  }

  /// 批量启用/禁用
  Future<void> setEnabled(Set<String> names, bool enabled) async {
    for (final name in names) {
      await (_database.update(_database.dictRules)
            ..where((t) => t.name.equals(name)))
          .write(db.DictRulesCompanion(enabled: drift.Value(enabled)));
    }
  }

  /// 批量删除
  Future<void> deleteByIds(Set<String> names) async {
    for (final name in names) {
      await (_database.delete(
        _database.dictRules,
      )..where((t) => t.name.equals(name))).go();
    }
  }

  /// 替换主键（更新名称时使用）
  Future<void> replacePrimaryKey(String oldName, DictRule newRule) async {
    await _database.batch((batch) {
      batch.deleteWhere(_database.dictRules, (t) => t.name.equals(oldName));
      batch.insert(_database.dictRules, _toCompanion(newRule));
    });
  }

  /// 批量更新排序
  Future<void> updateOrder(List<DictRule> rules) async {
    for (var i = 0; i < rules.length; i++) {
      await (_database.update(_database.dictRules)
            ..where((t) => t.name.equals(rules[i].name)))
          .write(db.DictRulesCompanion(sortNumber: drift.Value(i + 1)));
    }
  }

  DictRule _fromTable(db.DictRule table) {
    return DictRule(
      name: table.name,
      urlRule: table.urlRule,
      showRule: table.showRule,
      enabled: table.enabled,
      sortNumber: table.sortNumber,
    );
  }

  db.DictRulesCompanion _toCompanion(DictRule rule) {
    return db.DictRulesCompanion(
      name: drift.Value(rule.name),
      urlRule: drift.Value(rule.urlRule),
      showRule: drift.Value(rule.showRule),
      enabled: drift.Value(rule.enabled),
      sortNumber: drift.Value(rule.sortNumber),
    );
  }
}
