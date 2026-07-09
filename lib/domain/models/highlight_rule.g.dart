// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highlight_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HighlightRule _$HighlightRuleFromJson(Map<String, dynamic> json) =>
    _HighlightRule(
      id: json['id'] as String,
      name: json['name'] as String,
      pattern: json['pattern'] as String,
      sampleText: json['sampleText'] as String? ?? '',
      targetScope: (json['targetScope'] as num?)?.toInt() ?? 0,
      enabled: json['enabled'] as bool? ?? true,
      position: (json['position'] as num?)?.toInt() ?? 0,
      textColor: (json['textColor'] as num?)?.toInt(),
      bgColor: (json['bgColor'] as num?)?.toInt(),
      underlineMode: (json['underlineMode'] as num?)?.toInt() ?? 0,
      underlineColor: (json['underlineColor'] as num?)?.toInt(),
      underlineWidth: (json['underlineWidth'] as num?)?.toDouble() ?? 1.0,
      underlineOffset: (json['underlineOffset'] as num?)?.toDouble() ?? 2.0,
    );

Map<String, dynamic> _$HighlightRuleToJson(_HighlightRule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pattern': instance.pattern,
      'sampleText': instance.sampleText,
      'targetScope': instance.targetScope,
      'enabled': instance.enabled,
      'position': instance.position,
      'textColor': instance.textColor,
      'bgColor': instance.bgColor,
      'underlineMode': instance.underlineMode,
      'underlineColor': instance.underlineColor,
      'underlineWidth': instance.underlineWidth,
      'underlineOffset': instance.underlineOffset,
    };
