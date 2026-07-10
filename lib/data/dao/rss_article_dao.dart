import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/rss_article.dart';

/// RSS 文章数据访问对象
class RssArticleDao {
  final db.AppDatabase _database;

  RssArticleDao(this._database);

  /// 根据源和分组获取文章列表
  Future<List<RssArticle>> getByOrigin(String origin) async {
    final items =
        await (_database.select(_database.rssArticles)
              ..where((t) => t.origin.equals(origin))
              ..orderBy([
                (t) => drift.OrderingTerm(
                  expression: t.order,
                  mode: drift.OrderingMode.desc,
                ),
              ]))
            .get();
    return items.map(_fromTable).toList();
  }

  /// 获取未读文章数
  Future<int> getUnreadCount(String origin) async {
    final count = await (_database.select(
      _database.rssArticles,
    )..where((t) => t.origin.equals(origin) & t.read.equals(false))).get();
    return count.length;
  }

  /// 更新文章已读状态
  Future<void> markAsRead(String origin, String link) async {
    await (_database.update(_database.rssArticles)
          ..where((t) => t.origin.equals(origin) & t.link.equals(link)))
        .write(db.RssArticlesCompanion(read: drift.Value(true)));
  }

  /// 更新文章阅读进度
  Future<void> updateProgress(String origin, String link, int durPos) async {
    await (_database.update(_database.rssArticles)
          ..where((t) => t.origin.equals(origin) & t.link.equals(link)))
        .write(db.RssArticlesCompanion(durPos: drift.Value(durPos)));
  }

  /// 批量插入文章
  Future<void> insertAll(List<RssArticle> articles) async {
    for (final article in articles) {
      await _database
          .into(_database.rssArticles)
          .insertOnConflictUpdate(
            db.RssArticlesCompanion(
              origin: drift.Value(article.origin),
              sort: drift.Value(article.sort),
              title: drift.Value(article.title),
              order: drift.Value(article.order),
              link: drift.Value(article.link),
              pubDate: article.pubDate != null
                  ? drift.Value(article.pubDate!)
                  : drift.Value.absent(),
              description: article.description != null
                  ? drift.Value(article.description!)
                  : drift.Value.absent(),
              content: article.content != null
                  ? drift.Value(article.content!)
                  : drift.Value.absent(),
              image: article.image != null
                  ? drift.Value(article.image!)
                  : drift.Value.absent(),
              group: drift.Value(article.group),
              read: drift.Value(article.read),
              variable: article.variable != null
                  ? drift.Value(article.variable!)
                  : drift.Value.absent(),
              type: drift.Value(article.type),
              durPos: drift.Value(article.durPos),
            ),
          );
    }
  }

  RssArticle _fromTable(db.RssArticle table) {
    return RssArticle(
      origin: table.origin,
      sort: table.sort,
      title: table.title,
      order: table.order,
      link: table.link,
      pubDate: table.pubDate,
      description: table.description,
      content: table.content,
      image: table.image,
      group: table.group,
      read: table.read,
      variable: table.variable,
      type: table.type,
      durPos: table.durPos,
    );
  }
}
