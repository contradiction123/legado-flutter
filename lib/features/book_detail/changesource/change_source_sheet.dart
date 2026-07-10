import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/book_source.dart';
import '../../../domain/models/search_book.dart';
import 'change_source_provider.dart';

/// 换源底部弹窗
///
/// 功能：
/// 1. 打开后自动开始测试所有已启用书源
/// 2. 显示测试进度（加载状态）
/// 3. 完成后按结果分组展示：可用源 / 不可用源
/// 4. 可用源按响应时间排序，点击即选择
/// 5. 通过 Navigator.pop 返回选中的 SearchBook
class ChangeSourceSheet extends ConsumerStatefulWidget {
  /// 当前书籍名称
  final String bookName;

  /// 当前书籍作者
  final String bookAuthor;

  /// 当前书源 URL（用于标记当前源）
  final String currentOrigin;

  /// 当前搜索结果对象
  final SearchBook searchBook;

  const ChangeSourceSheet({
    super.key,
    required this.bookName,
    required this.bookAuthor,
    required this.currentOrigin,
    required this.searchBook,
  });

  @override
  ConsumerState<ChangeSourceSheet> createState() => _ChangeSourceSheetState();
}

class _ChangeSourceSheetState extends ConsumerState<ChangeSourceSheet> {
  @override
  void initState() {
    super.initState();
    // 进入弹窗后自动开始测试书源
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(changeSourceProvider.notifier)
          .testSources(widget.bookName, widget.bookAuthor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changeSourceProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, state),
          const Divider(height: 1),
          if (state.isLoading)
            _buildLoadingState(colorScheme)
          else if (state.error != null)
            _buildErrorState(context, state.error!)
          else
            _buildSourceList(context, state, colorScheme),
        ],
      ),
    );
  }

  /// 弹窗标题栏
  Widget _buildHeader(BuildContext context, ChangeSourceState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('选择书源', style: Theme.of(context).textTheme.titleMedium),
          if (!state.isLoading)
            Text(
              '${state.sources.length} 个书源',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  /// 加载中状态
  Widget _buildLoadingState(ColorScheme colorScheme) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('正在测试各书源...'),
        ],
      ),
    );
  }

  /// 错误状态
  Widget _buildErrorState(BuildContext context, String error) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () {
              ref
                  .read(changeSourceProvider.notifier)
                  .testSources(widget.bookName, widget.bookAuthor);
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 书源列表（分组展示）
  Widget _buildSourceList(
    BuildContext context,
    ChangeSourceState state,
    ColorScheme colorScheme,
  ) {
    final successfulSources = ref
        .read(changeSourceProvider.notifier)
        .getSuccessfulSources();
    final failedSources = ref
        .read(changeSourceProvider.notifier)
        .getFailedSources();

    return Flexible(
      child: ListView(
        shrinkWrap: true,
        children: [
          // ─── 可用源 ───
          if (successfulSources.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '可用源 (${successfulSources.length})',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: colorScheme.primary),
              ),
            ),
            ...successfulSources.map(
              (source) => _buildSourceTile(
                context,
                source,
                state,
                colorScheme,
                success: true,
              ),
            ),
          ],
          // ─── 不可用源 ───
          if (failedSources.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                '不可用源 (${failedSources.length})',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ...failedSources.map(
              (source) => _buildSourceTile(
                context,
                source,
                state,
                colorScheme,
                success: false,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 单个书源条目
  Widget _buildSourceTile(
    BuildContext context,
    BookSource source,
    ChangeSourceState state,
    ColorScheme colorScheme, {
    required bool success,
  }) {
    final isCurrent = source.bookSourceUrl == widget.currentOrigin;
    final result = state.testResults[source.bookSourceUrl];
    final searchResult = result?.searchResult;

    return ListTile(
      leading: Icon(
        success ? Icons.check_circle : Icons.cancel,
        color: success
            ? colorScheme.primary
            : colorScheme.error.withValues(alpha: 0.5),
        size: 20,
      ),
      title: Text(
        source.bookSourceName,
        style: TextStyle(
          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        isCurrent
            ? '当前书源'
            : (success && result != null
                  ? '响应: ${result.responseTimeMs}ms'
                  : ''),
      ),
      trailing: isCurrent
          ? Icon(Icons.check, color: colorScheme.primary, size: 20)
          : null,
      enabled: success && !isCurrent,
      onTap: success && !isCurrent && searchResult != null
          ? () {
              // 关闭弹窗并返回选中的搜索结果
              Navigator.pop(context, searchResult);
            }
          : null,
    );
  }
}

/// 便捷方法：显示换源弹窗
///
/// 返回用户选中的 [SearchBook]，如果用户取消则返回 null。
/// 调用方可根据返回结果执行换源操作。
Future<SearchBook?> showChangeSourceSheet(
  BuildContext context, {
  required String bookName,
  required String bookAuthor,
  required String currentOrigin,
  required SearchBook searchBook,
}) {
  return showModalBottomSheet<SearchBook>(
    context: context,
    isScrollControlled: true,
    builder: (context) => ChangeSourceSheet(
      bookName: bookName,
      bookAuthor: bookAuthor,
      currentOrigin: currentOrigin,
      searchBook: searchBook,
    ),
  );
}
