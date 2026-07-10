import 'package:freezed_annotation/freezed_annotation.dart';

part 'toc_rule.freezed.dart';
part 'toc_rule.g.dart';

// ignore_for_file: non_abstract_class_inherits_abstract_member

/// 目录规则
///
/// 对应原：TocRule.kt
/// 所有字段均为 nullable 的 String，默认值 null
@freezed
abstract class TocRule with _$TocRule {
  const factory TocRule({
    @JsonKey(name: 'preUpdateJs') String? preUpdateJs,
    @JsonKey(name: 'chapterList') String? chapterList,
    @JsonKey(name: 'chapterName') String? chapterName,
    @JsonKey(name: 'chapterUrl') String? chapterUrl,
    @JsonKey(name: 'formatJs') String? formatJs,
    @JsonKey(name: 'isVolume') String? isVolume,
    @JsonKey(name: 'isVip') String? isVip,
    @JsonKey(name: 'isPay') String? isPay,
    @JsonKey(name: 'updateTime') String? updateTime,
    @JsonKey(name: 'nextTocUrl') String? nextTocUrl,
  }) = _TocRule;

  factory TocRule.fromJson(Map<String, dynamic> json) =>
      _$TocRuleFromJson(json);
}
