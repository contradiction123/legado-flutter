import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_book.freezed.dart';
part 'search_book.g.dart';

/// 搜索结果
///
/// 对应原：SearchBook.kt
/// 存储在 searchBooks 表中
@freezed
abstract class SearchBook with _$SearchBook {
  const factory SearchBook({
    @JsonKey(name: 'bookUrl') required String bookUrl,
    @JsonKey(name: 'origin') required String origin,
    @JsonKey(name: 'originName') required String originName,
    @JsonKey(name: 'type') @Default(8) int type,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'author') required String author,
    @JsonKey(name: 'kind') String? kind,
    @JsonKey(name: 'coverUrl') String? coverUrl,
    @JsonKey(name: 'intro') String? intro,
    @JsonKey(name: 'wordCount') String? wordCount,
    @JsonKey(name: 'latestChapterTitle') String? latestChapterTitle,
    @JsonKey(name: 'tocUrl') required String tocUrl,
    @JsonKey(name: 'time') int? time,
    @JsonKey(name: 'variable') String? variable,
    @JsonKey(name: 'originOrder') @Default(0) int originOrder,
    @JsonKey(name: 'chapterWordCountText') String? chapterWordCountText,
    @JsonKey(name: 'chapterWordCount') @Default(-1) int chapterWordCount,
    @JsonKey(name: 'respondTime') @Default(-1) int respondTime,
  }) = _SearchBook;

  factory SearchBook.fromJson(Map<String, dynamic> json) =>
      _$SearchBookFromJson(json);
}
