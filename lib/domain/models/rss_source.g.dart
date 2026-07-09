// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rss_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RssSource _$RssSourceFromJson(Map<String, dynamic> json) => _RssSource(
  sourceUrl: json['sourceUrl'] as String,
  sourceName: json['sourceName'] as String,
  sourceIcon: json['sourceIcon'] as String? ?? '',
  sourceGroup: json['sourceGroup'] as String?,
  sourceComment: json['sourceComment'] as String?,
  enabled: json['enabled'] as bool? ?? true,
  jsLib: json['jsLib'] as String?,
  header: (json['header'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
);

Map<String, dynamic> _$RssSourceToJson(_RssSource instance) =>
    <String, dynamic>{
      'sourceUrl': instance.sourceUrl,
      'sourceName': instance.sourceName,
      'sourceIcon': instance.sourceIcon,
      'sourceGroup': instance.sourceGroup,
      'sourceComment': instance.sourceComment,
      'enabled': instance.enabled,
      'jsLib': instance.jsLib,
      'header': instance.header,
    };
