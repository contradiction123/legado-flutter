import 'package:freezed_annotation/freezed_annotation.dart';

part 'read_config.freezed.dart';
part 'read_config.g.dart';

// ignore_for_file: non_abstract_class_inherits_abstract_member

/// 阅读配置（嵌套在 Book 中的 JSON）
///
/// 对应原：Book.ReadConfig（@Parcelize data class，通过 TypeConverter 序列化为 JSON）
/// 存储在 Book.readConfig 字段中
@freezed
abstract class ReadConfig with _$ReadConfig {
  const factory ReadConfig({
    @JsonKey(name: 'reverseToc') bool? reverseToc,
    @JsonKey(name: 'pageAnim') String? pageAnim,
    @JsonKey(name: 'reSegment') bool? reSegment,
    @JsonKey(name: 'imageStyle') int? imageStyle,
    @JsonKey(name: 'useReplaceRule') bool? useReplaceRule,
    @JsonKey(name: 'delTag') bool? delTag,
    @JsonKey(name: 'ttsEngine') String? ttsEngine,
    @JsonKey(name: 'splitLongChapter') bool? splitLongChapter,
    @JsonKey(name: 'readSimulating') bool? readSimulating,
    @JsonKey(name: 'startDate') String? startDate,
    @JsonKey(name: 'startChapter') int? startChapter,
    @JsonKey(name: 'dailyChapters') int? dailyChapters,
    @JsonKey(name: 'mangaColorFilter') String? mangaColorFilter,
    @JsonKey(name: 'mangaScrollMode') int? mangaScrollMode,
    @JsonKey(name: 'webtoonSidePaddingDp') int? webtoonSidePaddingDp,
    @JsonKey(name: 'mangaBackground') int? mangaBackground,
    @JsonKey(name: 'fixedType') int? fixedType,
    @JsonKey(name: 'translationMode') int? translationMode,
  }) = _ReadConfig;

  factory ReadConfig.fromJson(Map<String, dynamic> json) =>
      _$ReadConfigFromJson(json);
}
