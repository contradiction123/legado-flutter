import 'package:freezed_annotation/freezed_annotation.dart';

part 'rss_article.freezed.dart';
part 'rss_article.g.dart';

/// RSS 文章
///
/// 对应原：RssArticle.kt
@freezed
abstract class RssArticle with _$RssArticle {
  const factory RssArticle({
    @JsonKey(name: 'origin') required String origin,
    @JsonKey(name: 'sort') required String sort,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'order') @Default(0) int order,
    @JsonKey(name: 'link') required String link,
    @JsonKey(name: 'pubDate') String? pubDate,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'image') String? image,
    @JsonKey(name: 'group') @Default('默认分组') String group,
    @JsonKey(name: 'read') @Default(false) bool read,
    @JsonKey(name: 'variable') String? variable,
    @JsonKey(name: 'type') @Default(0) int type,
    @JsonKey(name: 'durPos') @Default(0) int durPos,
  }) = _RssArticle;

  factory RssArticle.fromJson(Map<String, dynamic> json) =>
      _$RssArticleFromJson(json);
}
