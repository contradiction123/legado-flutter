import 'package:freezed_annotation/freezed_annotation.dart';

part 'rss_star.freezed.dart';
part 'rss_star.g.dart';

/// RSS 收藏
///
/// 对应原：RssStar.kt
@freezed
abstract class RssStar with _$RssStar {
  const factory RssStar({
    @JsonKey(name: 'origin') required String origin,
    @JsonKey(name: 'sort') required String sort,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'starTime') @Default(0) int starTime,
    @JsonKey(name: 'link') required String link,
    @JsonKey(name: 'pubDate') String? pubDate,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'image') String? image,
    @JsonKey(name: 'group') @Default('默认分组') String group,
    @JsonKey(name: 'variable') String? variable,
    @JsonKey(name: 'type') @Default(0) int type,
    @JsonKey(name: 'durPos') @Default(0) int durPos,
  }) = _RssStar;

  factory RssStar.fromJson(Map<String, dynamic> json) =>
      _$RssStarFromJson(json);
}
