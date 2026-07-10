import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_info_rule.freezed.dart';
part 'book_info_rule.g.dart';

// ignore_for_file: non_abstract_class_inherits_abstract_member

/// 书籍信息规则
///
/// 对应原：BookInfoRule.kt
/// 所有字段均为 nullable 的 String，默认值 null
@freezed
abstract class BookInfoRule with _$BookInfoRule {
  const factory BookInfoRule({
    @JsonKey(name: 'init') String? init,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'author') String? author,
    @JsonKey(name: 'intro') String? intro,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'lastChapter') String? lastChapter,
    @JsonKey(name: 'updateTime') String? updateTime,
    @JsonKey(name: 'coverUrl') String? coverUrl,
    @JsonKey(name: 'tocUrl') String? tocUrl,
    @JsonKey(name: 'wordCount') String? wordCount,
    @JsonKey(name: 'canReName') String? canReName,
    @JsonKey(name: 'downloadUrls') String? downloadUrls,
    @JsonKey(name: 'relatedBooks') String? relatedBooks,
  }) = _BookInfoRule;

  factory BookInfoRule.fromJson(Map<String, dynamic> json) =>
      _$BookInfoRuleFromJson(json);
}
