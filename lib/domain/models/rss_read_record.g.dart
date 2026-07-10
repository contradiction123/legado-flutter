// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rss_read_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RssReadRecord _$RssReadRecordFromJson(Map<String, dynamic> json) =>
    _RssReadRecord(
      record: json['record'] as String,
      title: json['title'] as String?,
      readTime: (json['readTime'] as num?)?.toInt(),
      read: json['read'] as bool? ?? true,
      origin: json['origin'] as String? ?? '',
      sort: json['sort'] as String? ?? '',
      image: json['image'] as String?,
      type: (json['type'] as num?)?.toInt() ?? 0,
      durPos: (json['durPos'] as num?)?.toInt() ?? 0,
      pubDate: json['pubDate'] as String?,
    );

Map<String, dynamic> _$RssReadRecordToJson(_RssReadRecord instance) =>
    <String, dynamic>{
      'record': instance.record,
      'title': instance.title,
      'readTime': instance.readTime,
      'read': instance.read,
      'origin': instance.origin,
      'sort': instance.sort,
      'image': instance.image,
      'type': instance.type,
      'durPos': instance.durPos,
      'pubDate': instance.pubDate,
    };
