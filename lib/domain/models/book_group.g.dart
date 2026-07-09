// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookGroup _$BookGroupFromJson(Map<String, dynamic> json) => _BookGroup(
  groupId: (json['groupId'] as num?)?.toInt() ?? 1,
  groupName: json['groupName'] as String,
  cover: json['cover'] as String?,
  order: (json['order'] as num?)?.toInt() ?? 0,
  enableRefresh: json['enableRefresh'] as bool? ?? true,
  show: json['show'] as bool? ?? true,
  bookSort: (json['bookSort'] as num?)?.toInt() ?? -1,
  isPrivate: json['isPrivate'] as bool? ?? false,
);

Map<String, dynamic> _$BookGroupToJson(_BookGroup instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'cover': instance.cover,
      'order': instance.order,
      'enableRefresh': instance.enableRefresh,
      'show': instance.show,
      'bookSort': instance.bookSort,
      'isPrivate': instance.isPrivate,
    };
