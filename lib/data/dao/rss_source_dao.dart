import '../../core/database/app_database.dart' as db;
import '../../domain/models/rss_source.dart';
import '../mappers/rss_source_mapper.dart';

/// RSS 订阅源数据访问对象
class RssSourceDao {
  final db.AppDatabase _database;
  final _mapper = RssSourceMapper();

  RssSourceDao(this._database);

  /// 获取所有 RSS 订阅源
  Future<List<RssSource>> getAll() async {
    final items = await _database.select(_database.rssSources).get();
    return _mapper.fromTableList(items);
  }

  /// 获取所有已启用的 RSS 订阅源
  Future<List<RssSource>> getEnabled() async {
    final items = await (_database.select(_database.rssSources)
          ..where((t) => t.enabled.equals(true)))
        .get();
    return _mapper.fromTableList(items);
  }

  /// 按分组获取 RSS 订阅源
  Future<List<RssSource>> getByGroup(String group) async {
    final items = await (_database.select(_database.rssSources)
          ..where((t) => t.sourceGroup.equals(group)))
        .get();
    return _mapper.fromTableList(items);
  }

  /// 根据 URL 获取单个 RSS 订阅源
  Future<RssSource?> getByUrl(String url) async {
    final item = await (_database.select(_database.rssSources)
          ..where((t) => t.sourceUrl.equals(url)))
        .getSingleOrNull();
    return item != null ? _mapper.fromTable(item) : null;
  }

  /// 插入 RSS 订阅源
  Future<int> insert(RssSource rssSource) {
    return _database.into(_database.rssSources).insert(
      _mapper.toCompanion(rssSource),
    );
  }

  /// 根据 URL 删除 RSS 订阅源
  Future<int> deleteByUrl(String url) {
    return (_database.delete(_database.rssSources)
          ..where((t) => t.sourceUrl.equals(url)))
        .go();
  }
}
