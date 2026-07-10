import 'package:flutter/material.dart';

import '../../../../domain/models/book_group.dart';

/// 分组筛选栏（顶部横向 Chip 列表）
class GroupFilterBar extends StatelessWidget {
  final List<BookGroup> groups;
  final int selectedGroupId;
  final ValueChanged<int> onGroupSelected;

  const GroupFilterBar({
    super.key,
    required this.groups,
    required this.selectedGroupId,
    required this.onGroupSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          _buildChip(context, '全部', 0),
          ...groups.map((g) => _buildChip(context, g.groupName, g.groupId)),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, int groupId) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedGroupId == groupId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: ActionChip(
        label: Text(label),
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          color: isSelected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        backgroundColor: isSelected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest,
        side: isSelected
            ? BorderSide(color: colorScheme.primaryContainer)
            : BorderSide(color: colorScheme.outlineVariant),
        onPressed: () => onGroupSelected(groupId),
      ),
    );
  }
}
