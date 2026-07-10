import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/models/dict_rule.dart';
import 'providers/dict_provider.dart';

/// 词典规则管理页面
///
/// 对标原：DictRuleActivity.kt + DictRuleScreen.kt
/// 管理所有词典规则（添加/编辑/删除/排序）
class DictRuleScreen extends ConsumerStatefulWidget {
  const DictRuleScreen({super.key});

  @override
  ConsumerState<DictRuleScreen> createState() => _DictRuleScreenState();
}

class _DictRuleScreenState extends ConsumerState<DictRuleScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  List<DictRule> _filteredRules = [];
  Set<String> _selectedIds = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dictProvider.notifier).loadRules();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadRules() {
    final rules = ref.read(dictProvider).rules;
    if (_searchController.text.isEmpty) {
      _filteredRules = rules;
    } else {
      _filteredRules = rules
          .where(
            (r) =>
                r.name.contains(_searchController.text) ||
                r.urlRule.contains(_searchController.text),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dictProvider);
    final theme = Theme.of(context);
    _loadRules();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: '搜索词典规则',
                  border: InputBorder.none,
                ),
                onChanged: (_) => setState(() {}),
              )
            : Text(_isSelectionMode ? '已选中 ${_selectedIds.length} 项' : '词典规则'),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.select_all),
              tooltip: '全选',
              onPressed: () {
                setState(() {
                  if (_selectedIds.length == _filteredRules.length) {
                    _selectedIds.clear();
                  } else {
                    _selectedIds = _filteredRules.map((r) => r.name).toSet();
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: '删除选中',
              onPressed: _selectedIds.isEmpty ? null : () => _deleteSelected(),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: '取消选择',
              onPressed: () {
                setState(() {
                  _selectedIds.clear();
                  _isSelectionMode = false;
                });
              },
            ),
          ] else ...[
            IconButton(
              icon: Icon(_isSearching ? Icons.search_off : Icons.search),
              tooltip: '搜索',
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                  }
                });
              },
            ),
          ],
        ],
      ),
      floatingActionButton: _isSelectionMode
          ? null
          : FloatingActionButton(
              onPressed: () => _showEditDialog(),
              child: const Icon(Icons.add),
            ),
      body: _buildBody(state, theme),
    );
  }

  Widget _buildBody(DictState state, ThemeData theme) {
    if (state.isLoading && _filteredRules.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredRules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              state.rules.isEmpty ? '暂无词典规则' : '未找到匹配的规则',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            if (state.rules.isEmpty)
              Text(
                '点击右下角 + 添加词典规则',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(dictProvider.notifier).loadRules(),
      child: ReorderableListView.builder(
        itemCount: _filteredRules.length,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final item = _filteredRules.removeAt(oldIndex);
            _filteredRules.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final rule = _filteredRules[index];
          final isSelected = _selectedIds.contains(rule.name);

          return Card(
            key: ValueKey(rule.name),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: _isSelectionMode
                  ? Checkbox(
                      value: isSelected,
                      onChanged: (v) {
                        setState(() {
                          if (v == true) {
                            _selectedIds.add(rule.name);
                          } else {
                            _selectedIds.remove(rule.name);
                          }
                        });
                      },
                    )
                  : ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_handle),
                    ),
              title: Text(rule.name),
              subtitle: Text(
                rule.urlRule,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 启用开关
                  Switch(
                    value: rule.enabled,
                    onChanged: (v) {
                      ref.read(dictProvider.notifier).enableRule(rule.name, v);
                    },
                  ),
                  if (!_isSelectionMode)
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditDialog(existingRule: rule),
                    ),
                ],
              ),
              onLongPress: () {
                if (!_isSelectionMode) {
                  setState(() {
                    _isSelectionMode = true;
                    _selectedIds = {rule.name};
                  });
                }
              },
              onTap: () {
                if (_isSelectionMode) {
                  setState(() {
                    if (isSelected) {
                      _selectedIds.remove(rule.name);
                      if (_selectedIds.isEmpty) {
                        _isSelectionMode = false;
                      }
                    } else {
                      _selectedIds.add(rule.name);
                    }
                  });
                }
              },
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog({DictRule? existingRule}) {
    final nameCtrl = TextEditingController(text: existingRule?.name ?? '');
    final urlRuleCtrl = TextEditingController(
      text: existingRule?.urlRule ?? '',
    );
    final showRuleCtrl = TextEditingController(
      text: existingRule?.showRule ?? '',
    );
    final isNew = existingRule == null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isNew ? '添加词典规则' : '编辑词典规则'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: '名称',
                  hintText: '如：百度百科',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: urlRuleCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL 规则',
                  hintText: 'https://example.com/search?q=\$key',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: showRuleCtrl,
                decoration: const InputDecoration(
                  labelText: '展示规则（可选）',
                  hintText: '使用规则提取显示内容',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;

              final newRule = DictRule(
                name: nameCtrl.text.trim(),
                urlRule: urlRuleCtrl.text.trim(),
                showRule: showRuleCtrl.text.trim(),
                enabled: true,
                sortNumber: existingRule?.sortNumber ?? 0,
              );

              // 保存
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isNew ? '已添加规则' : '已更新规则')),
              );
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除确认'),
        content: Text('确定删除选中的 ${_selectedIds.length} 个词典规则吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _selectedIds.clear();
                _isSelectionMode = false;
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('已删除选中规则')));
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
