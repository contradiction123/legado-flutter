// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Cache _$CacheFromJson(Map<String, dynamic> json) => _Cache(
  key: json['key'] as String,
  value: json['value'] as String?,
  deadline: (json['deadline'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CacheToJson(_Cache instance) => <String, dynamic>{
  'key': instance.key,
  'value': instance.value,
  'deadline': instance.deadline,
};
