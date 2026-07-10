// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rss_article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RssArticle _$RssArticleFromJson(Map<String, dynamic> json) => _RssArticle(
  origin: json['origin'] as String,
  sort: json['sort'] as String,
  title: json['title'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
  link: json['link'] as String,
  pubDate: json['pubDate'] as String?,
  description: json['description'] as String?,
  content: json['content'] as String?,
  image: json['image'] as String?,
  group: json['group'] as String? ?? '默认分组',
  read: json['read'] as bool? ?? false,
  variable: json['variable'] as String?,
  type: (json['type'] as num?)?.toInt() ?? 0,
  durPos: (json['durPos'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$RssArticleToJson(_RssArticle instance) =>
    <String, dynamic>{
      'origin': instance.origin,
      'sort': instance.sort,
      'title': instance.title,
      'order': instance.order,
      'link': instance.link,
      'pubDate': instance.pubDate,
      'description': instance.description,
      'content': instance.content,
      'image': instance.image,
      'group': instance.group,
      'read': instance.read,
      'variable': instance.variable,
      'type': instance.type,
      'durPos': instance.durPos,
    };
