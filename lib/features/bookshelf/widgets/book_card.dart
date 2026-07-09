import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/book.dart';

/// 书籍卡片（网格模式）
class BookCard extends StatelessWidget {
  final Book book;
  final bool isSelected;
  final bool isEditMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const BookCard({
    super.key,
    required this.book,
    this.isSelected = false,
    this.isEditMode = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 封面
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildCover(colorScheme),
                ),
              ),
              const SizedBox(height: 8),
              // 书名
              Text(
                book.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              // 最新章节或作者
              Text(
                book.latestChapterTitle ?? book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          // 编辑模式选中遮罩
          if (isEditMode)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: colorScheme.onPrimary,
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCover(ColorScheme colorScheme) {
    final coverUrl = book.customCoverUrl ?? book.coverUrl;
    if (coverUrl != null && coverUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: coverUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholderCover(colorScheme),
        errorWidget: (context, url, error) => _buildPlaceholderCover(colorScheme),
      );
    }
    return _buildPlaceholderCover(colorScheme);
  }

  Widget _buildPlaceholderCover(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.book_outlined,
          size: 48,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
