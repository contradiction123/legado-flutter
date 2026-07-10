import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_rule.freezed.dart';
part 'review_rule.g.dart';

// ignore_for_file: non_abstract_class_inherits_abstract_member

/// 段评规则
///
/// 对应原：ReviewRule.kt
/// 所有字段均为 nullable 的 String，默认值 null
@freezed
abstract class ReviewRule with _$ReviewRule {
  const factory ReviewRule({
    @JsonKey(name: 'reviewUrl') String? reviewUrl,
    @JsonKey(name: 'avatarRule') String? avatarRule,
    @JsonKey(name: 'contentRule') String? contentRule,
    @JsonKey(name: 'postTimeRule') String? postTimeRule,
    @JsonKey(name: 'reviewQuoteUrl') String? reviewQuoteUrl,
    @JsonKey(name: 'voteUpUrl') String? voteUpUrl,
    @JsonKey(name: 'voteDownUrl') String? voteDownUrl,
    @JsonKey(name: 'postReviewUrl') String? postReviewUrl,
    @JsonKey(name: 'postQuoteUrl') String? postQuoteUrl,
    @JsonKey(name: 'deleteUrl') String? deleteUrl,
  }) = _ReviewRule;

  factory ReviewRule.fromJson(Map<String, dynamic> json) =>
      _$ReviewRuleFromJson(json);
}
