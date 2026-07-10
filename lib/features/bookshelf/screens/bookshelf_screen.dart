import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/book_ext.dart';
import '../providers/bookshelf_provider.dart';
import '../widgets/book_card.dart';
import '../widgets/book_list_item.dart';
import '../widgets/bookshelf_appbar.dart';
import '../widgets/group_sidebar.dart';

/// 书架主页面
class BookshelfScreen extends ConsumerWidget {
  const BookshelfScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookshelfProvider);
    final provider = ref.read(bookshelfProvider.notifier);

    final filteredBooks = state.filteredBooks;

    return Scaffold(
      appBar: BookshelfAppBar(
        isEditMode: state.isEditMode,
        selectedCount: state.selectedBooks.length,
        isGridView: state.isGridView,
        isAllSelected: state.isAllSelected,
        onToggleViewMode: provider.toggleViewMode,
        onSelectAll: () {
          if (state.isAllSelected) {
            provider.deselectAll();
          } else {
            provider.selectAll();
          }
        },
        onDone: provider.exitEditMode,
      ),
      body: Column(
        children: [
          // 分组筛选栏
          GroupFilterBar(
            groups: state.groups,
            selectedGroupId: state.selectedGroupId,
            onGroupSelected: provider.selectGroup,
          ),
          // 书籍列表
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: provider.refresh,
                    child: filteredBooks.isEmpty
                        ? _buildEmptyState(context)
                        : state.isGridView
                        ? _buildGridView(context, state, provider)
                        : _buildListView(context, state, provider),
                  ),
          ),
        ],
      ),
      // 编辑模式底部操作栏
      bottomNavigationBar: state.isEditMode
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: state.selectedBooks.isEmpty
                            ? null
                            : () => _showMoveGroupBottomSheet(
                                context,
                                state,
                                provider,
                              ),
                        icon: const Icon(Icons.drive_file_move_outline),
                        label: const Text('移动分组'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: state.selectedBooks.isEmpty
                            ? null
                            : () => _confirmDelete(context, provider),
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('删除'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '书架空空如也',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '去搜索页面添加书籍吧',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(
    BuildContext context,
    BookshelfState state,
    BookshelfProvider provider,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: state.filteredBooks.length,
      itemBuilder: (context, index) {
        final book = state.filteredBooks[index];
        return BookCard(
          book: book,
          isEditMode: state.isEditMode,
          isSelected: state.selectedBooks.contains(book.bookUrl),
          onTap: () {
            if (state.isEditMode) {
              provider.toggleBookSelection(book.bookUrl);
            } else {
              context.push(book.readerRoute, extra: book);
            }
          },
          onLongPress: () {
            if (!state.isEditMode) {
              provider.enterEditMode();
              provider.toggleBookSelection(book.bookUrl);
            }
          },
        );
      },
    );
  }

  Widget _buildListView(
    BuildContext context,
    BookshelfState state,
    BookshelfProvider provider,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.filteredBooks.length,
      itemBuilder: (context, index) {
        final book = state.filteredBooks[index];
        return BookListItem(
          book: book,
          isEditMode: state.isEditMode,
          isSelected: state.selectedBooks.contains(book.bookUrl),
          onTap: () {
            if (state.isEditMode) {
              provider.toggleBookSelection(book.bookUrl);
            } else {
              context.push('/reader', extra: book);
            }
          },
          onLongPress: () {
            if (!state.isEditMode) {
              provider.enterEditMode();
              provider.toggleBookSelection(book.bookUrl);
            }
          },
        );
      },
    );
  }

  void _showMoveGroupBottomSheet(
    BuildContext context,
    BookshelfState state,
    BookshelfProvider provider,
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
                '移动到分组',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
            ...state.groups.map(
              (group) => ListTile(
                title: Text(group.groupName),
                onTap: () {
                  Navigator.pop(context);
                  provider.moveSelectedToGroup(group.groupId);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, BookshelfProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('删除后无法恢复，是否继续？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              provider.deleteSelected();
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
