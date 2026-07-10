import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/rss_star.dart';

/// RSS 收藏数据访问对象
class RssStarDao {
  final db.AppDatabase _database;

  RssStarDao(this._database);

  /// 获取所有收藏文章
  Future<List<RssStar>> getAll() async {
    final items =
        await (_database.select(_database.rssStars)..orderBy([
              (t) => drift.OrderingTerm(
                expression: t.starTime,
                mode: drift.OrderingMode.desc,
              ),
            ]))
            .get();
    return items.map(_fromTable).toList();
  }

  /// 添加收藏
  Future<void> insert(RssStar star) async {
    await _database
        .into(_database.rssStars)
        .insert(
          db.RssStarsCompanion(
            origin: drift.Value(star.origin),
            sort: drift.Value(star.sort),
            title: drift.Value(star.title),
            starTime: drift.Value(star.starTime),
            link: drift.Value(star.link),
            pubDate: star.pubDate != null
                ? drift.Value(star.pubDate!)
                : drift.Value.absent(),
            description: star.description != null
                ? drift.Value(star.description!)
                : drift.Value.absent(),
            content: star.content != null
                ? drift.Value(star.content!)
                : drift.Value.absent(),
            image: star.image != null
                ? drift.Value(star.image!)
                : drift.Value.absent(),
            group: drift.Value(star.group),
            variable: star.variable != null
                ? drift.Value(star.variable!)
                : drift.Value.absent(),
            type: drift.Value(star.type),
            durPos: drift.Value(star.durPos),
          ),
        );
  }

  /// 取消收藏
  Future<void> delete(String origin, String link) async {
    await (_database.delete(
      _database.rssStars,
    )..where((t) => t.origin.equals(origin) & t.link.equals(link))).go();
  }

  /// 检查是否已收藏
  Future<bool> exists(String origin, String link) async {
    final item =
        await (_database.select(_database.rssStars)
              ..where((t) => t.origin.equals(origin) & t.link.equals(link)))
            .getSingleOrNull();
    return item != null;
  }

  RssStar _fromTable(db.RssStar table) {
    return RssStar(
      origin: table.origin,
      sort: table.sort,
      title: table.title,
      starTime: table.starTime,
      link: table.link,
      pubDate: table.pubDate,
      description: table.description,
      content: table.content,
      image: table.image,
      group: table.group,
      variable: table.variable,
      type: table.type,
      durPos: table.durPos,
    );
  }
}
