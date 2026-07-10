import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/book_source.dart';
import '../providers/source_provider.dart';

/// 书源编辑页面
///
/// 支持两种编辑模式：
/// - 表单模式：逐字段编辑常用属性
/// - JSON 模式：直接编辑原始 JSON
class SourceEditScreen extends ConsumerStatefulWidget {
  final BookSource? source;

  const SourceEditScreen({super.key, this.source});

  @override
  ConsumerState<SourceEditScreen> createState() => _SourceEditScreenState();
}

class _SourceEditScreenState extends ConsumerState<SourceEditScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _urlController;
  late final TextEditingController _groupController;
  late final TextEditingController _searchUrlController;
  late final TextEditingController _ruleSearchController;
  late final TextEditingController _ruleBookInfoController;
  late final TextEditingController _ruleTocController;
  late final TextEditingController _ruleContentController;
  late final TextEditingController _exploreUrlController;
  late final TextEditingController _jsonController;

  bool _isJsonMode = false;
  bool _isSaving = false;
  String? _jsonError;

  bool get _isNew => widget.source == null;

  @override
  void initState() {
    super.initState();
    final s = widget.source;
    _nameController = TextEditingController(text: s?.bookSourceName ?? '');
    _urlController = TextEditingController(text: s?.bookSourceUrl ?? '');
    _groupController = TextEditingController(text: s?.bookSourceGroup ?? '');
    _searchUrlController = TextEditingController(text: s?.searchUrl ?? '');
    _ruleSearchController = TextEditingController(text: s?.ruleSearch ?? '');
    _ruleBookInfoController = TextEditingController(
      text: s?.ruleBookInfo ?? '',
    );
    _ruleTocController = TextEditingController(text: s?.ruleToc ?? '');
    _ruleContentController = TextEditingController(text: s?.ruleContent ?? '');
    _exploreUrlController = TextEditingController(text: s?.exploreUrl ?? '');
    _jsonController = TextEditingController(
      text: s != null
          ? const JsonEncoder.withIndent('  ').convert(s.toJson())
          : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _groupController.dispose();
    _searchUrlController.dispose();
    _ruleSearchController.dispose();
    _ruleBookInfoController.dispose();
    _ruleTocController.dispose();
    _ruleContentController.dispose();
    _exploreUrlController.dispose();
    _jsonController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _isSaving = true;
      _jsonError = null;
    });

    try {
      final provider = ref.read(sourceProvider.notifier);

      if (_isJsonMode) {
        // JSON 模式：直接解析并保存
        final jsonStr = _jsonController.text.trim();
        if (jsonStr.isEmpty) {
          setState(() => _jsonError = 'JSON 内容不能为空');
          return;
        }
        final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
        final source = BookSource.fromJson(decoded);
        await provider.saveSource(source);
      } else {
        // 表单模式：构造 BookSource
        final sourceUrl = _urlController.text.trim();
        if (sourceUrl.isEmpty) {
          _showError('书源 URL 不能为空');
          return;
        }
        final name = _nameController.text.trim();
        if (name.isEmpty) {
          _showError('书源名称不能为空');
          return;
        }

        final source = BookSource(
          bookSourceUrl: sourceUrl,
          bookSourceName: name,
          bookSourceGroup: _groupController.text.trim().isNotEmpty
              ? _groupController.text.trim()
              : null,
          searchUrl: _searchUrlController.text.trim().isNotEmpty
              ? _searchUrlController.text.trim()
              : null,
          ruleSearch: _ruleSearchController.text.trim().isNotEmpty
              ? _ruleSearchController.text.trim()
              : null,
          ruleBookInfo: _ruleBookInfoController.text.trim().isNotEmpty
              ? _ruleBookInfoController.text.trim()
              : null,
          ruleToc: _ruleTocController.text.trim().isNotEmpty
              ? _ruleTocController.text.trim()
              : null,
          ruleContent: _ruleContentController.text.trim().isNotEmpty
              ? _ruleContentController.text.trim()
              : null,
          exploreUrl: _exploreUrlController.text.trim().isNotEmpty
              ? _exploreUrlController.text.trim()
              : null,
          enabled: widget.source?.enabled ?? true,
          bookSourceType: widget.source?.bookSourceType ?? 0,
          customOrder: widget.source?.customOrder ?? 0,
          enabledExplore: widget.source?.enabledExplore ?? true,
          lastUpdateTime:
              widget.source?.lastUpdateTime ??
              DateTime.now().millisecondsSinceEpoch,
          respondTime: widget.source?.respondTime ?? 180000,
          weight: widget.source?.weight ?? 0,
          eventListener: widget.source?.eventListener ?? false,
          customButton: widget.source?.customButton ?? false,
        );

        await provider.saveSource(source);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_isNew ? '书源创建成功' : '书源更新成功')));
      }
    } catch (e) {
      setState(() => _jsonError = '保存失败: $e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(String message) {
    setState(() => _jsonError = message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? '新建书源' : '编辑书源'),
        actions: [
          // 切换编辑模式
          IconButton(
            icon: Icon(_isJsonMode ? Icons.view_column : Icons.code),
            tooltip: _isJsonMode ? '表单模式' : 'JSON 模式',
            onPressed: () {
              setState(() {
                _isJsonMode = !_isJsonMode;
                _jsonError = null;
              });
            },
          ),
          // 保存按钮
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            tooltip: '保存',
            onPressed: _isSaving ? null : _save,
          ),
        ],
      ),
      body: _isJsonMode ? _buildJsonEditor(theme) : _buildForm(theme),
    );
  }

  Widget _buildForm(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- 基本信息 ----
          Text('基本信息', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _nameController,
            label: '书源名称',
            hint: '例如：笔趣阁',
            icon: Icons.label,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _urlController,
            label: '书源 URL',
            hint: '例如：https://www.example.com',
            icon: Icons.link,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _groupController,
            label: '分组',
            hint: '例如：小说',
            icon: Icons.folder,
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          // ---- 搜索规则 ----
          Text('搜索配置', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _searchUrlController,
            label: '搜索 URL',
            hint: '搜索请求地址，支持 {{key}} 占位符',
            icon: Icons.search,
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _ruleSearchController,
            label: '搜索规则 (ruleSearch)',
            hint: '搜索结果解析规则',
            icon: Icons.rule,
            maxLines: 3,
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          // ---- 详情规则 ----
          Text('详情配置', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _ruleBookInfoController,
            label: '详情规则 (ruleBookInfo)',
            hint: '书籍详情页解析规则',
            icon: Icons.article,
            maxLines: 3,
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          // ---- 目录与正文 ----
          Text('目录与正文', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _ruleTocController,
            label: '目录规则 (ruleToc)',
            hint: '章节列表解析规则',
            icon: Icons.list,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _ruleContentController,
            label: '正文规则 (ruleContent)',
            hint: '正文内容解析规则',
            icon: Icons.text_snippet,
            maxLines: 3,
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          // ---- 发现 ----
          Text('发现配置', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _exploreUrlController,
            label: '发现 URL',
            hint: '发现页请求地址',
            icon: Icons.explore,
            maxLines: 2,
          ),

          const SizedBox(height: 32),

          // 错误提示
          if (_jsonError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _jsonError!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),

          // 保存按钮
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_isNew ? '创建书源' : '保存修改'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildJsonEditor(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('JSON 编辑器', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            '直接编辑书源的完整 JSON 数据',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: _jsonController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              decoration: InputDecoration(
                hintText: '在此粘贴或编辑 JSON...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
          if (_jsonError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _jsonError!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('保存'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }
}
