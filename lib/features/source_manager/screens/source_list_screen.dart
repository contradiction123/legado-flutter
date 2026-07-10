import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/book_source.dart';
import '../providers/source_provider.dart';
import '../widgets/import_export_dialog.dart';
import '../widgets/source_card.dart';

class SourceListScreen extends ConsumerWidget {
  const SourceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sourceProvider);
    final provider = ref.read(sourceProvider.notifier);
    final filteredSources = provider.filteredSources;

    return Scaffold(
      appBar: AppBar(
        title: const Text('书源管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: '扫码添加书源',
            onPressed: () => _scanQrCode(context, provider),
          ),
          IconButton(
            icon: const Icon(Icons.import_export),
            tooltip: '导入/导出',
            onPressed: () => showImportExportDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.group_work),
            tooltip: '分组管理',
            onPressed: () => _showGroupDialog(context, provider),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '搜索书源...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: provider.search,
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildGroupChip(
                  '全部',
                  state.selectedGroup == null,
                  () => provider.filterByGroup(null),
                ),
                ...state.groups.map(
                  (group) => _buildGroupChip(
                    group,
                    state.selectedGroup == group,
                    () => provider.filterByGroup(group),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                ? Center(child: Text('加载失败: ${state.error}'))
                : RefreshIndicator(
                    onRefresh: provider.loadSources,
                    child: ListView.builder(
                      itemCount: filteredSources.length,
                      itemBuilder: (context, index) {
                        final source = filteredSources[index];
                        return SourceCard(
                          source: source,
                          onTap: () => _editSource(context, source),
                          onToggleEnabled: (_) =>
                              provider.toggleEnabled(source.bookSourceUrl),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSource(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGroupChip(
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }

  void _scanQrCode(BuildContext context, SourceProvider provider) async {
    final result = await context.push<String>('/qr-scan');
    if (result == null || result.isEmpty || !context.mounted) return;

    _showImportingIndicator(context);
    try {
      final count = await provider.importFromText(result);
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('成功导入 $count 个书源')),
      );
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('导入失败: $e')),
      );
    }
  }

  void _showGroupDialog(BuildContext context, SourceProvider provider) {
    final groups = provider.filteredSources
        .map((source) => source.bookSourceGroup)
        .whereType<String>()
        .toSet()
        .toList();

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('分组管理'),
        content: SizedBox(
          width: double.maxFinite,
          child: groups.isEmpty
              ? const Text('暂无分组')
              : ListView(
                  children:
                      groups.map((group) => ListTile(title: Text(group))).toList(),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _editSource(BuildContext context, BookSource source) {
    context.push('/source-edit', extra: source);
  }

  void _addSource(BuildContext context) {
    context.push('/source-edit');
  }

  void _showImportingIndicator(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Expanded(child: Text('正在导入书源...')),
            ],
          ),
        ),
      ),
    );
  }
}
