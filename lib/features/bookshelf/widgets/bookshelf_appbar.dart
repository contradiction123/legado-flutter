import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 书架 AppBar
class BookshelfAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isEditMode;
  final int selectedCount;
  final bool isGridView;
  final bool isAllSelected;
  final VoidCallback? onToggleViewMode;
  final VoidCallback? onSelectAll;
  final VoidCallback? onDone;

  const BookshelfAppBar({
    super.key,
    this.isEditMode = false,
    this.selectedCount = 0,
    this.isGridView = true,
    this.isAllSelected = false,
    this.onToggleViewMode,
    this.onSelectAll,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    if (isEditMode) {
      return AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: onDone),
        title: Text('已选择 $selectedCount 本'),
        actions: [
          TextButton(
            onPressed: onSelectAll,
            child: Text(isAllSelected ? '取消全选' : '全选'),
          ),
        ],
      );
    }

    return AppBar(
      title: const Text('书架'),
      actions: [
        IconButton(
          icon: const Icon(Icons.file_open_outlined),
          tooltip: '导入本地书籍',
          onPressed: () {
            context.push('/import-books');
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: '搜索',
          onPressed: () {
            context.push('/search');
          },
        ),
        IconButton(
          icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
          tooltip: isGridView ? '列表视图' : '网格视图',
          onPressed: onToggleViewMode,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
