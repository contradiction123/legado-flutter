import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/rss_article.dart';
import '../../../domain/models/rss_source.dart';
import '../../reader/services/replace_rule_service.dart';
import 'rss_reader_screen.dart';
import '../providers/rss_provider.dart';

/// RSS 文章列表页面
///
/// 对标原：RssArticleActivity.kt
class RssArticleListScreen extends ConsumerStatefulWidget {
  final String sourceUrl;

  const RssArticleListScreen({super.key, required this.sourceUrl});

  @override
  ConsumerState<RssArticleListScreen> createState() =>
      _RssArticleListScreenState();
}

class _RssArticleListScreenState extends ConsumerState<RssArticleListScreen> {
  RssSource? _source;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(rssProvider.notifier);
      _source = notifier.getSource(widget.sourceUrl);
      notifier.loadArticles(widget.sourceUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rssProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_source?.sourceName ?? '文章列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '刷新',
            onPressed: () {
              ref.read(rssProvider.notifier).refreshSource(widget.sourceUrl);
            },
          ),
        ],
      ),
      body: _buildBody(state, theme),
    );
  }

  Widget _buildBody(RssState state, ThemeData theme) {
    if (state.isLoadingArticles) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.currentArticles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text('暂无文章', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('立即刷新'),
              onPressed: () {
                ref.read(rssProvider.notifier).refreshSource(widget.sourceUrl);
              },
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(rssProvider.notifier).refreshSource(widget.sourceUrl);
        ref.read(rssProvider.notifier).loadArticles(widget.sourceUrl);
      },
      child: ListView.builder(
        itemCount: state.currentArticles.length,
        itemBuilder: (context, index) {
          final article = state.currentArticles[index];
          return _buildArticleCard(article, theme);
        },
      ),
    );
  }

  Widget _buildArticleCard(RssArticle article, ThemeData theme) {
    final isRead = article.read;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: article.image != null && article.image!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  article.image!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.article,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                ),
              )
            : Icon(
                Icons.article,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
        title: Text(
          article.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            color: isRead
                ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
                : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.description != null && article.description!.isNotEmpty)
              Text(
                article.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            if (article.pubDate != null && article.pubDate!.isNotEmpty)
              Text(
                article.pubDate!,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  fontSize: 11,
                ),
              ),
          ],
        ),
        trailing: isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: () {
          // 标记已读
          ref
              .read(rssProvider.notifier)
              .markArticleRead(article.origin, article.link);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RssReaderScreen(article: article),
            ),
          );
        },
      ),
    );
  }
}
