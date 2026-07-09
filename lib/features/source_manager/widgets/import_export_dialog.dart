import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/book_source.dart';
import '../providers/source_provider.dart';

/// 导入/导出书源对话框
///
/// 支持以下方式：
/// - 从剪贴板导入 JSON
/// - 从 URL 导入 JSON
/// - 导出当前列表为 JSON
class ImportExportDialog extends ConsumerStatefulWidget {
  const ImportExportDialog({super.key});

  @override
  ConsumerState<ImportExportDialog> createState() => _ImportExportDialogState();
}

class _ImportExportDialogState extends ConsumerState<ImportExportDialog> {
  bool _isImporting = false;
  bool _isExporting = false;
  String? _error;
  String? _successMessage;

  // 导入预览数据
  List<BookSource>? _previewSources;
  String? _previewRaw;

  // URL 导入
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('导入/导出书源'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---- 导入区域 ----
              _buildSectionHeader(theme, '导入', Icons.file_download),

              // 从剪贴板导入
              _buildActionTile(
                icon: Icons.content_paste,
                title: '从剪贴板导入',
                subtitle: '粘贴已复制的书源 JSON',
                onTap: _importFromClipboard,
              ),

              const Divider(height: 4),

              // 从 URL 导入
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.link, size: 20, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _urlController,
                        decoration: const InputDecoration(
                          hintText: '输入书源 JSON 地址',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: _isImporting ? null : _importFromUrl,
                      child: _isImporting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('导入'),
                    ),
                  ],
                ),
              ),

              const Divider(height: 4),

              // ---- 导出区域 ----
              const SizedBox(height: 12),
              _buildSectionHeader(theme, '导出', Icons.file_upload),

              _buildActionTile(
                icon: Icons.content_copy,
                title: '导出到剪贴板',
                subtitle: '将所有书源导出为 JSON 格式',
                onTap: _isExporting ? null : _exportToClipboard,
              ),

              // ---- 预览区域 ----
              if (_previewSources != null) ...[
                const SizedBox(height: 16),
                _buildSectionHeader(theme, '导入预览', Icons.preview),
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _previewSources!.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: theme.colorScheme.outlineVariant),
                    itemBuilder: (context, index) {
                      final source = _previewSources![index];
                      return ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.web,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(
                          source.bookSourceName,
                          style: theme.textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          source.bookSourceUrl,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: source.bookSourceGroup != null
                            ? Chip(
                                label: Text(
                                  source.bookSourceGroup!,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              )
                            : null,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '共 ${_previewSources!.length} 个书源',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],

                // 确认导入按钮
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _isImporting ? null : _confirmImport,
                      icon: _isImporting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check, size: 18),
                      label: Text(_isImporting ? '导入中...' : '确认导入'),
                    ),
                  ),
                ),

              // ---- 状态消息 ----
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _error!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              if (_successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _successMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ),
            ],
          ),
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

  Widget _buildSectionHeader(ThemeData theme, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }

  /// 从剪贴板导入书源 JSON
  Future<void> _importFromClipboard() async {
    setState(() {
      _isImporting = true;
      _error = null;
      _successMessage = null;
      _previewSources = null;
    });

    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final data = clipboardData?.text;

      if (data == null || data.trim().isEmpty) {
        setState(() {
          _error = '剪贴板内容为空';
          _isImporting = false;
        });
        return;
      }

      await _parseAndPreview(data);
    } catch (e) {
      setState(() {
        _error = '读取剪贴板失败: $e';
        _isImporting = false;
      });
    }
  }

  /// 从 URL 导入书源 JSON
  Future<void> _importFromUrl() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() => _error = '请输入书源 JSON 地址');
      return;
    }

    setState(() {
      _isImporting = true;
      _error = null;
      _successMessage = null;
      _previewSources = null;
    });

    try {
      // 使用 HTTP 请求获取远程 JSON
      // 此处简化处理：假设可以通过 http 包获取
      // 实际实现中应注入 HttpClient 或使用 Dio
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(url));
      final response = await request.close();
      final data = await response.transform(utf8.decoder).join();

      await _parseAndPreview(data);
    } catch (e) {
      setState(() {
        _error = '从 URL 获取书源失败: $e';
        _isImporting = false;
      });
    }
  }

  /// 解析并预览书源 JSON
  Future<void> _parseAndPreview(String jsonString) async {
    try {
      final decoded = jsonDecode(jsonString);

      List<BookSource> sources;
      if (decoded is List) {
        sources = decoded
            .map((e) {
              if (e is Map<String, dynamic>) {
                return BookSource.fromJson(e);
              }
              if (e is String) {
                return BookSource.fromJson(
                    jsonDecode(e) as Map<String, dynamic>);
              }
              return null;
            })
            .whereType<BookSource>()
            .toList();
      } else if (decoded is Map<String, dynamic>) {
        sources = [BookSource.fromJson(decoded)];
      } else {
        setState(() {
          _error = '无法解析的书源数据格式';
          _isImporting = false;
        });
        return;
      }

      if (sources.isEmpty) {
        setState(() {
          _error = '未解析到有效的书源';
          _isImporting = false;
        });
        return;
      }

      setState(() {
        _previewSources = sources;
        _previewRaw = jsonString;
        _isImporting = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = 'JSON 解析失败: $e';
        _isImporting = false;
      });
    }
  }

  /// 确认导入预览中的书源
  Future<void> _confirmImport() async {
    if (_previewSources == null || _previewRaw == null) return;

    setState(() {
      _isImporting = true;
      _error = null;
      _successMessage = null;
    });

    try {
      final provider = ref.read(sourceProvider.notifier);
      final count = await provider.importFromJson(_previewRaw!);

      setState(() {
        _previewSources = null;
        _previewRaw = null;
        _isImporting = false;
        _successMessage = '成功导入 $count 个书源';
      });
    } catch (e) {
      setState(() {
        _error = '导入失败: $e';
        _isImporting = false;
      });
    }
  }

  /// 导出书源到剪贴板
  Future<void> _exportToClipboard() async {
    setState(() {
      _isExporting = true;
      _error = null;
      _successMessage = null;
    });

    try {
      final provider = ref.read(sourceProvider.notifier);
      final sources = provider.filteredSources;

      if (sources.isEmpty) {
        setState(() {
          _error = '没有可导出的书源';
          _isExporting = false;
        });
        return;
      }

      final jsonList = sources.map((s) => s.toJson()).toList();
      final jsonStr = const JsonEncoder.withIndent('  ').convert(jsonList);

      await Clipboard.setData(ClipboardData(text: jsonStr));

      setState(() {
        _isExporting = false;
        _successMessage = '已导出 ${sources.length} 个书源到剪贴板';
      });
    } catch (e) {
      setState(() {
        _error = '导出失败: $e';
        _isExporting = false;
      });
    }
  }
}

/// 便捷方法：显示导入导出对话框
Future<void> showImportExportDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const ImportExportDialog(),
  );
}
