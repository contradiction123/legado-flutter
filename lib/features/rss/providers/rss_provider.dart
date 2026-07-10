import 'package:flutter_riverpod/legacy.dart';

import '../../../data/dao/rss_article_dao.dart';
import '../../../data/dao/rss_source_dao.dart';
import '../../../data/dao/rss_star_dao.dart';
import '../../../data/dao/rss_read_record_dao.dart';
import '../../../domain/models/rss_article.dart';
import '../../../domain/models/rss_source.dart';
import '../../../domain/models/rss_star.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/network/dio_client.dart';
import '../../../engine/analyze_rule/analyze_rule.dart';
import '../engine/rss_parser_default.dart';
import '../engine/rss_parser_by_rule.dart';

/// RSS 状态管理
///
/// 对标原：RssRepository.kt
class RssProvider extends StateNotifier<RssState> {
  RssSourceDao? _sourceDao;
  RssArticleDao? _articleDao;
  RssStarDao? _starDao;
  RssReadRecordDao? _readRecordDao;
  DioClient? _dioClient;
  RssParserDefault? _defaultParser;
  RssParserByRule? _ruleParser;
  bool _initialized = false;

  RssProvider() : super(RssState());

  Future<void> _init() async {
    if (_initialized) return;
    final db = await databaseInstance;
    _sourceDao = RssSourceDao(db);
    _articleDao = RssArticleDao(db);
    _starDao = RssStarDao(db);
    _readRecordDao = RssReadRecordDao(db);
    _dioClient = dioClient;
    _defaultParser = RssParserDefault();
    _ruleParser = RssParserByRule(_dioClient!, AnalyzeRule());
    _initialized = true;
  }

  /// 加载 RSS 源列表
  Future<void> loadSources() async {
    await _init();
    state = state.copyWith(isLoading: true);
    try {
      final sources = await _sourceDao!.getAll();
      final unreadCounts = <String, int>{};
      for (final s in sources) {
        unreadCounts[s.sourceUrl] = await _articleDao!.getUnreadCount(
          s.sourceUrl,
        );
      }
      state = state.copyWith(
        isLoading: false,
        sources: sources,
        unreadCounts: unreadCounts,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 获取 RSS 源
  RssSource? getSource(String url) {
    try {
      return state.sources.where((s) => s.sourceUrl == url).firstOrNull;
    } catch (_) {
      return null;
    }
  }

  /// 添加 RSS 源
  Future<void> addSource(RssSource source) async {
    await _init();
    try {
      await _sourceDao!.insert(source);
      await loadSources();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 删除 RSS 源
  Future<void> deleteSource(String url) async {
    await _init();
    try {
      await _sourceDao!.deleteByUrl(url);
      await loadSources();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 刷新 RSS 源（获取文章）
  Future<void> refreshSource(String sourceUrl) async {
    await _init();
    final source = getSource(sourceUrl);
    if (source == null) return;

    state = state.copyWith(
      refreshingUrls: {...state.refreshingUrls, sourceUrl},
    );

    try {
      List<RssArticleItem> items;

      // 如果有自定义规则，使用规则解析器
      if (_hasCustomRules(source)) {
        items = await _ruleParser!.parse(source);
      } else {
        // 否则使用标准 RSS/Atom 解析器
        final response = await _dioClient!.dio.get(source.sourceUrl);
        final xmlContent = response.data as String;
        items = _defaultParser!.parse(xmlContent, source);
      }

      // 转换为文章列表
      final articles = items.asMap().entries.map((entry) {
        final i = entry.value;
        return RssArticle(
          origin: source.sourceUrl,
          sort: source.sourceName,
          title: i.title,
          order: items.length - entry.key,
          link: i.link,
          pubDate: i.pubDate,
          description: i.description,
          content: i.content,
          image: i.image,
          group: source.sourceGroup ?? '默认分组',
          read: false,
          type: source.type,
          durPos: 0,
        );
      }).toList();

      // 批量存入数据库
      if (articles.isNotEmpty) {
        await _articleDao!.insertAll(articles);
      }

      // 重新加载
      await loadSources();
      state = state.copyWith(
        refreshingUrls: state.refreshingUrls
            .where((u) => u != sourceUrl)
            .toSet(),
        lastRefreshTime: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        refreshingUrls: state.refreshingUrls
            .where((u) => u != sourceUrl)
            .toSet(),
        error: '刷新失败: $e',
      );
    }
  }

  /// 加载某源的文章列表
  Future<void> loadArticles(String origin) async {
    await _init();
    state = state.copyWith(currentArticles: [], isLoadingArticles: true);
    try {
      final articles = await _articleDao!.getByOrigin(origin);
      state = state.copyWith(
        currentArticles: articles,
        isLoadingArticles: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingArticles: false, error: e.toString());
    }
  }

  /// 标记文章已读
  Future<void> markArticleRead(String origin, String link) async {
    await _init();
    await _articleDao!.markAsRead(origin, link);
    state = state.copyWith(
      currentArticles: state.currentArticles.map((a) {
        if (a.link == link && a.origin == origin) {
          return a.copyWith(read: true);
        }
        return a;
      }).toList(),
    );
  }

  /// 更新文章阅读进度
  Future<void> updateArticleProgress(
    String origin,
    String link,
    int durPos,
  ) async {
    await _init();
    await _articleDao!.updateProgress(origin, link, durPos);
  }

  /// 加载收藏列表
  Future<void> loadFavorites() async {
    await _init();
    state = state.copyWith(isLoadingFavorites: true);
    try {
      final favorites = await _starDao!.getAll();
      state = state.copyWith(favorites: favorites, isLoadingFavorites: false);
    } catch (e) {
      state = state.copyWith(isLoadingFavorites: false, error: e.toString());
    }
  }

  /// 切换收藏
  Future<void> toggleFavorite(RssArticle article) async {
    await _init();
    final exists = await _starDao!.exists(article.origin, article.link);
    if (exists) {
      await _starDao!.delete(article.origin, article.link);
    } else {
      await _starDao!.insert(
        RssStar(
          origin: article.origin,
          sort: article.sort,
          title: article.title,
          starTime: DateTime.now().millisecondsSinceEpoch,
          link: article.link,
          pubDate: article.pubDate,
          description: article.description,
          content: article.content,
          image: article.image,
          group: article.group,
          type: article.type,
          durPos: article.durPos,
        ),
      );
    }
    await loadFavorites();
  }

  /// 检查是否已收藏
  Future<bool> isFavorited(String origin, String link) async {
    await _init();
    return _starDao!.exists(origin, link);
  }

  bool _hasCustomRules(RssSource source) {
    return source.ruleArticles != null && source.ruleArticles!.isNotEmpty;
  }
}

/// RSS 状态
class RssState {
  final bool isLoading;
  final List<RssSource> sources;
  final Map<String, int> unreadCounts;
  final Set<String> refreshingUrls;
  final String? error;
  final List<RssArticle> currentArticles;
  final bool isLoadingArticles;
  final List<RssStar> favorites;
  final bool isLoadingFavorites;
  final DateTime? lastRefreshTime;

  const RssState({
    this.isLoading = false,
    this.sources = const [],
    this.unreadCounts = const {},
    this.refreshingUrls = const {},
    this.error,
    this.currentArticles = const [],
    this.isLoadingArticles = false,
    this.favorites = const [],
    this.isLoadingFavorites = false,
    this.lastRefreshTime,
  });

  RssState copyWith({
    bool? isLoading,
    List<RssSource>? sources,
    Map<String, int>? unreadCounts,
    Set<String>? refreshingUrls,
    String? error,
    List<RssArticle>? currentArticles,
    bool? isLoadingArticles,
    List<RssStar>? favorites,
    bool? isLoadingFavorites,
    DateTime? lastRefreshTime,
    bool clearError = false,
  }) {
    return RssState(
      isLoading: isLoading ?? this.isLoading,
      sources: sources ?? this.sources,
      unreadCounts: unreadCounts ?? this.unreadCounts,
      refreshingUrls: refreshingUrls ?? this.refreshingUrls,
      error: clearError ? null : (error ?? this.error),
      currentArticles: currentArticles ?? this.currentArticles,
      isLoadingArticles: isLoadingArticles ?? this.isLoadingArticles,
      favorites: favorites ?? this.favorites,
      isLoadingFavorites: isLoadingFavorites ?? this.isLoadingFavorites,
      lastRefreshTime: lastRefreshTime ?? this.lastRefreshTime,
    );
  }
}

final rssProvider = StateNotifierProvider<RssProvider, RssState>((ref) {
  return RssProvider();
});
