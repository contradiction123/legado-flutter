import 'package:freezed_annotation/freezed_annotation.dart';

part 'replace_rule.freezed.dart';
part 'replace_rule.g.dart';

/// 替换净化规则
///
/// 对应原：ReplaceRule.kt
/// 存储在 replace_rules 表中
@freezed
abstract class ReplaceRule with _$ReplaceRule {
  const factory ReplaceRule({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'name') @Default('') String name,
    @JsonKey(name: 'group') String? group,
    @JsonKey(name: 'pattern') @Default('') String pattern,
    @JsonKey(name: 'replacement') @Default('') String replacement,
    @JsonKey(name: 'scope') String? scope,
    @JsonKey(name: 'scopeTitle') @Default(false) bool scopeTitle,
    @JsonKey(name: 'scopeContent') @Default(true) bool scopeContent,
    @JsonKey(name: 'excludeScope') String? excludeScope,
    @JsonKey(name: 'isEnabled') @Default(true) bool isEnabled,
    @JsonKey(name: 'isRegex') @Default(true) bool isRegex,
    @JsonKey(name: 'timeoutMillisecond') @Default(3000) int timeoutMillisecond,
    @JsonKey(name: 'order') @Default(0) int order,
  }) = _ReplaceRule;

  factory ReplaceRule.fromJson(Map<String, dynamic> json) =>
      _$ReplaceRuleFromJson(json);
}
