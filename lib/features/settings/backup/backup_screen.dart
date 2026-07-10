import 'package:flutter/material.dart';

import 'engine/backup_manager.dart';
import 'engine/webdav_manager.dart';
import 'providers/backup_provider.dart';
import 'widgets/backup_list_widget.dart';
import 'widgets/webdav_config_dialog.dart';

/// 备份管理页面
///
/// 对标原：BackupActivity.kt
class BackupScreen extends StatefulWidget {
  final BackupProvider backupProvider;

  const BackupScreen({super.key, required this.backupProvider});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isExporting = false;
  String? _password;
  String? _lastExportPath;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('备份与恢复'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '本地备份'),
            Tab(text: 'WebDAV'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildLocalBackupTab(theme), _buildWebDavTab(theme)],
      ),
    );
  }

  Widget _buildLocalBackupTab(ThemeData theme) {
    return Column(
      children: [
        // 操作区
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 导出按钮
              Expanded(
                child: FilledButton.icon(
                  icon: _isExporting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.backup),
                  label: Text(_isExporting ? '导出中…' : '导出备份'),
                  onPressed: _isExporting ? null : _onExport,
                ),
              ),
              const SizedBox(width: 12),
              // 导入按钮
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.restore),
                  label: const Text('导入备份'),
                  onPressed: _onImport,
                ),
              ),
            ],
          ),
        ),

        if (_lastExportPath != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '备份已保存',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        const SizedBox(height: 8),

        // 备份文件列表
        Expanded(
          child: BackupListWidget(
            backupManager: widget.backupProvider.backupManager,
          ),
        ),
      ],
    );
  }

  Widget _buildWebDavTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // WebDAV 状态
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cloud, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text('WebDAV 同步', style: theme.textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.backupProvider.webDavManager != null
                      ? '已配置 WebDAV'
                      : '未配置 WebDAV',
                  style: TextStyle(
                    color: widget.backupProvider.webDavManager != null
                        ? Colors.green
                        : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.settings),
                      label: const Text('配置'),
                      onPressed: _onConfigureWebDav,
                    ),
                    const SizedBox(width: 8),
                    if (widget.backupProvider.webDavManager != null) ...[
                      OutlinedButton.icon(
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text('上传'),
                        onPressed: _onWebDavUpload,
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.cloud_download),
                        label: const Text('下载'),
                        onPressed: _onWebDavDownload,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // 说明
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '说明',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '通过 WebDAV 可以将备份同步到远程服务器（如 NextCloud、Synology 等），'
                  '方便在多设备间共享书源和配置。',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onExport() async {
    setState(() => _isExporting = true);

    // 如果需要加密，弹出密码输入
    String? password;
    final useEncryption = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('备份加密'),
        content: const Text('是否对备份文件加密？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('不加密'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('加密'),
          ),
        ],
      ),
    );

    if (useEncryption == true) {
      password = await showDialog<String>(
        context: context,
        builder: (ctx) {
          final pwCtrl = TextEditingController();
          return AlertDialog(
            title: const Text('设置密码'),
            content: TextField(
              controller: pwCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '密码',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, pwCtrl.text),
                child: const Text('确定'),
              ),
            ],
          );
        },
      );
    }

    try {
      final path = await widget.backupProvider.exportBackup(password: password);
      if (mounted) {
        setState(() {
          _lastExportPath = path;
          _isExporting = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('备份已导出: $path')));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isExporting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('导出失败: $e')));
      }
    }
  }

  void _onImport() async {
    // 使用 FilePicker 选择文件
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('请在备份文件列表中点击要导入的备份')));
  }

  void _onConfigureWebDav() async {
    final result = await WebDavConfigDialog.show(context);
    if (result != null && mounted) {
      widget.backupProvider.configureWebDav(
        url: result.url,
        username: result.username,
        password: result.password,
        basePath: result.basePath,
      );
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('WebDAV 配置已保存')));
    }
  }

  Future<void> _onWebDavUpload() async {
    if (_lastExportPath == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先导出本地备份')));
      return;
    }

    final ok = await widget.backupProvider.uploadToWebDav(_lastExportPath!);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(ok ? '上传成功' : '上传失败')));
    }
  }

  Future<void> _onWebDavDownload() async {
    final manager = widget.backupProvider.webDavManager;
    if (manager == null) return;

    final files = await manager.listBackups();
    if (!mounted) return;

    if (files.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('远程没有备份文件')));
      return;
    }

    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('选择要下载的备份'),
        children: files
            .map(
              (f) => SimpleDialogOption(
                onPressed: () => Navigator.pop(ctx, f.fileName),
                child: Text(f.fileName),
              ),
            )
            .toList(),
      ),
    );

    if (selected != null) {
      final localPath = await manager.downloadBackup(selected);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localPath != null ? '下载成功: $localPath' : '下载失败'),
          ),
        );
      }
    }
  }
}
