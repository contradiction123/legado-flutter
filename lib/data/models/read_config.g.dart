// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadConfig _$ReadConfigFromJson(Map<String, dynamic> json) => _ReadConfig(
  reverseToc: json['reverseToc'] as bool?,
  pageAnim: json['pageAnim'] as String?,
  reSegment: json['reSegment'] as bool?,
  imageStyle: (json['imageStyle'] as num?)?.toInt(),
  useReplaceRule: json['useReplaceRule'] as bool?,
  delTag: json['delTag'] as bool?,
  ttsEngine: json['ttsEngine'] as String?,
  splitLongChapter: json['splitLongChapter'] as bool?,
  readSimulating: json['readSimulating'] as bool?,
  startDate: json['startDate'] as String?,
  startChapter: (json['startChapter'] as num?)?.toInt(),
  dailyChapters: (json['dailyChapters'] as num?)?.toInt(),
  mangaColorFilter: json['mangaColorFilter'] as String?,
  mangaScrollMode: (json['mangaScrollMode'] as num?)?.toInt(),
  webtoonSidePaddingDp: (json['webtoonSidePaddingDp'] as num?)?.toInt(),
  mangaBackground: (json['mangaBackground'] as num?)?.toInt(),
  fixedType: (json['fixedType'] as num?)?.toInt(),
  translationMode: (json['translationMode'] as num?)?.toInt(),
);

Map<String, dynamic> _$ReadConfigToJson(_ReadConfig instance) =>
    <String, dynamic>{
      'reverseToc': instance.reverseToc,
      'pageAnim': instance.pageAnim,
      'reSegment': instance.reSegment,
      'imageStyle': instance.imageStyle,
      'useReplaceRule': instance.useReplaceRule,
      'delTag': instance.delTag,
      'ttsEngine': instance.ttsEngine,
      'splitLongChapter': instance.splitLongChapter,
      'readSimulating': instance.readSimulating,
      'startDate': instance.startDate,
      'startChapter': instance.startChapter,
      'dailyChapters': instance.dailyChapters,
      'mangaColorFilter': instance.mangaColorFilter,
      'mangaScrollMode': instance.mangaScrollMode,
      'webtoonSidePaddingDp': instance.webtoonSidePaddingDp,
      'mangaBackground': instance.mangaBackground,
      'fixedType': instance.fixedType,
      'translationMode': instance.translationMode,
    };
