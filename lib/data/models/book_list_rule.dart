import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_list_rule.freezed.dart';
part 'book_list_rule.g.dart';

// ignore_for_file: non_abstract_class_inherits_abstract_member

/// 书籍列表规则（BookListRule 接口）
///
/// 对应原：BookListRule.kt（SearchRule 和 ExploreRule 共享的接口）
/// 所有字段均为 nullable 的 String，默认值 null
@freezed
class BookListRule with _$BookListRule {
  const factory BookListRule({
    @JsonKey(name: 'bookList') String? bookList,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'author') String? author,
    @JsonKey(name: 'intro') String? intro,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'lastChapter') String? lastChapter,
    @JsonKey(name: 'updateTime') String? updateTime,
    @JsonKey(name: 'bookUrl') String? bookUrl,
    @JsonKey(name: 'coverUrl') String? coverUrl,
    @JsonKey(name: 'wordCount') String? wordCount,
  }) = _BookListRule;

  factory BookListRule.fromJson(Map<String, dynamic> json) =>
      _$BookListRuleFromJson(json);
}
