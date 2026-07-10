import 'package:freezed_annotation/freezed_annotation.dart';

part 'dict_rule.freezed.dart';
part 'dict_rule.g.dart';

/// 词典规则
///
/// 对应原：DictRule.kt
/// 存储在 dictRules 表中
@freezed
abstract class DictRule with _$DictRule {
  const factory DictRule({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'urlRule') @Default('') String urlRule,
    @JsonKey(name: 'showRule') @Default('') String showRule,
    @JsonKey(name: 'enabled') @Default(true) bool enabled,
    @JsonKey(name: 'sortNumber') @Default(0) int sortNumber,
  }) = _DictRule;

  factory DictRule.fromJson(Map<String, dynamic> json) =>
      _$DictRuleFromJson(json);
}
