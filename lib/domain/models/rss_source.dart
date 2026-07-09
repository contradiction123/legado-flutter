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
  }) = _RssSource;

  factory RssSource.fromJson(Map<String, dynamic> json) =>
      _$RssSourceFromJson(json);
}
