import '../../data/dao/dict_rule_dao.dart';
import '../../domain/models/dict_rule.dart';

/// 词典规则仓库
///
/// 对标原：DictRuleRepository.kt
class DictRuleRepository {
  final DictRuleDao _dao;

  DictRuleRepository(this._dao);

  /// 获取所有规则
  Future<List<DictRule>> getAll() => _dao.getAll();

  /// 获取启用的规则
  Future<List<DictRule>> getEnabled() => _dao.getEnabled();

  /// 搜索规则
  Future<List<DictRule>> search(String key) => _dao.search(key);

  /// 按名称获取
  Future<DictRule?> getByName(String name) => _dao.getByName(name);

  /// 插入
  Future<void> insert(DictRule rule) => _dao.insert(rule);

  /// 更新
  Future<void> update(DictRule rule) => _dao.update(rule);

  /// 删除
  Future<void> delete(String name) => _dao.delete(name);

  /// 批量启用
  Future<void> enableByIds(Set<String> names) => _dao.setEnabled(names, true);

  /// 批量禁用
  Future<void> disableByIds(Set<String> names) => _dao.setEnabled(names, false);

  /// 批量删除
  Future<void> deleteByIds(Set<String> names) => _dao.deleteByIds(names);

  /// 替换主键
  Future<void> replacePrimaryKey(String oldName, DictRule newRule) =>
      _dao.replacePrimaryKey(oldName, newRule);

  /// 更新排序
  Future<void> moveOrder(List<DictRule> rules) => _dao.updateOrder(rules);
}
