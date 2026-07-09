import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/source_provider.dart';

/// 书源分组管理对话框
///
/// 支持：
/// - 查看现有分组及每个分组的书源数量
/// - 添加新分组
/// - 重命名分组
/// - 删除分组
class SourceGroupDialog extends ConsumerStatefulWidget {
  const SourceGroupDialog({super.key});

  @override
  ConsumerState<SourceGroupDialog> createState() => _SourceGroupDialogState();
}

class _SourceGroupDialogState extends ConsumerState<SourceGroupDialog> {
  final _newGroupController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _newGroupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(sourceProvider);

    // 统计每个分组的书源数量
    final groupCounts = <String, int>{};
    for (final source in state.sources) {
      final group = source.bookSourceGroup ?? '未分组';
      groupCounts[group] = (groupCounts[group] ?? 0) + 1;
    }

    final groups = groupCounts.keys.toList()..sort();

    return AlertDialog(
      title: const Text('分组管理'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 添加新分组
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newGroupController,
                    decoration: InputDecoration(
                      hintText: '输入新分组名称',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: _error,
                    ),
                    onChanged: (_) => setState(() => _error = null),
                    onSubmitted: (_) => _addGroup(groups),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () => _addGroup(groups),
                  tooltip: '添加分组',
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 分组列表
            Expanded(
              child: groups.isEmpty
                  ? Center(
                      child: Text(
                        '暂无分组',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: groups.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: theme.colorScheme.outlineVariant),
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        final count = groupCounts[group] ?? 0;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Text(
                              group.isNotEmpty ? group[0].toUpperCase() : '?',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            group,
                            style: theme.textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            '$count 个书源',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 重命名
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                tooltip: '重命名',
                                onPressed: () =>
                                    _showRenameDialog(context, group),
                              ),
                              // 删除
                              if (group != '未分组')
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20),
                                  tooltip: '删除',
                                  color: theme.colorScheme.error,
                                  onPressed: () =>
                                      _confirmDeleteGroup(context, group),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('关闭'),
        ),
      ],
    );
  }

  /// 添加新分组
  void _addGroup(List<String> existingGroups) {
    final name = _newGroupController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = '分组名称不能为空');
      return;
    }
    if (existingGroups.contains(name)) {
      setState(() => _error = '分组 "$name" 已存在');
      return;
    }

    // 分组只是一个逻辑标签，保存在每个书源的 bookSourceGroup 字段中
    // 这里清空输入框，让用户知道添加成功
    _newGroupController.clear();
    setState(() => _error = null);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已创建分组 "$name"，可在编辑书源时使用')),
    );
  }

  /// 显示重命名对话框
  void _showRenameDialog(BuildContext context, String oldName) {
    final controller = TextEditingController(text: oldName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重命名分组'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '新名称',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty || newName == oldName) {
                Navigator.pop(context);
                return;
              }

              try {
                final provider = ref.read(sourceProvider.notifier);
                // 使用 state.sources 避免过滤影响
                final allSources = ref.read(sourceProvider);
                for (final source in allSources.sources) {
                  if (source.bookSourceGroup == oldName) {
                    final updatedSource =
                        source.copyWith(bookSourceGroup: newName);
                    await provider.saveSource(updatedSource);
                  }
                }
                await provider.loadSources();

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('已重命名 "$oldName" 为 "$newName"')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('重命名失败: $e')),
                  );
                }
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  /// 确认删除分组
  void _confirmDeleteGroup(BuildContext context, String group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除分组'),
        content: Text('确定要删除分组 "$group" 吗？\n该分组下的书源分组信息将被清除。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final provider = ref.read(sourceProvider.notifier);
                // 使用 state.sources 避免过滤影响
                final allSources = ref.read(sourceProvider);
                for (final source in allSources.sources) {
                  if (source.bookSourceGroup == group) {
                    final updatedSource = source.copyWith(bookSourceGroup: null);
                    await provider.saveSource(updatedSource);
                  }
                }
                await provider.loadSources();

                if (context.mounted) {
                  Navigator.pop(context); // 关闭确认对话框
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('已删除分组 "$group"')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('删除失败: $e')),
                  );
                }
              }
            },
            child: Text(
              '删除',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// 便捷方法：显示分组管理对话框
Future<void> showSourceGroupDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const SourceGroupDialog(),
  );
}
