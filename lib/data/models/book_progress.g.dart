// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookProgress _$BookProgressFromJson(Map<String, dynamic> json) =>
    _BookProgress(
      name: json['name'] as String,
      author: json['author'] as String,
      durChapterIndex: (json['durChapterIndex'] as num?)?.toInt() ?? 0,
      durChapterPos: (json['durChapterPos'] as num?)?.toInt() ?? 0,
      durChapterTime: (json['durChapterTime'] as num?)?.toInt() ?? 0,
      durChapterTitle: json['durChapterTitle'] as String?,
    );

Map<String, dynamic> _$BookProgressToJson(_BookProgress instance) =>
    <String, dynamic>{
      'name': instance.name,
      'author': instance.author,
      'durChapterIndex': instance.durChapterIndex,
      'durChapterPos': instance.durChapterPos,
      'durChapterTime': instance.durChapterTime,
      'durChapterTitle': instance.durChapterTitle,
    };
