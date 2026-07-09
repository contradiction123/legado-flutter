// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'replace_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReplaceRule _$ReplaceRuleFromJson(Map<String, dynamic> json) => _ReplaceRule(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String? ?? '',
  group: json['group'] as String?,
  pattern: json['pattern'] as String? ?? '',
  replacement: json['replacement'] as String? ?? '',
  scope: json['scope'] as String?,
  scopeTitle: json['scopeTitle'] as bool? ?? false,
  scopeContent: json['scopeContent'] as bool? ?? true,
  excludeScope: json['excludeScope'] as String?,
  isEnabled: json['isEnabled'] as bool? ?? true,
  isRegex: json['isRegex'] as bool? ?? true,
  timeoutMillisecond: (json['timeoutMillisecond'] as num?)?.toInt() ?? 3000,
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ReplaceRuleToJson(_ReplaceRule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'group': instance.group,
      'pattern': instance.pattern,
      'replacement': instance.replacement,
      'scope': instance.scope,
      'scopeTitle': instance.scopeTitle,
      'scopeContent': instance.scopeContent,
      'excludeScope': instance.excludeScope,
      'isEnabled': instance.isEnabled,
      'isRegex': instance.isRegex,
      'timeoutMillisecond': instance.timeoutMillisecond,
      'order': instance.order,
    };
