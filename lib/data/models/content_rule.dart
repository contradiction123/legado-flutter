import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_rule.freezed.dart';
part 'content_rule.g.dart';

// ignore_for_file: non_abstract_class_inherits_abstract_member

/// 正文规则
///
/// 对应原：ContentRule.kt
/// 所有字段均为 nullable 的 String，默认值 null
@freezed
class ContentRule with _$ContentRule {
  const factory ContentRule({
    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'subContent') String? subContent,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'nextContentUrl') String? nextContentUrl,
    @JsonKey(name: 'webJs') String? webJs,
    @JsonKey(name: 'sourceRegex') String? sourceRegex,
    @JsonKey(name: 'replaceRegex') String? replaceRegex,
    @JsonKey(name: 'imageStyle') String? imageStyle,
    @JsonKey(name: 'imageDecode') String? imageDecode,
    @JsonKey(name: 'payAction') String? payAction,
    @JsonKey(name: 'callBackJs') String? callBackJs,
  }) = _ContentRule;

  factory ContentRule.fromJson(Map<String, dynamic> json) =>
      _$ContentRuleFromJson(json);
}
