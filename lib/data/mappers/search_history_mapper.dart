import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/search_history.dart' as domain;

/// 搜索关键词历史数据映射器
class SearchHistoryMapper {
  /// 将 Drift 数据类转换为 Domain 模型
  domain.SearchKeyword fromTable(db.SearchKeyword table) {
    return domain.SearchKeyword(
      word: table.word,
      usage: table.usage,
      lastUseTime: table.lastUseTime,
    );
  }

  /// 批量转换
  List<domain.SearchKeyword> fromTableList(List<db.SearchKeyword> tables) {
    return tables.map(fromTable).toList();
  }

  /// 将 Domain 模型转换为 Drift Companion（用于插入/更新）
  db.SearchKeywordsCompanion toCompanion(domain.SearchKeyword model) {
    return db.SearchKeywordsCompanion(
      word: drift.Value(model.word),
      usage: drift.Value(model.usage),
      lastUseTime: drift.Value(model.lastUseTime),
    );
  }
}
