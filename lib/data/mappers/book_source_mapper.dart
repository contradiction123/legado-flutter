import 'dart:convert';

import '../../core/database/app_database.dart' as db;
import '../../domain/models/book_source.dart';

/// 书源数据映射器
class BookSourceMapper {
  /// 将 Drift 数据类转换为 Domain 模型
  BookSource fromTable(db.BookSource table) {
    return BookSource(
      bookSourceUrl: table.bookSourceUrl,
      bookSourceName: table.bookSourceName,
      bookSourceGroup: table.bookSourceGroup,
      bookSourceType: table.bookSourceType,
      bookUrlPattern: table.bookUrlPattern,
      customOrder: table.customOrder,
      enabled: table.enabled,
      enabledExplore: table.enabledExplore,
      jsLib: table.jsLib,
      enabledCookieJar: table.enabledCookieJar,
      concurrentRate: table.concurrentRate,
      header: _parseHeader(table.header),
      loginUrl: table.loginUrl,
      loginUi: table.loginUi,
      loginCheckJs: table.loginCheckJs,
      coverDecodeJs: table.coverDecodeJs,
      bookSourceComment: table.bookSourceComment,
      variableComment: table.variableComment,
      lastUpdateTime: table.lastUpdateTime,
      respondTime: table.respondTime,
      weight: table.weight,
      exploreUrl: table.exploreUrl,
      exploreScreen: table.exploreScreen,
      ruleExplore: table.ruleExplore,
      searchUrl: table.searchUrl,
      ruleSearch: table.ruleSearch,
      ruleBookInfo: table.ruleBookInfo,
      ruleToc: table.ruleToc,
      ruleContent: table.ruleContent,
      ruleReview: table.ruleReview,
      eventListener: table.eventListener,
      customButton: table.customButton,
      homepageModules: table.homepageModules,
    );
  }

  /// 批量转换
  List<BookSource> fromTableList(List<db.BookSource> tables) {
    return tables.map(fromTable).toList();
  }

  Map<String, String>? _parseHeader(String? header) {
    if (header == null || header.isEmpty) return null;
    final decoded = jsonDecode(header);
    if (decoded is! Map<String, dynamic>) return null;
    return decoded.map((key, value) => MapEntry(key, value.toString()));
  }
}
