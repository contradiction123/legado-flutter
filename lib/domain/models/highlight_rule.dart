import 'package:freezed_annotation/freezed_annotation.dart';

part 'highlight_rule.freezed.dart';
part 'highlight_rule.g.dart';

/// 高亮规则
///
/// 对应原：HighlightRule.kt
@freezed
abstract class HighlightRule with _$HighlightRule {
  const factory HighlightRule({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'pattern') required String pattern,
    @JsonKey(name: 'sampleText') @Default('') String sampleText,
    @JsonKey(name: 'targetScope') @Default(0) int targetScope,
    @JsonKey(name: 'enabled') @Default(true) bool enabled,
    @JsonKey(name: 'position') @Default(0) int position,
    @JsonKey(name: 'textColor') int? textColor,
    @JsonKey(name: 'bgColor') int? bgColor,
    @JsonKey(name: 'underlineMode') @Default(0) int underlineMode,
    @JsonKey(name: 'underlineColor') int? underlineColor,
    @JsonKey(name: 'underlineWidth') @Default(1.0) double underlineWidth,
    @JsonKey(name: 'underlineOffset') @Default(2.0) double underlineOffset,
  }) = _HighlightRule;

  factory HighlightRule.fromJson(Map<String, dynamic> json) =>
      _$HighlightRuleFromJson(json);
}
