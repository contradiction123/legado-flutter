import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/rss_source.dart';
import 'rss_article_list_screen.dart';
import 'rss_source_edit_screen.dart';
import 'rss_favorites_screen.dart';
import 'rss_debug_screen.dart';
import '../providers/rss_provider.dart';

/// RSS 源列表页面
///
/// 对标原：RssSourceActivity.kt
class RssSourceListScreen extends ConsumerStatefulWidget {
  const RssSourceListScreen({super.key});

  @override
  ConsumerState<RssSourceListScreen> createState() =>
      _RssSourceListScreenState();
}

class _RssSourceListScreenState extends ConsumerState<RssSourceListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rssProvider.notifier).loadSources();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rssProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RSS 订阅'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline),
            tooltip: '收藏',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RssFavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            tooltip: '调试',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RssDebugScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSourceDialog(context),
        child: const Icon(Icons.add),
      ),
      body: _buildBody(state, theme),
    );
  }

  Widget _buildBody(RssState state, ThemeData theme) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.sources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rss_feed,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              '还没有 RSS 订阅源',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '点击右下角 + 添加',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ],
        ),
      );
    }

    // 按分组归类
    final grouped = <String, List<RssSource>>{};
    for (final source in state.sources) {
      final group = source.sourceGroup ?? '默认分组';
      grouped.putIfAbsent(group, () => []);
      grouped[group]!.add(source);
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(rssProvider.notifier).loadSources();
      },
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: grouped.entries.map((entry) {
          return _buildGroupSection(entry.key, entry.value, state, theme);
        }).toList(),
      ),
    );
  }

  Widget _buildGroupSection(
    String group,
    List<RssSource> sources,
    RssState state,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            group,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        ...sources.map((source) => _buildSourceCard(source, state, theme)),
      ],
    );
  }

  Widget _buildSourceCard(RssSource source, RssState state, ThemeData theme) {
    final unread = state.unreadCounts[source.sourceUrl] ?? 0;
    final isRefreshing = state.refreshingUrls.contains(source.sourceUrl);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondaryContainer,
          child: Icon(
            Icons.rss_feed,
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(source.sourceName, maxLines: 1),
        subtitle: Text(
          source.sourceUrl,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (unread > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unread',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(width: 4),
            if (isRefreshing)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: () {
                  ref
                      .read(rssProvider.notifier)
                      .refreshSource(source.sourceUrl);
                },
              ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RssArticleListScreen(sourceUrl: source.sourceUrl),
            ),
          );
        },
        onLongPress: () {
          _showSourceOptions(context, source);
        },
      ),
    );
  }

  void _showSourceOptions(BuildContext context, RssSource source) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('编辑'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RssSourceEditScreen(existingSource: source),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('删除', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(source);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(RssSource source) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除订阅源'),
        content: Text('确定要删除「${source.sourceName}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(rssProvider.notifier).deleteSource(source.sourceUrl);
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddSourceDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('添加 RSS 源'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '输入 RSS 订阅地址',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final url = controller.text.trim();
              if (url.isNotEmpty) {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RssSourceEditScreen(url: url),
                  ),
                );
              }
            },
            child: const Text('下一步'),
          ),
        ],
      ),
    );
  }
}
