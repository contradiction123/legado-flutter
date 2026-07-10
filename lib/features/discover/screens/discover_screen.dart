import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/models/book_source.dart';
import '../../../../domain/models/search_book.dart';
import '../models/explore_kind.dart';
import '../providers/discover_provider.dart';
import '../utils/explore_kind_parser.dart';

/// 发现/探索页面
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
          if (state.exploreResults == null && state.groups.isNotEmpty)
            _GroupTabs(
              tabs: state.allTabs,
              selectedTab: state.selectedGroup,
              onSelect: (tab) =>
                  ref.read(discoverProvider.notifier).selectGroup(tab),
            ),
          Expanded(child: _buildContent(context, state, ref)),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DiscoverState state,
    WidgetRef ref,
  ) {
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

    if (state.exploreResults != null) {
      return _buildExploreResults(context, state.exploreResults!);
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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

    if (state.currentSources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.explore_outlined,
              size: 64,
              color: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
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
                color: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(discoverProvider.notifier).load();
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        itemCount: state.currentSources.length,
        itemBuilder: (context, index) {
          final source = state.currentSources[index];
          return _SourceCard(
            source: source,
            kinds: state.kindsOf(source),
            ref: ref,
          );
        },
      ),
    );
  }

  Widget _buildExploreResults(BuildContext context, List<SearchBook> results) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('未找到探索结果', style: Theme.of(context).textTheme.titleMedium),
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

class _SourceCard extends StatefulWidget {
  final BookSource source;
  final List<ExploreKind> kinds;
  final WidgetRef ref;

  const _SourceCard({
    required this.source,
    required this.kinds,
    required this.ref,
  });

  @override
  State<_SourceCard> createState() => _SourceCardState();
}

class _SourceCardState extends State<_SourceCard> {
  final Map<String, String> _values = <String, String>{};
  final Map<String, TextEditingController> _controllers =
      <String, TextEditingController>{};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = calculateExploreKindRows(widget.kinds, 6);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: theme.colorScheme.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.explore, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.source.bookSourceName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (widget.source.bookSourceGroup?.isNotEmpty == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      widget.source.bookSourceGroup!,
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (rows.isEmpty)
              Text(
                '该书源尚未配置探索入口',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.7,
                  ),
                ),
              )
            else
              Column(
                children: rows
                    .map(
                      (row) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final item in row)
                              Expanded(
                                flex: item.$2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  child: _buildKindItem(context, item.$1),
                                ),
                              ),
                            if (row.fold<int>(0, (sum, item) => sum + item.$2) <
                                6)
                              Spacer(
                                flex: 6 -
                                    row.fold<int>(
                                      0,
                                      (sum, item) => sum + item.$2,
                                    ),
                              ),
                          ],
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildKindItem(BuildContext context, ExploreKind kind) {
    switch (kind.type) {
      case ExploreKindType.text:
        return _buildTextKind(context, kind);
      case ExploreKindType.toggle:
        return _buildToggleKind(context, kind);
      case ExploreKindType.select:
        return _buildSelectKind(context, kind);
      case ExploreKindType.button:
        return _buildActionKind(context, kind, canExplore: false);
      case ExploreKindType.url:
      default:
        return _buildActionKind(context, kind, canExplore: true);
    }
  }

  Widget _buildActionKind(
    BuildContext context,
    ExploreKind kind, {
    required bool canExplore,
  }) {
    final theme = Theme.of(context);
    final enabled = canExplore && (kind.url?.isNotEmpty == true);
    return SizedBox(
      height: 34,
      child: OutlinedButton(
        onPressed: enabled
            ? () {
                widget.ref.read(discoverProvider.notifier).exploreCategory(
                  widget.source,
                  kind.url!,
                  title: kind.title,
                );
              }
            : null,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          side: BorderSide(color: theme.colorScheme.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
        child: Text(
          kind.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium,
        ),
      ),
    );
  }

  Widget _buildToggleKind(BuildContext context, ExploreKind kind) {
    final theme = Theme.of(context);
    final chars = kind.chars;
    if (chars == null || chars.isEmpty) {
      return _buildActionKind(context, kind, canExplore: false);
    }
    final current =
        _values[kind.title] ?? kind.defaultValue ?? chars.first;
    final text = kind.style.layoutJustifySelf == 'right'
        ? '${kind.title}$current'
        : '$current${kind.title}';
    return InkWell(
      onTap: () {
        final currentIndex = chars.indexOf(current);
        final nextIndex = currentIndex < 0 ? 0 : (currentIndex + 1) % chars.length;
        setState(() {
          _values[kind.title] = chars[nextIndex];
        });
      },
      borderRadius: BorderRadius.circular(11),
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(11),
          color: theme.colorScheme.surface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium,
        ),
      ),
    );
  }

  Widget _buildSelectKind(BuildContext context, ExploreKind kind) {
    final theme = Theme.of(context);
    final chars = kind.chars;
    if (chars == null || chars.isEmpty) {
      return _buildActionKind(context, kind, canExplore: false);
    }
    final current =
        _values[kind.title] ?? kind.defaultValue ?? chars.first;
    return PopupMenuButton<String>(
      tooltip: kind.title,
      onSelected: (value) {
        setState(() {
          _values[kind.title] = value;
        });
      },
      itemBuilder: (context) => chars
          .map(
            (option) => PopupMenuItem<String>(
              value: option,
              child: Text(option),
            ),
          )
          .toList(growable: false),
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(11),
          color: theme.colorScheme.surface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${kind.title} $current',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.unfold_more,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextKind(BuildContext context, ExploreKind kind) {
    final theme = Theme.of(context);
    final controller = _controllers.putIfAbsent(kind.title, () {
      final initialValue = _values[kind.title] ?? kind.defaultValue ?? '';
      return TextEditingController(text: initialValue);
    });
    return SizedBox(
      height: 34,
      child: TextField(
        controller: controller,
        onChanged: (value) => _values[kind.title] = value,
        textAlignVertical: TextAlignVertical.center,
        style: theme.textTheme.labelMedium,
        decoration: InputDecoration(
          hintText: kind.viewName ?? kind.title,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
      ),
    );
  }
}

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
