import 'package:freezed_annotation/freezed_annotation.dart';

part 'rss_read_record.freezed.dart';
part 'rss_read_record.g.dart';

/// RSS 阅读记录
///
/// 对应原：RssReadRecord.kt
@freezed
abstract class RssReadRecord with _$RssReadRecord {
  const factory RssReadRecord({
    @JsonKey(name: 'record') required String record,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'readTime') int? readTime,
    @JsonKey(name: 'read') @Default(true) bool read,
    @JsonKey(name: 'origin') @Default('') String origin,
    @JsonKey(name: 'sort') @Default('') String sort,
    @JsonKey(name: 'image') String? image,
    @JsonKey(name: 'type') @Default(0) int type,
    @JsonKey(name: 'durPos') @Default(0) int durPos,
    @JsonKey(name: 'pubDate') String? pubDate,
  }) = _RssReadRecord;

  factory RssReadRecord.fromJson(Map<String, dynamic> json) =>
      _$RssReadRecordFromJson(json);
}
