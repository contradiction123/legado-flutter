// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_list_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookListRule _$BookListRuleFromJson(Map<String, dynamic> json) =>
    _BookListRule(
      bookList: json['bookList'] as String?,
      name: json['name'] as String?,
      author: json['author'] as String?,
      intro: json['intro'] as String?,
      kind: json['kind'] as String?,
      lastChapter: json['lastChapter'] as String?,
      updateTime: json['updateTime'] as String?,
      bookUrl: json['bookUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      wordCount: json['wordCount'] as String?,
    );

Map<String, dynamic> _$BookListRuleToJson(_BookListRule instance) =>
    <String, dynamic>{
      'bookList': instance.bookList,
      'name': instance.name,
      'author': instance.author,
      'intro': instance.intro,
      'kind': instance.kind,
      'lastChapter': instance.lastChapter,
      'updateTime': instance.updateTime,
      'bookUrl': instance.bookUrl,
      'coverUrl': instance.coverUrl,
      'wordCount': instance.wordCount,
    };
