import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 个人中心页面
///
/// 对标原：MyActivity.kt
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          ListTile(
            leading: Icon(
              Icons.source_outlined,
              color: theme.colorScheme.primary,
            ),
            title: const Text('书源管理'),
            subtitle: const Text('添加、导入、编辑和启用书源'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/sources'),
          ),
        ],
      ),
    );
  }
}
