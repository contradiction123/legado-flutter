import 'package:drift/drift.dart';

import '../../core/database/app_database.dart' as db;
import '../../domain/models/highlight_rule.dart';
import '../mappers/highlight_rule_mapper.dart';

/// 高亮规则数据访问对象
class HighlightRuleDao {
  final db.AppDatabase _database;
  final _mapper = HighlightRuleMapper();

  HighlightRuleDao(this._database);

  /// 获取所有高亮规则
  Future<List<HighlightRule>> getAll() async {
    final items = await _database.select(_database.highlightRules).get();
    return _mapper.fromTableList(items);
  }

  /// 获取所有已启用的高亮规则
  Future<List<HighlightRule>> getEnabled() async {
    final items = await (_database.select(
      _database.highlightRules,
    )..where((t) => t.enabled.equals(true))).get();
    return _mapper.fromTableList(items);
  }

  /// 插入高亮规则
  Future<int> insert(HighlightRule rule) {
    return _database
        .into(_database.highlightRules)
        .insert(_mapper.toCompanion(rule));
  }

  /// 更新高亮规则
  Future<int> update(HighlightRule rule) {
    return (_database.update(
      _database.highlightRules,
    )..where((t) => t.id.equals(rule.id))).write(_mapper.toCompanion(rule));
  }

  /// 根据 ID 删除高亮规则
  Future<int> delete(String id) {
    return (_database.delete(
      _database.highlightRules,
    )..where((t) => t.id.equals(id))).go();
  }

  /// 启用/禁用高亮规则
  Future<int> toggleEnabled(String id) async {
    final rule = await (_database.select(
      _database.highlightRules,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (rule == null) return 0;
    return (_database.update(_database.highlightRules)
          ..where((t) => t.id.equals(id)))
        .write(db.HighlightRulesCompanion(enabled: Value(!rule.enabled)));
  }
}
