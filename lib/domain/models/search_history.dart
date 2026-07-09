import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_history.freezed.dart';
part 'search_history.g.dart';

/// 搜索关键词历史
///
/// 对应原：SearchKeyword.kt
@freezed
abstract class SearchKeyword with _$SearchKeyword {
  const factory SearchKeyword({
    @JsonKey(name: 'word') required String word,
    @JsonKey(name: 'usage') @Default(1) int usage,
    @JsonKey(name: 'lastUseTime') @Default(0) int lastUseTime,
  }) = _SearchKeyword;

  factory SearchKeyword.fromJson(Map<String, dynamic> json) =>
      _$SearchKeywordFromJson(json);
}
