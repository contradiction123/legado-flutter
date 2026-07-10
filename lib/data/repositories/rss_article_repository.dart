import '../../data/dao/rss_article_dao.dart';
import '../../domain/models/rss_article.dart';

/// RSS 文章仓库
class RssArticleRepository {
  final RssArticleDao _dao;

  RssArticleRepository(this._dao);

  /// 获取某源的文章列表
  Future<List<RssArticle>> getByOrigin(String origin) =>
      _dao.getByOrigin(origin);

  /// 获取未读文章数
  Future<int> getUnreadCount(String origin) => _dao.getUnreadCount(origin);

  /// 标记已读
  Future<void> markAsRead(String origin, String link) =>
      _dao.markAsRead(origin, link);

  /// 更新阅读进度
  Future<void> updateProgress(String origin, String link, int durPos) =>
      _dao.updateProgress(origin, link, durPos);

  /// 批量插入文章
  Future<void> insertAll(List<RssArticle> articles) => _dao.insertAll(articles);
}
