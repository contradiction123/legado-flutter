import 'package:freezed_annotation/freezed_annotation.dart';

part 'rss_source.freezed.dart';
part 'rss_source.g.dart';

/// RSS 订阅源
///
/// 对应原：RssSource.kt
@freezed
abstract class RssSource with _$RssSource {
  const factory RssSource({
    @JsonKey(name: 'sourceUrl') required String sourceUrl,
    @JsonKey(name: 'sourceName') required String sourceName,
    @JsonKey(name: 'sourceIcon') @Default('') String sourceIcon,
    @JsonKey(name: 'sourceGroup') String? sourceGroup,
    @JsonKey(name: 'sourceComment') String? sourceComment,
    @JsonKey(name: 'enabled') @Default(true) bool enabled,
    @JsonKey(name: 'jsLib') String? jsLib,
    @JsonKey(name: 'header') Map<String, String>? header,
    // 规则字段
    @JsonKey(name: 'ruleArticles') String? ruleArticles,
    @JsonKey(name: 'ruleTitle') String? ruleTitle,
    @JsonKey(name: 'ruleLink') String? ruleLink,
    @JsonKey(name: 'rulePubDate') String? rulePubDate,
    @JsonKey(name: 'ruleDescription') String? ruleDescription,
    @JsonKey(name: 'ruleImage') String? ruleImage,
    @JsonKey(name: 'ruleContent') String? ruleContent,
    @JsonKey(name: 'type') @Default(0) int type,
    @JsonKey(name: 'sortUrl') String? sortUrl,
    @JsonKey(name: 'articleStyle') @Default(0) int articleStyle,
  }) = _RssSource;

  factory RssSource.fromJson(Map<String, dynamic> json) =>
      _$RssSourceFromJson(json);
}
