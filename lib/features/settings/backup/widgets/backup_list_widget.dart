import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../engine/backup_manager.dart';

/// 备份文件列表组件
class BackupListWidget extends StatefulWidget {
  final BackupManager backupManager;

  const BackupListWidget({super.key, required this.backupManager});

  @override
  State<BackupListWidget> createState() => _BackupListWidgetState();
}

class _BackupListWidgetState extends State<BackupListWidget> {
  List<FileSystemEntity> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() => _isLoading = true);
    final files = await widget.backupManager.getBackupFiles();
    if (mounted) {
      setState(() {
        _files = files;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_files.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.backup_outlined,
              size: 48,
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 8),
            Text('暂无备份文件', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFiles,
      child: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, index) {
          final entity = _files[index];
          final stat = File(entity.path).statSync();
          final modified = File(entity.path).lastModifiedSync();
          final size = stat.size;
          final name = entity.path.split('/').last;

          return ListTile(
            leading: Icon(
              name.endsWith('.enc') ? Icons.lock : Icons.description,
              color: name.endsWith('.enc')
                  ? Colors.orange
                  : Theme.of(context).colorScheme.primary,
            ),
            title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              '${_formatSize(size)} · ${_formatDate(modified)}',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () async {
                await widget.backupManager.deleteBackup(entity.path);
                _loadFiles();
              },
            ),
            onTap: () {
              // 导入此备份
              _showImportDialog(context, entity.path, name);
            },
          );
        },
      ),
    );
  }

  void _showImportDialog(BuildContext context, String path, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('导入备份'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('文件: $name'),
            const SizedBox(height: 8),
            Text(
              name.endsWith('.enc') ? '此备份已加密，需要密码' : '是否导入此备份？',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            if (name.endsWith('.enc')) ...[
              const SizedBox(height: 12),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '密码',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => _importPassword = v,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _importBackup(context, path, _importPassword);
            },
            child: const Text('导入'),
          ),
        ],
      ),
    );
  }

  String _importPassword = '';

  Future<void> _importBackup(
    BuildContext context,
    String path,
    String? password,
  ) async {
    try {
      final count = await widget.backupManager.importBackup(
        path,
        password: password?.isNotEmpty == true ? password : null,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('成功导入 $count 条数据')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('导入失败: $e')));
      }
    }
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
