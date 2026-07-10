// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dict_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DictRule _$DictRuleFromJson(Map<String, dynamic> json) => _DictRule(
  name: json['name'] as String,
  urlRule: json['urlRule'] as String? ?? '',
  showRule: json['showRule'] as String? ?? '',
  enabled: json['enabled'] as bool? ?? true,
  sortNumber: (json['sortNumber'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DictRuleToJson(_DictRule instance) => <String, dynamic>{
  'name': instance.name,
  'urlRule': instance.urlRule,
  'showRule': instance.showRule,
  'enabled': instance.enabled,
  'sortNumber': instance.sortNumber,
};
