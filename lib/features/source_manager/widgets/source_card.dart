import 'package:flutter/material.dart';

import '../../../domain/models/book_source.dart';

/// 书源卡片组件
class SourceCard extends StatelessWidget {
  final BookSource source;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggleEnabled;

  const SourceCard({
    super.key,
    required this.source,
    this.onTap,
    this.onToggleEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Icon(
          source.enabled ? Icons.check_circle : Icons.circle_outlined,
          color: source.enabled ? Colors.green : Colors.grey,
          size: 20,
        ),
        title: Text(
          source.bookSourceName,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          source.bookSourceGroup ?? '未分组',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${source.respondTime}ms',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: 4),
            Switch(
              value: source.enabled,
              onChanged: onToggleEnabled,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
