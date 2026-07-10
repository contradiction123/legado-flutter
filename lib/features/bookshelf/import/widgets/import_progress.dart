import 'package:flutter/material.dart';

/// 导入进度指示器
class ImportProgress extends StatelessWidget {
  final int progress;
  final int total;
  final int successCount;
  final int failedCount;
  final bool isImporting;

  const ImportProgress({
    super.key,
    required this.progress,
    required this.total,
    required this.successCount,
    required this.failedCount,
    required this.isImporting,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = total > 0 ? progress / total : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isImporting) ...[
          LinearProgressIndicator(value: ratio),
          const SizedBox(height: 12),
          Text('正在导入 $progress / $total...', style: theme.textTheme.bodyMedium),
        ] else if (total > 0) ...[
          Icon(
            failedCount > 0
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline,
            size: 48,
            color: failedCount > 0 ? Colors.orange : Colors.green,
          ),
          const SizedBox(height: 12),
          Text('导入完成', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            '成功 $successCount 本' +
                (failedCount > 0 ? '，失败 $failedCount 本' : ''),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
