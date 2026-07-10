import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/book_info_rule.dart';
import '../../data/models/content_rule.dart';
import '../../data/models/explore_rule.dart';
import '../../data/models/review_rule.dart';
import '../../data/models/search_rule.dart';
import '../../data/models/toc_rule.dart';

part 'book_source.freezed.dart';
part 'book_source.g.dart';

/// 书源
///
/// 对应原：BookSource.kt（实现 BaseSource 接口）
/// 存储在 book_sources 表中
@freezed
abstract class BookSource with _$BookSource {
  const factory BookSource({
    @JsonKey(name: 'bookSourceUrl') required String bookSourceUrl,
    @JsonKey(name: 'bookSourceName') required String bookSourceName,
    @JsonKey(name: 'bookSourceGroup') String? bookSourceGroup,
    @JsonKey(name: 'bookSourceType') @Default(0) int bookSourceType,
    @JsonKey(name: 'bookUrlPattern') String? bookUrlPattern,
    @JsonKey(name: 'customOrder') @Default(0) int customOrder,
    @JsonKey(name: 'enabled') @Default(true) bool enabled,
    @JsonKey(name: 'enabledExplore') @Default(true) bool enabledExplore,
    @JsonKey(name: 'jsLib') String? jsLib,
    @JsonKey(name: 'enabledCookieJar') bool? enabledCookieJar,
    @JsonKey(name: 'concurrentRate') String? concurrentRate,
    @JsonKey(name: 'header') Map<String, String>? header,
    @JsonKey(name: 'loginUrl') String? loginUrl,
    @JsonKey(name: 'loginUi') String? loginUi,
    @JsonKey(name: 'loginCheckJs') String? loginCheckJs,
    @JsonKey(name: 'coverDecodeJs') String? coverDecodeJs,
    @JsonKey(name: 'bookSourceComment') String? bookSourceComment,
    @JsonKey(name: 'variableComment') String? variableComment,
    @JsonKey(name: 'lastUpdateTime') @Default(0) int lastUpdateTime,
    @JsonKey(name: 'respondTime') @Default(180000) int respondTime,
    @JsonKey(name: 'weight') @Default(0) int weight,
    @JsonKey(name: 'exploreUrl') String? exploreUrl,
    @JsonKey(name: 'exploreScreen') String? exploreScreen,
    @JsonKey(name: 'ruleExplore') String? ruleExplore,
    @JsonKey(name: 'searchUrl') String? searchUrl,
    @JsonKey(name: 'ruleSearch') String? ruleSearch,
    @JsonKey(name: 'ruleBookInfo') String? ruleBookInfo,
    @JsonKey(name: 'ruleToc') String? ruleToc,
    @JsonKey(name: 'ruleContent') String? ruleContent,
    @JsonKey(name: 'ruleReview') String? ruleReview,
    @JsonKey(name: 'eventListener') @Default(false) bool eventListener,
    @JsonKey(name: 'customButton') @Default(false) bool customButton,
    @JsonKey(name: 'homepageModules') String? homepageModules,
  }) = _BookSource;

  factory BookSource.fromJson(Map<String, dynamic> json) =>
      _$BookSourceFromJson(json);
}

extension BookSourceX on BookSource {
  /// 便捷方法：解析规则 JSON 字符串
  /// 调用前需确保 ruleSearch 等字段不为空
  SearchRule? parseRuleSearch() =>
      ruleSearch != null ? SearchRule.fromJson(_parseJson(ruleSearch!)) : null;

  BookInfoRule? parseRuleBookInfo() => ruleBookInfo != null
      ? BookInfoRule.fromJson(_parseJson(ruleBookInfo!))
      : null;

  TocRule? parseRuleToc() =>
      ruleToc != null ? TocRule.fromJson(_parseJson(ruleToc!)) : null;

  ContentRule? parseRuleContent() => ruleContent != null
      ? ContentRule.fromJson(_parseJson(ruleContent!))
      : null;

  ExploreRule? parseRuleExplore() => ruleExplore != null
      ? ExploreRule.fromJson(_parseJson(ruleExplore!))
      : null;

  ReviewRule? parseRuleReview() =>
      ruleReview != null ? ReviewRule.fromJson(_parseJson(ruleReview!)) : null;

  /// 将 JSON 字符串解析为 Map
  static Map<String, dynamic> _parseJson(String json) {
    return const JsonDecoder().convert(json) as Map<String, dynamic>;
  }
}
