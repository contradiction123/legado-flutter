import '../../data/dao/highlight_rule_dao.dart';
import '../../domain/models/highlight_rule.dart';

/// 高亮规则仓库
class HighlightRuleRepository {
  final HighlightRuleDao _dao;

  HighlightRuleRepository(this._dao);

  /// 获取所有高亮规则
  Future<List<HighlightRule>> getAll() => _dao.getAll();

  /// 获取所有已启用的高亮规则
  Future<List<HighlightRule>> getEnabled() => _dao.getEnabled();

  /// 添加高亮规则
  Future<void> add(HighlightRule rule) => _dao.insert(rule);

  /// 更新高亮规则
  Future<void> update(HighlightRule rule) => _dao.update(rule);

  /// 根据 ID 删除高亮规则
  Future<void> delete(String id) => _dao.delete(id);

  /// 启用/禁用高亮规则
  Future<void> toggleEnabled(String id) => _dao.toggleEnabled(id);
}
