import '../../data/dao/rss_star_dao.dart';
import '../../domain/models/rss_star.dart';

/// RSS 收藏仓库
class RssStarRepository {
  final RssStarDao _dao;

  RssStarRepository(this._dao);

  /// 获取所有收藏
  Future<List<RssStar>> getAll() => _dao.getAll();

  /// 添加收藏
  Future<void> add(RssStar star) => _dao.insert(star);

  /// 取消收藏
  Future<void> remove(String origin, String link) => _dao.delete(origin, link);

  /// 检查是否已收藏
  Future<bool> exists(String origin, String link) => _dao.exists(origin, link);
}
