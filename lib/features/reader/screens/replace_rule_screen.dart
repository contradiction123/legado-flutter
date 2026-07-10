import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/replace_rule.dart';
import '../providers/replace_rule_provider.dart';

/// 替换净化配置页面
class ReplaceRuleScreen extends ConsumerWidget {
  const ReplaceRuleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(replaceRuleProvider);
    final provider = ref.read(replaceRuleProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('替换净化'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '添加规则',
            onPressed: () => _showRuleEditor(context, null, provider),
          ),
        ],
      ),
      body: Column(
        children: [
          // 全局开关
          SwitchListTile(
            title: const Text('启用替换净化'),
            subtitle: Text(
              state.replaceEnabled
                  ? '已启用 (${state.enabledRules.length} 条规则)'
                  : '已禁用',
            ),
            value: state.replaceEnabled,
            onChanged: (_) => provider.toggleReplaceEnabled(),
          ),
          const Divider(height: 1),
          if (state.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (state.allRules.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.auto_fix_high,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '暂无替换规则',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '点击右上角 + 添加规则',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: state.allRules.length,
                itemBuilder: (context, index) {
                  final rule = state.allRules[index];
                  return _RuleTile(
                    rule: rule,
                    onToggle: () => provider.toggleRule(rule.id ?? 0),
                    onEdit: () => _showRuleEditor(context, rule, provider),
                    onDelete: () => provider.deleteRule(rule.id ?? 0),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  /// 显示规则编辑弹窗
  void _showRuleEditor(
    BuildContext context,
    ReplaceRule? existing,
    ReplaceRuleProvider provider,
  ) {
    final nameCtl = TextEditingController(text: existing?.name ?? '');
    final patternCtl = TextEditingController(text: existing?.pattern ?? '');
    final replacementCtl = TextEditingController(
      text: existing?.replacement ?? '',
    );
    var isRegex = existing?.isRegex ?? true;
    var scopeTitle = existing?.scopeTitle ?? false;
    var scopeContent = existing?.scopeContent ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existing != null ? '编辑规则' : '添加规则'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtl,
                  decoration: const InputDecoration(
                    labelText: '规则名称',
                    hintText: '例如：去除广告行',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: patternCtl,
                  decoration: InputDecoration(
                    labelText: isRegex ? '正则表达式' : '查找文本',
                    hintText: isRegex ? r'广告\d+' : '广告',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: replacementCtl,
                  decoration: const InputDecoration(
                    labelText: '替换为',
                    hintText: '留空则删除匹配内容',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('使用正则表达式'),
                  value: isRegex,
                  onChanged: (v) => setDialogState(() => isRegex = v),
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile(
                  title: const Text('匹配章节标题'),
                  value: scopeTitle,
                  onChanged: (v) => setDialogState(() => scopeTitle = v),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                final rule = ReplaceRule(
                  id: existing?.id,
                  name: nameCtl.text,
                  pattern: patternCtl.text,
                  replacement: replacementCtl.text,
                  isRegex: isRegex,
                  scopeTitle: scopeTitle,
                  scopeContent: scopeContent,
                  isEnabled: existing?.isEnabled ?? true,
                );
                if (existing != null) {
                  provider.updateRule(rule);
                } else {
                  provider.addRule(rule);
                }
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 单条替换规则组件
class _RuleTile extends StatelessWidget {
  final ReplaceRule rule;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RuleTile({
    required this.rule,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        rule.isEnabled ? Icons.auto_fix_high : Icons.auto_fix_high_outlined,
        color: rule.isEnabled
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        rule.name.isNotEmpty ? rule.name : '(未命名)',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${rule.pattern} → ${rule.replacement}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              rule.isEnabled ? Icons.visibility : Icons.visibility_off,
              size: 18,
            ),
            onPressed: onToggle,
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('编辑')),
              const PopupMenuItem(value: 'delete', child: Text('删除')),
            ],
            onSelected: (action) {
              if (action == 'edit') onEdit();
              if (action == 'delete') onDelete();
            },
          ),
        ],
      ),
      onTap: onEdit,
    );
  }
}
