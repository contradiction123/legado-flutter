import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/book_source.dart';
import '../providers/source_provider.dart';
import '../widgets/source_card.dart';

/// 书源列表页面
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
            icon: const Icon(Icons.import_export),
            tooltip: '导入/导出',
            onPressed: () => _showImportExportDialog(context, provider),
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
          // 搜索栏
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '搜索书源...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => provider.search(value),
            ),
          ),
          // 分组标签
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildGroupChip(context, '全部', null,
                    state.selectedGroup == null, () => provider.filterByGroup(null)),
                ...state.groups.map((group) => _buildGroupChip(
                      context,
                      group,
                      group,
                      state.selectedGroup == group,
                      () => provider.filterByGroup(group),
                    )),
              ],
            ),
          ),
          // 书源列表
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                    ? Center(child: Text('加载失败: ${state.error}'))
                    : RefreshIndicator(
                        onRefresh: () => provider.loadSources(),
                        child: ListView.builder(
                          itemCount: filteredSources.length,
                          itemBuilder: (context, index) {
                            final source = filteredSources[index];
                            return SourceCard(
                              source: source,
                              onTap: () => _editSource(context, source),
                              onToggleEnabled: (enabled) =>
                                  provider.toggleEnabled(source.bookSourceUrl),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSource(context, provider),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGroupChip(
    BuildContext context,
    String label,
    String? value,
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

  void _showImportExportDialog(BuildContext context, SourceProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('导入/导出'),
        content: const Text('选择操作:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _importFromClipboard(context, provider);
            },
            child: const Text('从剪贴板导入'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exportToClipboard(context, provider);
            },
            child: const Text('导出到剪贴板'),
          ),
        ],
      ),
    );
  }

  void _importFromClipboard(BuildContext context, SourceProvider provider) async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final data = clipboardData?.text;
    if (data == null || data.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('剪贴板为空')),
        );
      }
      return;
    }

    final count = await provider.importFromJson(data);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('成功导入 $count 个书源')),
      );
    }
  }

  void _exportToClipboard(BuildContext context, SourceProvider provider) async {
    final jsonList = provider.filteredSources
        .map((s) => s.toJson())
        .toList();
    final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);
    await Clipboard.setData(ClipboardData(text: jsonStr));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已导出 ${provider.filteredSources.length} 个书源到剪贴板')),
      );
    }
  }

  void _showGroupDialog(BuildContext context, SourceProvider provider) {
    final groups = provider.filteredSources
        .map((s) => s.bookSourceGroup)
        .whereType<String>()
        .toSet()
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('分组管理'),
        content: SizedBox(
          width: double.maxFinite,
          child: groups.isEmpty
              ? const Text('暂无分组')
              : ListView(
                  children: groups
                      .map((group) => ListTile(
                            title: Text(group),
                          ))
                      .toList(),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('书源 JSON'),
        content: SingleChildScrollView(
          child: Text(
            const JsonEncoder.withIndent('  ').convert(source.toJson()),
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
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

  void _addSource(BuildContext context, SourceProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加书源'),
        content: const Text('从菜单选择「从剪贴板导入」来添加书源'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
