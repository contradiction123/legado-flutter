import '../../data/dao/replace_rule_dao.dart';
import '../../domain/models/replace_rule.dart';

/// 替换净化规则仓库
///
/// 封装 ReplaceRuleDao，对外只暴露领域模型
class ReplaceRuleRepository {
  final ReplaceRuleDao _dao;

  ReplaceRuleRepository(this._dao);

  /// 获取所有替换规则
  Future<List<ReplaceRule>> getAll() => _dao.getAll();

  /// 获取已启用的规则
  Future<List<ReplaceRule>> getEnabled() => _dao.getEnabled();

  /// 添加规则
  Future<void> add(ReplaceRule rule) async {
    await _dao.insert(rule);
  }

  /// 更新规则
  Future<void> update(ReplaceRule rule) async {
    await _dao.update(rule);
  }

  /// 删除规则
  Future<void> delete(int id) async {
    await _dao.delete(id);
  }

  /// 切换规则启用状态
  Future<void> toggleEnabled(int id) async {
    final rules = await _dao.getAll();
    final rule = rules.where((r) => r.id == id).firstOrNull;
    if (rule != null) {
      await _dao.update(rule.copyWith(isEnabled: !rule.isEnabled));
    }
  }
}
