import 'package:flutter_riverpod/legacy.dart';

import '../../../../data/dao/dict_rule_dao.dart';
import '../../../../data/repositories/dict_rule_repository.dart';
import '../../../../domain/models/dict_rule.dart';
import '../../../../core/di/injection_container.dart' as di;

/// 词典规则状态
class DictState {
  final List<DictRule> rules;
  final bool isLoading;
  final String? error;
  final int selectedIndex;
  final String? searchResult;
  final String? emptyReason;
  final String htmlContent;

  const DictState({
    this.rules = const [],
    this.isLoading = false,
    this.error,
    this.selectedIndex = 0,
    this.searchResult,
    this.emptyReason,
    this.htmlContent = '',
  });

  DictState copyWith({
    List<DictRule>? rules,
    bool? isLoading,
    String? error,
    int? selectedIndex,
    String? searchResult,
    String? emptyReason,
    String? htmlContent,
  }) {
    return DictState(
      rules: rules ?? this.rules,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      searchResult: searchResult ?? this.searchResult,
      emptyReason: emptyReason ?? this.emptyReason,
      htmlContent: htmlContent ?? this.htmlContent,
    );
  }
}

/// 词典规则状态管理器
class DictNotifier extends StateNotifier<DictState> {
  late final DictRuleRepository _repository;

  DictNotifier() : super(const DictState()) {
    _init();
  }

  Future<void> _init() async {
    final db = await di.databaseInstance;
    _repository = DictRuleRepository(DictRuleDao(db));
  }

  /// 加载所有规则
  Future<void> loadRules() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final rules = await _repository.getAll();
      state = state.copyWith(rules: rules, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        emptyReason: '加载失败：$e',
      );
    }
  }

  /// 搜索词典
  Future<void> search(String word) async {
    state = state.copyWith(isLoading: true, searchResult: null, error: null);
    try {
      final enabled = await _repository.getEnabled();
      // 简单搜索逻辑 - 后续可扩展
      state = state.copyWith(
        isLoading: false,
        searchResult: '搜索: $word\n共 ${enabled.length} 条规则可用',
        htmlContent: '<p>搜索: $word</p><p>共 ${enabled.length} 条规则可用</p>',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        emptyReason: '搜索失败',
      );
    }
  }

  /// 选择规则
  void selectRule(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  /// 启用/禁用规则
  void enableRule(String name, bool enabled) {
    state = state.copyWith(
      rules: state.rules.map((r) {
        if (r.name == name) {
          return DictRule(
            name: r.name,
            urlRule: r.urlRule,
            showRule: r.showRule,
            enabled: enabled,
            sortNumber: r.sortNumber,
          );
        }
        return r;
      }).toList(),
    );
  }
}

/// 词典规则 Provider
final dictProvider = StateNotifierProvider<DictNotifier, DictState>((ref) {
  return DictNotifier();
});
