import 'package:drift/drift.dart';

import '../../core/database/app_database.dart' as db;
import '../../domain/models/search_history.dart';
import '../mappers/search_history_mapper.dart';

/// 搜索关键词历史数据访问对象
class SearchHistoryDao {
  final db.AppDatabase _database;
  final _mapper = SearchHistoryMapper();

  SearchHistoryDao(this._database);

  /// 获取所有搜索关键词（按最后使用时间降序）
  Future<List<SearchKeyword>> getAll() async {
    final items = await (_database.select(
      _database.searchKeywords,
    )..orderBy([(t) => OrderingTerm.desc(t.lastUseTime)])).get();
    return _mapper.fromTableList(items);
  }

  /// 搜索关键词（按关键词模糊匹配）
  Future<List<SearchKeyword>> search(String keyword) async {
    final items =
        await (_database.select(_database.searchKeywords)
              ..where((t) => t.word.like('%$keyword%'))
              ..orderBy([(t) => OrderingTerm.desc(t.lastUseTime)]))
            .get();
    return _mapper.fromTableList(items);
  }

  /// 添加搜索关键词（存在则增加使用次数并更新时间）
  Future<void> add(String word) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final existing = await (_database.select(
      _database.searchKeywords,
    )..where((t) => t.word.equals(word))).getSingleOrNull();

    if (existing != null) {
      await (_database.update(
        _database.searchKeywords,
      )..where((t) => t.word.equals(word))).write(
        db.SearchKeywordsCompanion(
          usage: Value(existing.usage + 1),
          lastUseTime: Value(now),
        ),
      );
    } else {
      await _database
          .into(_database.searchKeywords)
          .insert(
            db.SearchKeywordsCompanion(
              word: Value(word),
              lastUseTime: Value(now),
            ),
          );
    }
  }

  /// 删除搜索关键词
  Future<int> delete(String word) {
    return (_database.delete(
      _database.searchKeywords,
    )..where((t) => t.word.equals(word))).go();
  }

  /// 清空所有搜索关键词
  Future<int> clear() {
    return _database.delete(_database.searchKeywords).go();
  }
}
