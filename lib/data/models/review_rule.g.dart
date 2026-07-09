// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewRule _$ReviewRuleFromJson(Map<String, dynamic> json) => _ReviewRule(
  reviewUrl: json['reviewUrl'] as String?,
  avatarRule: json['avatarRule'] as String?,
  contentRule: json['contentRule'] as String?,
  postTimeRule: json['postTimeRule'] as String?,
  reviewQuoteUrl: json['reviewQuoteUrl'] as String?,
  voteUpUrl: json['voteUpUrl'] as String?,
  voteDownUrl: json['voteDownUrl'] as String?,
  postReviewUrl: json['postReviewUrl'] as String?,
  postQuoteUrl: json['postQuoteUrl'] as String?,
  deleteUrl: json['deleteUrl'] as String?,
);

Map<String, dynamic> _$ReviewRuleToJson(_ReviewRule instance) =>
    <String, dynamic>{
      'reviewUrl': instance.reviewUrl,
      'avatarRule': instance.avatarRule,
      'contentRule': instance.contentRule,
      'postTimeRule': instance.postTimeRule,
      'reviewQuoteUrl': instance.reviewQuoteUrl,
      'voteUpUrl': instance.voteUpUrl,
      'voteDownUrl': instance.voteDownUrl,
      'postReviewUrl': instance.postReviewUrl,
      'postQuoteUrl': instance.postQuoteUrl,
      'deleteUrl': instance.deleteUrl,
    };
