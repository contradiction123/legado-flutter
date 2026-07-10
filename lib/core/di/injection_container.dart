import 'package:get_it/get_it.dart';

import '../database/app_database.dart';
import '../logging/app_logger.dart';
import '../network/dio_client.dart';

import '../../data/dao/book_dao.dart';
import '../../data/dao/book_source_dao.dart';
import '../../data/dao/bookmark_dao.dart';
import '../../data/dao/book_group_dao.dart';
import '../../data/dao/cache_dao.dart';
import '../../data/dao/chapter_dao.dart';
import '../../data/dao/cookie_dao.dart';
import '../../data/dao/highlight_rule_dao.dart';
import '../../data/dao/read_record_dao.dart';
import '../../data/dao/replace_rule_dao.dart';
import '../../data/dao/rss_source_dao.dart';
import '../../data/dao/rss_article_dao.dart';
import '../../data/dao/rss_star_dao.dart';
import '../../data/dao/rss_read_record_dao.dart';
import '../../data/dao/dict_rule_dao.dart';
import '../../data/dao/search_book_dao.dart';
import '../../data/dao/search_history_dao.dart';

// Mappers (仅 DI 注册时需要手动传递的场景)
import '../../data/mappers/book_mapper.dart';
import '../../data/mappers/book_group_mapper.dart';
import '../../data/mappers/chapter_mapper.dart';

// Repositories
import '../../data/repositories/book_repository.dart';
import '../../data/repositories/book_source_repository.dart';
import '../../data/repositories/bookmark_repository.dart';
import '../../data/repositories/book_group_repository.dart';
import '../../data/repositories/cache_repository.dart';
import '../../data/repositories/chapter_repository.dart';
import '../../data/repositories/cookie_repository.dart';
import '../../data/repositories/highlight_rule_repository.dart';
import '../../data/repositories/read_progress_repository.dart';
import '../../data/repositories/replace_rule_repository.dart';
import '../../data/repositories/rss_source_repository.dart';
import '../../data/repositories/rss_article_repository.dart';
import '../../data/repositories/rss_star_repository.dart';
import '../../data/repositories/dict_rule_repository.dart';
import '../../data/repositories/search_repository.dart';
import '../../data/repositories/search_history_repository.dart';

/// 全局依赖注入容器
///
/// 对标原：Koin appModule.kt + appDatabaseModule.kt
/// 使用 get_it 替代 Koin，手动注册所有全局单例
final sl = GetIt.instance;

/// 初始化依赖注入
Future<void> initDependencyInjection() async {
  await AppLogger.instance.initialize();

  // ═══════════════════════════════════════════════════════════════════
  // 基础设施（懒加载单例）
  // ═══════════════════════════════════════════════════════════════════
  sl.registerLazySingletonAsync<AppDatabase>(
    () => AppDatabase.create(logger: AppLogger.instance),
  );

  sl.registerLazySingleton<DioClient>(() => DioClient.instance);

  // ═══════════════════════════════════════════════════════════════════
  // DAO 层（懒加载单例，依赖 AppDatabase）
  // ═══════════════════════════════════════════════════════════════════
  sl.registerLazySingletonAsync<BookDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return BookDao(db);
  });

  sl.registerLazySingletonAsync<BookSourceDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return BookSourceDao(db);
  });

  sl.registerLazySingletonAsync<BookmarkDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return BookmarkDao(db);
  });

  sl.registerLazySingletonAsync<BookGroupDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return BookGroupDao(db);
  });

  sl.registerLazySingletonAsync<CacheDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return CacheDao(db);
  });

  sl.registerLazySingletonAsync<ChapterDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return ChapterDao(db);
  });

  sl.registerLazySingletonAsync<CookieDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return CookieDao(db);
  });

  sl.registerLazySingletonAsync<HighlightRuleDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return HighlightRuleDao(db);
  });

  sl.registerLazySingletonAsync<ReadRecordDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return ReadRecordDao(db);
  });

  sl.registerLazySingletonAsync<ReplaceRuleDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return ReplaceRuleDao(db);
  });

  sl.registerLazySingletonAsync<RssSourceDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return RssSourceDao(db);
  });

  sl.registerLazySingletonAsync<RssArticleDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return RssArticleDao(db);
  });

  sl.registerLazySingletonAsync<RssStarDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return RssStarDao(db);
  });

  sl.registerLazySingletonAsync<RssReadRecordDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return RssReadRecordDao(db);
  });

  sl.registerLazySingletonAsync<DictRuleDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return DictRuleDao(db);
  });

  sl.registerLazySingletonAsync<SearchBookDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return SearchBookDao(db);
  });

  sl.registerLazySingletonAsync<SearchHistoryDao>(() async {
    final db = await sl.getAsync<AppDatabase>();
    return SearchHistoryDao(db);
  });

  // ═══════════════════════════════════════════════════════════════════
  // Repository 层（懒加载单例，依赖 DAO）
  // ═══════════════════════════════════════════════════════════════════
  sl.registerLazySingletonAsync<BookRepository>(() async {
    final dao = await sl.getAsync<BookDao>();
    return BookRepository(dao, BookMapper());
  });

  sl.registerLazySingletonAsync<BookSourceRepository>(() async {
    final dao = await sl.getAsync<BookSourceDao>();
    return BookSourceRepository(dao);
  });

  sl.registerLazySingletonAsync<BookmarkRepository>(() async {
    final dao = await sl.getAsync<BookmarkDao>();
    return BookmarkRepository(dao);
  });

  sl.registerLazySingletonAsync<BookGroupRepository>(() async {
    final dao = await sl.getAsync<BookGroupDao>();
    return BookGroupRepository(dao, BookGroupMapper());
  });

  sl.registerLazySingletonAsync<CacheRepository>(() async {
    final dao = await sl.getAsync<CacheDao>();
    return CacheRepository(dao);
  });

  sl.registerLazySingletonAsync<ChapterRepository>(() async {
    final dao = await sl.getAsync<ChapterDao>();
    return ChapterRepository(dao, ChapterMapper());
  });

  sl.registerLazySingletonAsync<CookieRepository>(() async {
    final dao = await sl.getAsync<CookieDao>();
    return CookieRepository(dao);
  });

  sl.registerLazySingletonAsync<HighlightRuleRepository>(() async {
    final dao = await sl.getAsync<HighlightRuleDao>();
    return HighlightRuleRepository(dao);
  });

  sl.registerLazySingletonAsync<ReadProgressRepository>(() async {
    final dao = await sl.getAsync<ReadRecordDao>();
    return ReadProgressRepository(dao);
  });

  sl.registerLazySingletonAsync<ReplaceRuleRepository>(() async {
    final dao = await sl.getAsync<ReplaceRuleDao>();
    return ReplaceRuleRepository(dao);
  });

  sl.registerLazySingletonAsync<RssSourceRepository>(() async {
    final dao = await sl.getAsync<RssSourceDao>();
    return RssSourceRepository(dao);
  });

  sl.registerLazySingletonAsync<RssArticleRepository>(() async {
    final dao = await sl.getAsync<RssArticleDao>();
    return RssArticleRepository(dao);
  });

  sl.registerLazySingletonAsync<RssStarRepository>(() async {
    final dao = await sl.getAsync<RssStarDao>();
    return RssStarRepository(dao);
  });

  sl.registerLazySingletonAsync<DictRuleRepository>(() async {
    final dao = await sl.getAsync<DictRuleDao>();
    return DictRuleRepository(dao);
  });

  sl.registerLazySingletonAsync<SearchRepository>(() async {
    final dao = await sl.getAsync<SearchBookDao>();
    final db = await sl.getAsync<AppDatabase>();
    return SearchRepository(dao, db);
  });

  sl.registerLazySingletonAsync<SearchHistoryRepository>(() async {
    final dao = await sl.getAsync<SearchHistoryDao>();
    return SearchHistoryRepository(dao);
  });
}

/// 获取数据库实例（便捷方法）
Future<AppDatabase> get databaseInstance async =>
    await sl.getAsync<AppDatabase>();

/// 获取 Dio 客户端（便捷方法）
DioClient get dioClient => sl<DioClient>();
