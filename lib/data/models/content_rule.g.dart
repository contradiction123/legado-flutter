// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContentRule _$ContentRuleFromJson(Map<String, dynamic> json) => _ContentRule(
  content: json['content'] as String?,
  subContent: json['subContent'] as String?,
  title: json['title'] as String?,
  nextContentUrl: json['nextContentUrl'] as String?,
  webJs: json['webJs'] as String?,
  sourceRegex: json['sourceRegex'] as String?,
  replaceRegex: json['replaceRegex'] as String?,
  imageStyle: json['imageStyle'] as String?,
  imageDecode: json['imageDecode'] as String?,
  payAction: json['payAction'] as String?,
  callBackJs: json['callBackJs'] as String?,
);

Map<String, dynamic> _$ContentRuleToJson(_ContentRule instance) =>
    <String, dynamic>{
      'content': instance.content,
      'subContent': instance.subContent,
      'title': instance.title,
      'nextContentUrl': instance.nextContentUrl,
      'webJs': instance.webJs,
      'sourceRegex': instance.sourceRegex,
      'replaceRegex': instance.replaceRegex,
      'imageStyle': instance.imageStyle,
      'imageDecode': instance.imageDecode,
      'payAction': instance.payAction,
      'callBackJs': instance.callBackJs,
    };
