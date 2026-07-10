import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/dict_provider.dart';

/// 查词结果弹窗
///
/// 对标原：DictSheet.kt
class DictSheet extends ConsumerStatefulWidget {
  final String word;
  final bool show;

  const DictSheet({super.key, required this.word, this.show = true});

  /// 显示查词弹窗
  static Future<void> open(BuildContext context, String word) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ProviderScope(child: DictSheet(word: word)),
    );
  }

  @override
  ConsumerState<DictSheet> createState() => _DictSheetState();
}

class _DictSheetState extends ConsumerState<DictSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.word.isNotEmpty) {
        ref.read(dictProvider.notifier).search(widget.word);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dictProvider);
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // 顶部栏
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.word,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // 多规则 Tab 栏
            if (state.rules.length > 1)
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: state.rules.length,
                  itemBuilder: (context, index) {
                    final isSelected = state.selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(state.rules[index].name),
                        selected: isSelected,
                        onSelected: (_) {
                          ref.read(dictProvider.notifier).selectRule(index);
                        },
                      ),
                    );
                  },
                ),
              ),

            // 内容区
            Expanded(child: _buildContent(state, theme, scrollController)),
          ],
        );
      },
    );
  }

  Widget _buildContent(
    DictState state,
    ThemeData theme,
    ScrollController scrollController,
  ) {
    // 加载中
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 空状态
    if (state.emptyReason != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 12),
              Text(
                state.emptyReason!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 显示结果
    if (state.htmlContent.isNotEmpty) {
      return SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        child: _renderHtmlContent(state.htmlContent, theme),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _renderHtmlContent(String html, ThemeData theme) {
    // 从 HTML 中提取纯文本
    final imgRegex = RegExp(
      r"<img\s+[^>]*src\s*=\s*["
      "']([^"
      "']+)["
      "'][^>]*/?>",
    );
    final text = html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();

    // 提取图片
    final images = imgRegex.allMatches(html).map((m) => m.group(1)!).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 文本内容
        if (text.isNotEmpty)
          SelectableText(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
        // 图片
        ...images.map(
          (url) => Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Image.network(
              url,
              fit: BoxFit.fitWidth,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}
