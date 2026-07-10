import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/rss_source.dart';
import '../providers/rss_provider.dart';

/// RSS 源编辑页面
///
/// 对标原：RssSourceEditActivity.kt
class RssSourceEditScreen extends ConsumerStatefulWidget {
  final String? url;
  final RssSource? existingSource;

  const RssSourceEditScreen({super.key, this.url, this.existingSource});

  @override
  ConsumerState<RssSourceEditScreen> createState() =>
      _RssSourceEditScreenState();
}

class _RssSourceEditScreenState extends ConsumerState<RssSourceEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _urlController;
  late final TextEditingController _nameController;
  late final TextEditingController _groupController;
  late final TextEditingController _commentController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.existingSource != null;
    _urlController = TextEditingController(
      text: widget.existingSource?.sourceUrl ?? widget.url ?? '',
    );
    _nameController = TextEditingController(
      text: widget.existingSource?.sourceName ?? '',
    );
    _groupController = TextEditingController(
      text: widget.existingSource?.sourceGroup ?? '',
    );
    _commentController = TextEditingController(
      text: widget.existingSource?.sourceComment ?? '',
    );

    // 如果是新源但 URL 已输入，尝试自动获取名称
    if (!_isEditing && _urlController.text.isNotEmpty) {
      _autoFillName(_urlController.text);
    }
  }

  Future<void> _autoFillName(String url) async {
    // 简单地从 URL 推断名称
    try {
      final uri = Uri.parse(url);
      final host = uri.host;
      if (host.isNotEmpty) {
        _nameController.text = host.replaceAll('www.', '');
        setState(() {});
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    _groupController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑 RSS 源' : '添加 RSS 源'),
        actions: [TextButton(onPressed: _saveSource, child: const Text('保存'))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 订阅地址
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: '订阅地址',
                hintText: 'https://example.com/rss',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入订阅地址';
                }
                final trimmed = value.trim();
                if (!trimmed.startsWith('http://') &&
                    !trimmed.startsWith('https://')) {
                  return '请输入有效的网址';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 名称
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '名称',
                hintText: '订阅源名称',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入名称';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // 分组
            TextFormField(
              controller: _groupController,
              decoration: const InputDecoration(
                labelText: '分组（可选）',
                hintText: '如：新闻、博客、技术',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.folder_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // 备注
            TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: '备注（可选）',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.comment_outlined),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // 高级规则（折叠）
            if (_isEditing) _buildAdvancedSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSection() {
    // 简单的高级选项展示（完整版应有更多字段）
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('高级选项', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              '可在代码层面编辑 ruleArticles、ruleTitle 等解析规则',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSource() {
    if (!_formKey.currentState!.validate()) return;

    final source = RssSource(
      sourceUrl: _urlController.text.trim(),
      sourceName: _nameController.text.trim(),
      sourceIcon: widget.existingSource?.sourceIcon ?? '',
      sourceGroup: _groupController.text.trim().isNotEmpty
          ? _groupController.text.trim()
          : null,
      sourceComment: _commentController.text.trim().isNotEmpty
          ? _commentController.text.trim()
          : null,
      enabled: true,
    );

    ref.read(rssProvider.notifier).addSource(source);
    Navigator.pop(context);
  }
}
