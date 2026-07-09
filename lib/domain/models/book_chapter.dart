import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_chapter.freezed.dart';
part 'book_chapter.g.dart';

/// 章节
///
/// 对应原：BookChapter.kt
/// 存储在 chapters 表中
@freezed
abstract class BookChapter with _$BookChapter {
  const factory BookChapter({
    @JsonKey(name: 'url') required String url,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'isVolume') @Default(false) bool isVolume,
    @JsonKey(name: 'baseUrl') required String baseUrl,
    @JsonKey(name: 'bookUrl') required String bookUrl,
    @JsonKey(name: 'index') @Default(0) int index,
    @JsonKey(name: 'isVip') @Default(false) bool isVip,
    @JsonKey(name: 'isPay') @Default(false) bool isPay,
    @JsonKey(name: 'resourceUrl') String? resourceUrl,
    @JsonKey(name: 'tag') String? tag,
    @JsonKey(name: 'wordCount') String? wordCount,
    @JsonKey(name: 'start') int? start,
    @JsonKey(name: 'end') int? end,
    @JsonKey(name: 'startFragmentId') String? startFragmentId,
    @JsonKey(name: 'endFragmentId') String? endFragmentId,
    @JsonKey(name: 'variable') String? variable,
    @JsonKey(name: 'reviewImg') String? reviewImg,
  }) = _BookChapter;

  factory BookChapter.fromJson(Map<String, dynamic> json) =>
      _$BookChapterFromJson(json);
}
