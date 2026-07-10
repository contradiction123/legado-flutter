import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/rss_article.dart';
import '../../../domain/models/rss_star.dart';
import 'rss_reader_screen.dart';
import '../providers/rss_provider.dart';

/// RSS 收藏页面
///
/// 对标原：RssFavoritesActivity.kt
class RssFavoritesScreen extends ConsumerStatefulWidget {
  const RssFavoritesScreen({super.key});

  @override
  ConsumerState<RssFavoritesScreen> createState() => _RssFavoritesScreenState();
}

class _RssFavoritesScreenState extends ConsumerState<RssFavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rssProvider.notifier).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rssProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('RSS 收藏')),
      body: _buildBody(state, theme),
    );
  }

  Widget _buildBody(RssState state, ThemeData theme) {
    if (state.isLoadingFavorites) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_outline,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              '暂无收藏',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.favorites.length,
      itemBuilder: (context, index) {
        final star = state.favorites[index];
        return _buildFavCard(star, theme);
      },
    );
  }

  Widget _buildFavCard(RssStar star, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(star.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          star.pubDate ?? '',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () async {
            // 转为 RssArticle 传给 toggleFavorite
            final article = RssArticle(
              origin: star.origin,
              sort: star.sort,
              title: star.title,
              link: star.link,
              pubDate: star.pubDate,
              description: star.description,
              content: star.content,
              image: star.image,
              group: star.group,
              type: star.type,
              durPos: star.durPos,
            );
            await ref.read(rssProvider.notifier).toggleFavorite(article);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RssReaderScreen(
                article: RssArticle(
                  origin: star.origin,
                  sort: star.sort,
                  title: star.title,
                  link: star.link,
                  pubDate: star.pubDate,
                  description: star.description,
                  content: star.content,
                  image: star.image,
                  group: star.group,
                  type: star.type,
                  durPos: star.durPos,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
