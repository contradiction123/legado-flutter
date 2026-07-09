// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchBook _$SearchBookFromJson(Map<String, dynamic> json) => _SearchBook(
  bookUrl: json['bookUrl'] as String,
  origin: json['origin'] as String,
  originName: json['originName'] as String,
  type: (json['type'] as num?)?.toInt() ?? 8,
  name: json['name'] as String,
  author: json['author'] as String,
  kind: json['kind'] as String?,
  coverUrl: json['coverUrl'] as String?,
  intro: json['intro'] as String?,
  wordCount: json['wordCount'] as String?,
  latestChapterTitle: json['latestChapterTitle'] as String?,
  tocUrl: json['tocUrl'] as String,
  time: (json['time'] as num?)?.toInt(),
  variable: json['variable'] as String?,
  originOrder: (json['originOrder'] as num?)?.toInt() ?? 0,
  chapterWordCountText: json['chapterWordCountText'] as String?,
  chapterWordCount: (json['chapterWordCount'] as num?)?.toInt() ?? -1,
  respondTime: (json['respondTime'] as num?)?.toInt() ?? -1,
);

Map<String, dynamic> _$SearchBookToJson(_SearchBook instance) =>
    <String, dynamic>{
      'bookUrl': instance.bookUrl,
      'origin': instance.origin,
      'originName': instance.originName,
      'type': instance.type,
      'name': instance.name,
      'author': instance.author,
      'kind': instance.kind,
      'coverUrl': instance.coverUrl,
      'intro': instance.intro,
      'wordCount': instance.wordCount,
      'latestChapterTitle': instance.latestChapterTitle,
      'tocUrl': instance.tocUrl,
      'time': instance.time,
      'variable': instance.variable,
      'originOrder': instance.originOrder,
      'chapterWordCountText': instance.chapterWordCountText,
      'chapterWordCount': instance.chapterWordCount,
      'respondTime': instance.respondTime,
    };
