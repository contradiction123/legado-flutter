import 'package:flutter/material.dart';

/// WebDAV 配置弹窗
class WebDavConfigDialog extends StatefulWidget {
  final String? initialUrl;
  final String? initialUsername;
  final String? initialPassword;
  final String? initialBasePath;

  const WebDavConfigDialog({
    super.key,
    this.initialUrl,
    this.initialUsername,
    this.initialPassword,
    this.initialBasePath,
  });

  /// 显示配置弹窗
  static Future<WebDavConfig?> show(
    BuildContext context, {
    WebDavConfig? initial,
  }) {
    return showDialog<WebDavConfig>(
      context: context,
      builder: (ctx) => WebDavConfigDialog(
        initialUrl: initial?.url,
        initialUsername: initial?.username,
        initialPassword: initial?.password,
        initialBasePath: initial?.basePath,
      ),
    );
  }

  @override
  State<WebDavConfigDialog> createState() => _WebDavConfigDialogState();
}

class _WebDavConfigDialogState extends State<WebDavConfigDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _urlController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _basePathController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialUrl ?? '');
    _usernameController = TextEditingController(
      text: widget.initialUsername ?? '',
    );
    _passwordController = TextEditingController(
      text: widget.initialPassword ?? '',
    );
    _basePathController = TextEditingController(
      text: widget.initialBasePath ?? '/legado_backup',
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _basePathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('WebDAV 配置'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // WebDAV URL
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'WebDAV 地址',
                  hintText: 'https://example.com/dav/',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '请输入地址';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 用户名
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: '用户名',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '请输入用户名';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 密码
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: '密码',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '请输入密码';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // 备份路径
              TextFormField(
                controller: _basePathController,
                decoration: const InputDecoration(
                  labelText: '备份路径（可选）',
                  hintText: '/legado_backup',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.folder),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(onPressed: _onSave, child: const Text('保存')),
      ],
    );
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      WebDavConfig(
        url: _urlController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        basePath: _basePathController.text.trim().isNotEmpty
            ? _basePathController.text.trim()
            : '/legado_backup',
      ),
    );
  }
}

/// WebDAV 配置数据
class WebDavConfig {
  final String url;
  final String username;
  final String password;
  final String basePath;

  const WebDavConfig({
    required this.url,
    required this.username,
    required this.password,
    this.basePath = '/legado_backup',
  });

  Map<String, dynamic> toJson() => {
    'url': url,
    'username': username,
    'password': password,
    'basePath': basePath,
  };

  factory WebDavConfig.fromJson(Map<String, dynamic> json) => WebDavConfig(
    url: json['url'] as String,
    username: json['username'] as String,
    password: json['password'] as String,
    basePath: json['basePath'] as String? ?? '/legado_backup',
  );
}
