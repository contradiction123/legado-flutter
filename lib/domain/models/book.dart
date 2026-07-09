import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/read_config.dart';

part 'book.freezed.dart';
part 'book.g.dart';

/// 书籍
///
/// 对应原：Book.kt（实现 BaseBook 接口）
/// 存储在 books 表中
@freezed
abstract class Book with _$Book {
  const factory Book({
    @JsonKey(name: 'bookUrl') required String bookUrl,
    @JsonKey(name: 'tocUrl') required String tocUrl,
    @JsonKey(name: 'origin') @Default('loc_book') String origin,
    @JsonKey(name: 'originName') required String originName,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'author') required String author,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'customTag') String? customTag,
    @JsonKey(name: 'coverUrl') String? coverUrl,
    @JsonKey(name: 'customCoverUrl') String? customCoverUrl,
    @JsonKey(name: 'intro') String? intro,
    @JsonKey(name: 'customIntro') String? customIntro,
    @JsonKey(name: 'remark') String? remark,
    @JsonKey(name: 'charset') String? charset,
    @JsonKey(name: 'type') @Default(8) int type,
    @JsonKey(name: 'group') @Default(0) int group,
    @JsonKey(name: 'latestChapterTitle') String? latestChapterTitle,
    @JsonKey(name: 'latestChapterTime') @Default(0) int latestChapterTime,
    @JsonKey(name: 'lastCheckTime') @Default(0) int lastCheckTime,
    @JsonKey(name: 'lastCheckCount') @Default(0) int lastCheckCount,
    @JsonKey(name: 'totalChapterNum') @Default(0) int totalChapterNum,
    @JsonKey(name: 'durChapterTitle') String? durChapterTitle,
    @JsonKey(name: 'durChapterIndex') @Default(0) int durChapterIndex,
    @JsonKey(name: 'durChapterPos') @Default(0) int durChapterPos,
    @JsonKey(name: 'durChapterTime') @Default(0) int durChapterTime,
    @JsonKey(name: 'wordCount') String? wordCount,
    @JsonKey(name: 'canUpdate') @Default(true) bool canUpdate,
    @JsonKey(name: 'order') @Default(0) int order,
    @JsonKey(name: 'originOrder') @Default(0) int originOrder,
    @JsonKey(name: 'variable') String? variable,
    @JsonKey(name: 'readConfig') String? readConfig,
    @JsonKey(name: 'syncTime') @Default(0) int syncTime,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}

extension BookX on Book {
  /// 解析阅读配置
  ReadConfig? parseReadConfig() =>
      readConfig != null ? ReadConfig.fromJson(_parseJson(readConfig!)) : null;

  static Map<String, dynamic> _parseJson(String json) {
    return const JsonDecoder().convert(json) as Map<String, dynamic>;
  }
}
