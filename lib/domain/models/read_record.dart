import 'package:freezed_annotation/freezed_annotation.dart';

part 'read_record.freezed.dart';
part 'read_record.g.dart';

/// 阅读记录
///
/// 对应原：ReadRecord.kt
/// 存储在 readRecord 表中
@freezed
abstract class ReadRecord with _$ReadRecord {
  const factory ReadRecord({
    @JsonKey(name: 'deviceId') required String deviceId,
    @JsonKey(name: 'bookName') required String bookName,
    @JsonKey(name: 'bookAuthor') @Default('') String bookAuthor,
    @JsonKey(name: 'readTime') @Default(0) int readTime,
    @JsonKey(name: 'lastRead') @Default(0) int lastRead,
  }) = _ReadRecord;

  factory ReadRecord.fromJson(Map<String, dynamic> json) =>
      _$ReadRecordFromJson(json);
}
