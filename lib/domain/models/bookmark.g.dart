// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => _Bookmark(
  time: (json['time'] as num?)?.toInt(),
  bookName: json['bookName'] as String,
  bookAuthor: json['bookAuthor'] as String? ?? '',
  chapterIndex: (json['chapterIndex'] as num?)?.toInt() ?? 0,
  chapterPos: (json['chapterPos'] as num?)?.toInt() ?? 0,
  chapterName: json['chapterName'] as String,
  bookText: json['bookText'] as String,
  content: json['content'] as String,
);

Map<String, dynamic> _$BookmarkToJson(_Bookmark instance) => <String, dynamic>{
  'time': instance.time,
  'bookName': instance.bookName,
  'bookAuthor': instance.bookAuthor,
  'chapterIndex': instance.chapterIndex,
  'chapterPos': instance.chapterPos,
  'chapterName': instance.chapterName,
  'bookText': instance.bookText,
  'content': instance.content,
};
