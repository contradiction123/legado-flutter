import 'package:drift/drift.dart';

import '../../core/database/app_database.dart' as db;
import '../../domain/models/book_source.dart';
import '../mappers/book_source_mapper.dart';

/// 书源数据访问对象
class BookSourceDao {
  final db.AppDatabase _database;
  final _mapper = BookSourceMapper();

  BookSourceDao(this._database);

  /// 获取所有书源
  Future<List<BookSource>> getAll() async {
    final items = await _database.select(_database.bookSources).get();
    return _mapper.fromTableList(items);
  }

  /// 根据 URL 获取单个书源
  Future<BookSource?> getByUrl(String url) async {
    final item = await (_database.select(_database.bookSources)
          ..where((t) => t.bookSourceUrl.equals(url)))
        .getSingleOrNull();
    return item != null ? _mapper.fromTable(item) : null;
  }

  /// 获取所有已启用的书源
  Future<List<BookSource>> getEnabled() async {
    final items = await (_database.select(_database.bookSources)
          ..where((t) => t.enabled.equals(true)))
        .get();
    return _mapper.fromTableList(items);
  }

  /// 获取已启用且支持探索的书源
  Future<List<BookSource>> getEnabledExplore() async {
    final items = await (_database.select(_database.bookSources)
          ..where((t) =>
              t.enabled.equals(true) & t.enabledExplore.equals(true)))
        .get();
    return _mapper.fromTableList(items);
  }

  /// 按分组获取书源
  Future<List<BookSource>> getByGroup(String group) async {
    final items = await (_database.select(_database.bookSources)
          ..where((t) => t.bookSourceGroup.equals(group)))
        .get();
    return _mapper.fromTableList(items);
  }

  /// 搜索书源（按名称模糊匹配）
  Future<List<BookSource>> search(String keyword) async {
    final items = await (_database.select(_database.bookSources)
          ..where((t) => t.bookSourceName.like('%$keyword%')))
        .get();
    return _mapper.fromTableList(items);
  }

  /// 获取所有不重复的分组名称
  Future<List<String>> getDistinctGroups() async {
    final query = _database.selectOnly(_database.bookSources)
      ..addColumns([_database.bookSources.bookSourceGroup])
      ..where(_database.bookSources.bookSourceGroup.isNotNull() &
          _database.bookSources.enabled.equals(true) &
          _database.bookSources.enabledExplore.equals(true))
      ..groupBy([_database.bookSources.bookSourceGroup]);
    final rows = await query.get();
    return rows
        .map((r) => r.read(_database.bookSources.bookSourceGroup))
        .where((s) => s != null && s.isNotEmpty)
        .cast<String>()
        .toList();
  }

  /// 插入书源
  Future<int> insert(BookSource bookSource) {
    return _database.into(_database.bookSources).insert(
      db.BookSourcesCompanion(
        bookSourceUrl: Value(bookSource.bookSourceUrl),
        bookSourceName: Value(bookSource.bookSourceName),
        bookSourceGroup: bookSource.bookSourceGroup != null
            ? Value(bookSource.bookSourceGroup!)
            : const Value.absent(),
        bookSourceType: Value(bookSource.bookSourceType),
        enabled: Value(bookSource.enabled),
        enabledExplore: Value(bookSource.enabledExplore),
      ),
    );
  }

  /// 启用/禁用书源
  Future<int> setEnabled(String url, bool enabled) async {
    return (_database.update(_database.bookSources)
          ..where((t) => t.bookSourceUrl.equals(url)))
        .write(db.BookSourcesCompanion(enabled: Value(enabled)));
  }

  /// 删除书源
  Future<int> deleteByUrl(String url) {
    return (_database.delete(_database.bookSources)
          ..where((t) => t.bookSourceUrl.equals(url)))
        .go();
  }

  /// 获取书源总数
  Future<int> count() async {
    final all = await _database.select(_database.bookSources).get();
    return all.length;
  }
}
