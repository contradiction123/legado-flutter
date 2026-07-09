// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toc_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TocRule _$TocRuleFromJson(Map<String, dynamic> json) => _TocRule(
  preUpdateJs: json['preUpdateJs'] as String?,
  chapterList: json['chapterList'] as String?,
  chapterName: json['chapterName'] as String?,
  chapterUrl: json['chapterUrl'] as String?,
  formatJs: json['formatJs'] as String?,
  isVolume: json['isVolume'] as String?,
  isVip: json['isVip'] as String?,
  isPay: json['isPay'] as String?,
  updateTime: json['updateTime'] as String?,
  nextTocUrl: json['nextTocUrl'] as String?,
);

Map<String, dynamic> _$TocRuleToJson(_TocRule instance) => <String, dynamic>{
  'preUpdateJs': instance.preUpdateJs,
  'chapterList': instance.chapterList,
  'chapterName': instance.chapterName,
  'chapterUrl': instance.chapterUrl,
  'formatJs': instance.formatJs,
  'isVolume': instance.isVolume,
  'isVip': instance.isVip,
  'isPay': instance.isPay,
  'updateTime': instance.updateTime,
  'nextTocUrl': instance.nextTocUrl,
};
