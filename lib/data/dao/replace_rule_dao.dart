import '../../core/database/app_database.dart' as db;
import '../../domain/models/replace_rule.dart';
import '../mappers/replace_rule_mapper.dart';

/// 替换净化规则数据访问对象
class ReplaceRuleDao {
  final db.AppDatabase _database;
  final _mapper = ReplaceRuleMapper();

  ReplaceRuleDao(this._database);

  /// 获取所有替换规则
  Future<List<ReplaceRule>> getAll() async {
    final items = await _database.select(_database.replaceRules).get();
    return _mapper.fromTableList(items);
  }

  /// 获取已启用的替换规则
  Future<List<ReplaceRule>> getEnabled() async {
    final items = await (_database.select(
      _database.replaceRules,
    )..where((t) => t.isEnabled.equals(true))).get();
    return _mapper.fromTableList(items);
  }

  /// 插入替换规则
  Future<int> insert(ReplaceRule rule) {
    return _database
        .into(_database.replaceRules)
        .insert(_mapper.toCompanion(rule));
  }

  /// 更新替换规则
  Future<bool> update(ReplaceRule rule) {
    return _database
        .update(_database.replaceRules)
        .replace(_mapper.toCompanion(rule));
  }

  /// 删除替换规则
  Future<int> delete(int id) {
    return (_database.delete(
      _database.replaceRules,
    )..where((t) => t.id.equals(id))).go();
  }
}
