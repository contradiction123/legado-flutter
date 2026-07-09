import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_group.freezed.dart';
part 'book_group.g.dart';

/// 书籍分组
///
/// 对应原：BookGroup.kt
/// 存储在 book_groups 表中
@freezed
abstract class BookGroup with _$BookGroup {
  const factory BookGroup({
    @JsonKey(name: 'groupId') @Default(1) int groupId,
    @JsonKey(name: 'groupName') required String groupName,
    @JsonKey(name: 'cover') String? cover,
    @JsonKey(name: 'order') @Default(0) int order,
    @JsonKey(name: 'enableRefresh') @Default(true) bool enableRefresh,
    @JsonKey(name: 'show') @Default(true) bool show,
    @JsonKey(name: 'bookSort') @Default(-1) int bookSort,
    @JsonKey(name: 'isPrivate') @Default(false) bool isPrivate,
  }) = _BookGroup;

  factory BookGroup.fromJson(Map<String, dynamic> json) =>
      _$BookGroupFromJson(json);
}
