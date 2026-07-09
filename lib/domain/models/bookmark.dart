import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark.freezed.dart';
part 'bookmark.g.dart';

/// 书签
///
/// 对应原：Bookmark.kt
/// 存储在 bookmarks 表中
@freezed
abstract class Bookmark with _$Bookmark {
  const factory Bookmark({
    @JsonKey(name: 'time') int? time,
    @JsonKey(name: 'bookName') required String bookName,
    @JsonKey(name: 'bookAuthor') @Default('') String bookAuthor,
    @JsonKey(name: 'chapterIndex') @Default(0) int chapterIndex,
    @JsonKey(name: 'chapterPos') @Default(0) int chapterPos,
    @JsonKey(name: 'chapterName') required String chapterName,
    @JsonKey(name: 'bookText') required String bookText,
    @JsonKey(name: 'content') required String content,
  }) = _Bookmark;

  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);
}
