import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/models/book_source.dart';
import '../../../../domain/models/search_book.dart';
import '../providers/discover_provider.dart';

/// 发现/探索页面
///
/// 按书源分组展示支持探索的书源，展示各书源的探索分类入口。
/// 点击分类入口后执行探索请求并展示结果列表。
class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoverProvider);

    return Scaffold(
      appBar: state.exploreResults != null
          ? AppBar(
              title: Text(state.exploreCategory ?? '探索结果'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () =>
                    ref.read(discoverProvider.notifier).clearExploreResults(),
              ),
            )
          : null,
      body: Column(
        children: [
          // 有探索结果时不显示分组标签
          if (state.exploreResults == null && state.groups.isNotEmpty)
            _GroupTabs(
              tabs: state.allTabs,
              selectedTab: state.selectedGroup,
              onSelect: (tab) =>
                  ref.read(discoverProvider.notifier).selectGroup(tab),
            ),
          // 内容
          Expanded(
            child: _buildContent(context, state, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, DiscoverState state, WidgetRef ref) {
    // 探索中
    if (state.isExploring) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在探索...'),
          ],
        ),
      );
    }

    // 有探索结果 → 展示结果列表
    if (state.exploreResults != null) {
      return _buildExploreResults(context, state.exploreResults!);
    }

    // 加载中
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 错误
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('加载失败: ${state.error}'),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () => ref.read(discoverProvider.notifier).load(),
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    // 空书源
    if (state.currentSources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_outlined,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              '暂无探索书源',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '请先添加支持探索的书源',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
      );
    }

    // 书源列表
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(discoverProvider.notifier).load();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.currentSources.length,
        itemBuilder: (context, index) {
          final source = state.currentSources[index];
          return _SourceCard(
            source: source,
            ref: ref,
          );
        },
      ),
    );
  }

  /// 构建探索结果列表
  Widget _buildExploreResults(BuildContext context, List<SearchBook> results) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('未找到探索结果',
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return _ExploreBookCard(book: book);
      },
    );
  }
}

/// 分组标签栏
class _GroupTabs extends StatelessWidget {
  final List<String> tabs;
  final String selectedTab;
  final ValueChanged<String> onSelect;

  const _GroupTabs({
    required this.tabs,
    required this.selectedTab,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: tabs.map((tab) {
            final isSelected = tab == selectedTab;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(tab),
                selected: isSelected,
                onSelected: (_) => onSelect(tab),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// 单个书源的探索入口卡片
class _SourceCard extends StatelessWidget {
  final BookSource source;
  final WidgetRef ref;

  const _SourceCard({required this.source, required this.ref});

  /// 解析 exploreUrl 为分类列表（每行一个分类 URL）
  List<MapEntry<String, String>> _parseExploreCategories() {
    if (source.exploreUrl == null || source.exploreUrl!.isEmpty) {
      return [];
    }

    final lines = source.exploreUrl!.split('\n');
    return lines
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .map((line) {
          return MapEntry(_extractName(line), line);
        }).toList();
  }

  String _extractName(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return Uri.decodeComponent(uri.pathSegments.last);
    }
    final eqIdx = url.lastIndexOf('=');
    if (eqIdx >= 0 && eqIdx < url.length - 1) {
      return Uri.decodeComponent(url.substring(eqIdx + 1));
    }
    final slashIdx = url.lastIndexOf('/');
    if (slashIdx >= 0 && slashIdx < url.length - 1) {
      return Uri.decodeComponent(url.substring(slashIdx + 1));
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = _parseExploreCategories();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 书源名称
            Row(
              children: [
                Icon(Icons.explore, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    source.bookSourceName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (source.bookSourceGroup != null)
                  Chip(
                    label: Text(
                      source.bookSourceGroup!,
                      style: const TextStyle(fontSize: 10),
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // 分类入口
            if (categories.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: categories.map((entry) {
                  return ActionChip(
                    label: Text(entry.key, style: const TextStyle(fontSize: 12)),
                    onPressed: () {
                      ref
                          .read(discoverProvider.notifier)
                          .exploreCategory(source, entry.value);
                    },
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              )
            else
              Text(
                '该书源尚未配置探索分类',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 探索结果中的书籍卡片（网格模式）
class _ExploreBookCard extends StatelessWidget {
  final SearchBook book;

  const _ExploreBookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        context.push('/book-detail', extra: book);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面区域
            Expanded(
              child: Container(
                width: double.infinity,
                color: theme.colorScheme.surfaceContainerHighest,
                child: book.coverUrl != null && book.coverUrl!.isNotEmpty
                    ? Image.network(
                        book.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(theme),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _buildPlaceholder(theme);
                        },
                      )
                    : _buildPlaceholder(theme),
              ),
            ),
            // 书名
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 2),
              child: Text(
                book.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // 作者
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
              child: Text(
                book.author.isNotEmpty ? book.author : '未知作者',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Center(
      child: Icon(
        Icons.book,
        size: 40,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
      ),
    );
  }
}
