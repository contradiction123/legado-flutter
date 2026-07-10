import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/search_book.dart';
import '../../../domain/models/book_ext.dart';
import '../providers/book_detail_provider.dart';

/// 书籍详情页
class BookDetailScreen extends ConsumerWidget {
  final SearchBook searchBook;

  const BookDetailScreen({super.key, required this.searchBook});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookDetailProvider(searchBook));
    final provider = ref.read(bookDetailProvider(searchBook).notifier);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(context, state),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(context, state),
                  const SizedBox(height: 16),
                  _buildActionButtons(context, state, provider),
                  const SizedBox(height: 16),
                  _buildIntroSection(context, state),
                  const SizedBox(height: 16),
                  _buildChapterSection(context, state, provider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BookDetailState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final coverUrl =
        state.book?.customCoverUrl ??
        state.book?.coverUrl ??
        state.searchBook.coverUrl;

    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 120,
                  height: 170,
                  child: coverUrl != null && coverUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: coverUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              _placeholder(colorScheme),
                          errorWidget: (context, url, error) =>
                              _placeholder(colorScheme),
                        )
                      : _placeholder(colorScheme),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                state.searchBook.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                state.searchBook.author,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.book_outlined,
          size: 48,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, BookDetailState state) {
    final book = state.book;
    if (book == null) return const SizedBox.shrink();

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (book.kind != null && book.kind!.isNotEmpty)
          _InfoChip(label: '分类', value: book.kind!),
        if (book.wordCount != null && book.wordCount!.isNotEmpty)
          _InfoChip(label: '字数', value: book.wordCount!),
        if (book.latestChapterTitle != null)
          _InfoChip(label: '最新', value: book.latestChapterTitle!),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    BookDetailState state,
    BookDetailProvider provider,
  ) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () {
              final book = state.book ?? provider.searchBookToBook();
              context.push(book.readerRoute, extra: book);
            },
            icon: const Icon(Icons.menu_book),
            label: const Text('开始阅读'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: state.isInBookshelf
              ? FilledButton.tonalIcon(
                  onPressed: provider.removeFromBookshelf,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('移出书架'),
                )
              : FilledButton.tonalIcon(
                  onPressed: provider.addToBookshelf,
                  icon: const Icon(Icons.add),
                  label: const Text('加入书架'),
                ),
        ),
      ],
    );
  }

  Widget _buildIntroSection(BuildContext context, BookDetailState state) {
    final intro =
        state.book?.customIntro ?? state.book?.intro ?? state.searchBook.intro;
    if (intro == null || intro.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '简介',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          intro,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildChapterSection(
    BuildContext context,
    BookDetailState state,
    BookDetailProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '章节列表',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (state.isLoadingChapters)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (state.chapters.isEmpty && !state.isLoadingChapters)
          Text(
            '暂无章节信息',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.chapters.length.clamp(0, 10),
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chapter = state.chapters[index];
              return ListTile(
                dense: true,
                title: Text(
                  chapter.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  final book = (state.book ?? provider.searchBookToBook())
                      .copyWith(durChapterIndex: index);
                  context.push(book.readerRoute, extra: book);
                },
              );
            },
          ),
        if (state.chapters.length > 10)
          Center(
            child: TextButton(
              onPressed: () => _showAllChapters(context, state, provider),
              child: Text('查看全部 ${state.chapters.length} 章'),
            ),
          ),
      ],
    );
  }
}

/// 章节列表底部弹窗
void _showAllChapters(
  BuildContext context,
  BookDetailState state,
  BookDetailProvider provider,
) {
  showModalBottomSheet(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '章节列表 (${state.chapters.length} 章)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.chapters.length,
              itemBuilder: (context, index) {
                final chapter = state.chapters[index];
                return ListTile(
                  dense: true,
                  title: Text(
                    chapter.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    final book = (state.book ?? provider.searchBookToBook())
                        .copyWith(durChapterIndex: index);
                    context.push(book.readerRoute, extra: book);
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: colorScheme.onSecondaryContainer,
        fontSize: 12,
      ),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
