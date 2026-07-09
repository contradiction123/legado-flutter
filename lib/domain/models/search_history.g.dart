// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchKeyword _$SearchKeywordFromJson(Map<String, dynamic> json) =>
    _SearchKeyword(
      word: json['word'] as String,
      usage: (json['usage'] as num?)?.toInt() ?? 1,
      lastUseTime: (json['lastUseTime'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SearchKeywordToJson(_SearchKeyword instance) =>
    <String, dynamic>{
      'word': instance.word,
      'usage': instance.usage,
      'lastUseTime': instance.lastUseTime,
    };
