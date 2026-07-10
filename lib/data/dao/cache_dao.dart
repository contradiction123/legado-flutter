import 'package:drift/drift.dart';

import '../../core/database/app_database.dart' as db;
import '../../domain/models/cache.dart';
import '../mappers/cache_mapper.dart';

/// 缓存数据访问对象
class CacheDao {
  final db.AppDatabase _database;
  final _mapper = CacheMapper();

  CacheDao(this._database);

  /// 根据 key 获取缓存
  Future<Cache?> get(String key) async {
    final item = await (_database.select(
      _database.caches,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return item != null ? _mapper.fromTable(item) : null;
  }

  /// 获取所有缓存
  Future<List<Cache>> getAll() async {
    final items = await _database.select(_database.caches).get();
    return _mapper.fromTableList(items);
  }

  /// 设置缓存（插入或替换）
  Future<int> set(String key, String value, {int? deadline}) {
    return _database
        .into(_database.caches)
        .insertOnConflictUpdate(
          db.CachesCompanion(
            key: Value(key),
            value: Value(value),
            deadline: Value(deadline ?? 0),
          ),
        );
  }

  /// 根据 key 删除缓存
  Future<int> delete(String key) {
    return (_database.delete(
      _database.caches,
    )..where((t) => t.key.equals(key))).go();
  }

  /// 清空所有缓存
  Future<int> clear() {
    return _database.delete(_database.caches).go();
  }
}
