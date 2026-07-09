// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadRecord _$ReadRecordFromJson(Map<String, dynamic> json) => _ReadRecord(
  deviceId: json['deviceId'] as String,
  bookName: json['bookName'] as String,
  bookAuthor: json['bookAuthor'] as String? ?? '',
  readTime: (json['readTime'] as num?)?.toInt() ?? 0,
  lastRead: (json['lastRead'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ReadRecordToJson(_ReadRecord instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'bookName': instance.bookName,
      'bookAuthor': instance.bookAuthor,
      'readTime': instance.readTime,
      'lastRead': instance.lastRead,
    };
