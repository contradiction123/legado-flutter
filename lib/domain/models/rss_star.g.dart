// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rss_star.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RssStar _$RssStarFromJson(Map<String, dynamic> json) => _RssStar(
  origin: json['origin'] as String,
  sort: json['sort'] as String,
  title: json['title'] as String,
  starTime: (json['starTime'] as num?)?.toInt() ?? 0,
  link: json['link'] as String,
  pubDate: json['pubDate'] as String?,
  description: json['description'] as String?,
  content: json['content'] as String?,
  image: json['image'] as String?,
  group: json['group'] as String? ?? '默认分组',
  variable: json['variable'] as String?,
  type: (json['type'] as num?)?.toInt() ?? 0,
  durPos: (json['durPos'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RssStarToJson(_RssStar instance) => <String, dynamic>{
  'origin': instance.origin,
  'sort': instance.sort,
  'title': instance.title,
  'starTime': instance.starTime,
  'link': instance.link,
  'pubDate': instance.pubDate,
  'description': instance.description,
  'content': instance.content,
  'image': instance.image,
  'group': instance.group,
  'variable': instance.variable,
  'type': instance.type,
  'durPos': instance.durPos,
};
