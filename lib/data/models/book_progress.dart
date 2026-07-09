import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_progress.freezed.dart';
part 'book_progress.g.dart';

// ignore_for_file: non_abstract_class_inherits_abstract_member

/// 书籍阅读进度（DTO，不对应数据库表）
///
/// 对应原：BookProgress.kt（非 @Entity，仅用于传输阅读进度数据）
@freezed
class BookProgress with _$BookProgress {
  const factory BookProgress({
    required String name,
    required String author,
    @Default(0) int durChapterIndex,
    @Default(0) int durChapterPos,
    @Default(0) int durChapterTime,
    String? durChapterTitle,
  }) = _BookProgress;

  factory BookProgress.fromJson(Map<String, dynamic> json) =>
      _$BookProgressFromJson(json);
}
