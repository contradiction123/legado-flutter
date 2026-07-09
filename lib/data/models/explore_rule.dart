import 'package:freezed_annotation/freezed_annotation.dart';

part 'explore_rule.freezed.dart';
part 'explore_rule.g.dart';

// ignore_for_file: non_abstract_class_inherits_abstract_member

/// 发现规则
///
/// 对应原：ExploreRule.kt（实现 BookListRule 接口）
/// 所有字段均为 nullable 的 String，默认值 null
@freezed
class ExploreRule with _$ExploreRule {
  const factory ExploreRule({
    // BookListRule 接口字段
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
  }) = _ExploreRule;

  factory ExploreRule.fromJson(Map<String, dynamic> json) =>
      _$ExploreRuleFromJson(json);
}
