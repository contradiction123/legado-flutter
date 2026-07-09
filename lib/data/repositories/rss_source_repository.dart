import '../../data/dao/rss_source_dao.dart';
import '../../domain/models/rss_source.dart';

/// RSS 订阅源仓库
class RssSourceRepository {
  final RssSourceDao _dao;

  RssSourceRepository(this._dao);

  /// 获取所有 RSS 订阅源
  Future<List<RssSource>> getAll() => _dao.getAll();

  /// 获取所有已启用的 RSS 订阅源
  Future<List<RssSource>> getEnabled() => _dao.getEnabled();

  /// 按分组获取 RSS 订阅源
  Future<List<RssSource>> getByGroup(String group) => _dao.getByGroup(group);

  /// 根据 URL 获取 RSS 订阅源
  Future<RssSource?> getByUrl(String url) => _dao.getByUrl(url);

  /// 添加 RSS 订阅源
  Future<void> add(RssSource source) => _dao.insert(source);

  /// 根据 URL 删除 RSS 订阅源
  Future<void> deleteByUrl(String url) => _dao.deleteByUrl(url);
}
