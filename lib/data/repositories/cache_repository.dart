import '../../data/dao/cache_dao.dart';

/// 缓存仓库
class CacheRepository {
  final CacheDao _dao;

  CacheRepository(this._dao);

  /// 根据 key 获取缓存值
  Future<String?> get(String key) async {
    final c = await _dao.get(key);
    return c?.value;
  }

  /// 设置缓存
  Future<void> set(String key, String value, {int? deadline}) =>
      _dao.set(key, value, deadline: deadline);

  /// 根据 key 删除缓存
  Future<void> delete(String key) => _dao.delete(key);

  /// 清空所有缓存
  Future<void> clear() => _dao.clear();
}
