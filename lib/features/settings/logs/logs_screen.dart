import 'package:flutter/material.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/logging/log_file_info.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final AppLogger _logger = AppLogger.instance;

  late Future<List<LogFileInfo>> _filesFuture;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _filesFuture = _logger.listFiles();
  }

  Future<void> _reload() async {
    setState(() {
      _filesFuture = _logger.listFiles();
    });
    await _filesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('日志管理'),
        actions: [
          IconButton(
            onPressed: _busy ? null : _reload,
            icon: const Icon(Icons.refresh),
            tooltip: '刷新',
          ),
        ],
      ),
      body: FutureBuilder<List<LogFileInfo>>(
        future: _filesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('读取日志失败: ${snapshot.error}'));
          }

          final files = snapshot.data ?? const <LogFileInfo>[];
          if (files.isEmpty) {
            return const Center(child: Text('暂无日志文件'));
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.separated(
              itemCount: files.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final file = files[index];
                return ListTile(
                  title: Text(file.name),
                  subtitle: Text(
                    '${_formatSize(file.size)} | ${_formatDateTime(file.modifiedAt)}',
                  ),
                  trailing: PopupMenuButton<_LogAction>(
                    onSelected: (action) => _handleAction(file, action),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: _LogAction.view, child: Text('查看')),
                      PopupMenuItem(value: _LogAction.share, child: Text('分享')),
                      PopupMenuItem(value: _LogAction.export, child: Text('导出')),
                      PopupMenuItem(
                        value: _LogAction.replay,
                        child: Text('回放到控制台'),
                      ),
                      PopupMenuItem(value: _LogAction.delete, child: Text('删除')),
                    ],
                  ),
                  onTap: () => _openViewer(file),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleAction(LogFileInfo file, _LogAction action) async {
    if (action == _LogAction.view) {
      await _openViewer(file);
      return;
    }

    if (action == _LogAction.share) {
      await _runBusy(() => _logger.shareFile(file), successText: '已发起分享');
      return;
    }

    if (action == _LogAction.export) {
      await _runBusy(() async {
        final path = await _logger.exportFile(file);
        _showSnackBar(path == null ? '已取消导出' : '导出完成: $path');
      });
      return;
    }

    if (action == _LogAction.replay) {
      await _runBusy(
        () => _logger.replayFileToConsole(file),
        successText: '已回放到控制台日志',
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('删除日志'),
        content: Text('确认删除 ${file.name} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    await _runBusy(
      () => _logger.deleteFile(file.path),
      successText: '已删除日志',
    );
    await _reload();
  }

  Future<void> _openViewer(LogFileInfo file) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => LogViewerScreen(file: file),
      ),
    );
  }

  Future<void> _runBusy(
    Future<void> Function() action, {
    String? successText,
  }) async {
    if (_busy) {
      return;
    }
    setState(() {
      _busy = true;
    });
    try {
      await action();
      if (successText != null && mounted) {
        _showSnackBar(successText);
      }
    } catch (error) {
      if (mounted) {
        _showSnackBar('操作失败: $error');
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  void _showSnackBar(String text) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String _formatSize(int size) {
    if (size >= 1024 * 1024) {
      return '${(size / 1024 / 1024).toStringAsFixed(2)} MB';
    }
    if (size >= 1024) {
      return '${(size / 1024).toStringAsFixed(2)} KB';
    }
    return '$size B';
  }

  String _formatDateTime(DateTime time) {
    final year = time.year.toString().padLeft(4, '0');
    final month = time.month.toString().padLeft(2, '0');
    final day = time.day.toString().padLeft(2, '0');
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute:$second';
  }
}

class LogViewerScreen extends StatefulWidget {
  const LogViewerScreen({super.key, required this.file});

  final LogFileInfo file;

  @override
  State<LogViewerScreen> createState() => _LogViewerScreenState();
}

class _LogViewerScreenState extends State<LogViewerScreen> {
  final AppLogger _logger = AppLogger.instance;

  late Future<String> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = _logger.readFile(widget.file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.file.name),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await _logger.replayFileToConsole(widget.file);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('已回放到控制台日志')),
                  );
                }
              } catch (error) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('回放失败: $error')),
                  );
                }
              }
            },
            icon: const Icon(Icons.terminal),
            tooltip: '回放到控制台',
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: _contentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('读取日志失败: ${snapshot.error}'));
          }

          final content = snapshot.data ?? '';
          if (content.isEmpty) {
            return const Center(child: Text('日志内容为空'));
          }

          return Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                content,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

enum _LogAction { view, share, export, replay, delete }
