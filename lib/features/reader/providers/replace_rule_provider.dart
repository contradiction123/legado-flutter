import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../data/dao/replace_rule_dao.dart';
import '../../../../domain/models/replace_rule.dart';

/// 替换净化状态
class ReplaceRuleState {
  final List<ReplaceRule> allRules;
  final List<ReplaceRule> enabledRules;
  final bool isLoading;
  final bool replaceEnabled;
  final String? error;

  const ReplaceRuleState({
    this.allRules = const [],
    this.enabledRules = const [],
    this.isLoading = false,
    this.replaceEnabled = true,
    this.error,
  });

  ReplaceRuleState copyWith({
    List<ReplaceRule>? allRules,
    List<ReplaceRule>? enabledRules,
    bool? isLoading,
    bool? replaceEnabled,
    String? error,
  }) {
    return ReplaceRuleState(
      allRules: allRules ?? this.allRules,
      enabledRules: enabledRules ?? this.enabledRules,
      isLoading: isLoading ?? this.isLoading,
      replaceEnabled: replaceEnabled ?? this.replaceEnabled,
      error: error,
    );
  }
}

/// 替换净化状态管理器
class ReplaceRuleProvider extends StateNotifier<ReplaceRuleState> {
  ReplaceRuleProvider() : super(ReplaceRuleState()) {
    loadRules();
  }

  ReplaceRuleDao? _dao;

  Future<ReplaceRuleDao> _getDao() async {
    if (_dao == null) {
      final db = await databaseInstance;
      _dao = ReplaceRuleDao(db);
    }
    return _dao!;
  }

  /// 加载所有替换规则
  Future<void> loadRules() async {
    state = state.copyWith(isLoading: true);
    try {
      final dao = await _getDao();
      final all = await dao.getAll();
      final enabled = all.where((r) => r.isEnabled).toList();
      state = state.copyWith(
        allRules: all,
        enabledRules: enabled,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '加载替换规则失败: $e');
    }
  }

  /// 添加规则
  Future<bool> addRule(ReplaceRule rule) async {
    try {
      final dao = await _getDao();
      await dao.insert(rule);
      await loadRules();
      return true;
    } catch (e) {
      state = state.copyWith(error: '添加规则失败: $e');
      return false;
    }
  }

  /// 更新规则
  Future<bool> updateRule(ReplaceRule rule) async {
    try {
      final dao = await _getDao();
      await dao.update(rule);
      await loadRules();
      return true;
    } catch (e) {
      state = state.copyWith(error: '更新规则失败: $e');
      return false;
    }
  }

  /// 删除规则
  Future<bool> deleteRule(int id) async {
    try {
      final dao = await _getDao();
      await dao.delete(id);
      await loadRules();
      return true;
    } catch (e) {
      state = state.copyWith(error: '删除规则失败: $e');
      return false;
    }
  }

  /// 切换规则的启用状态
  Future<void> toggleRule(int id) async {
    final rule = state.allRules.where((r) => r.id == id).firstOrNull;
    if (rule == null) return;

    await updateRule(rule.copyWith(isEnabled: !rule.isEnabled));
  }

  /// 切换净化总开关
  void toggleReplaceEnabled() {
    state = state.copyWith(replaceEnabled: !state.replaceEnabled);
  }
}

/// 替换净化状态提供者
final replaceRuleProvider =
    StateNotifierProvider<ReplaceRuleProvider, ReplaceRuleState>((ref) {
  return ReplaceRuleProvider();
});
