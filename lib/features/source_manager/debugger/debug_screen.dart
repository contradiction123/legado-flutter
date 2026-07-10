import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/source_provider.dart';
import 'debug_provider.dart';
import 'widgets/debug_result_view.dart';

/// 书源调试器页面
///
/// 用于调试书源的搜索、详情、目录、正文各步骤。
/// 支持选择书源、输入关键词/URL、分步调试和一键全跑。
class DebugScreen extends ConsumerStatefulWidget {
  const DebugScreen({super.key});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  final _inputController = TextEditingController();
  bool _showSourcePicker = false;

  @override
  void initState() {
    super.initState();
    final inputText = ref.read(debugProvider).inputText;
    _inputController.text = inputText;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final debugState = ref.watch(debugProvider);
    final sourceState = ref.watch(sourceProvider);
    final debugProviderNotifier = ref.read(debugProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('书源调试器'),
        actions: [
          // 清空结果
          if (debugState.hasAnyResult)
            IconButton(
              icon: const Icon(Icons.clear_all),
              tooltip: '清空结果',
              onPressed: () {
                debugProviderNotifier.clearResults();
                _inputController.clear();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // ---- 书源选择器 ----
          _buildSourceSelector(theme, debugState, sourceState),

          // ---- 输入区域 ----
          _buildInputArea(theme, debugState, debugProviderNotifier),

          // ---- 步骤按钮 ----
          _buildStepButtons(theme, debugState, debugProviderNotifier),

          // ---- 结果区域 ----
          Expanded(child: _buildResultsArea(theme, debugState)),
        ],
      ),
    );
  }

  /// 书源选择器
  Widget _buildSourceSelector(
    ThemeData theme,
    DebugState debugState,
    SourceState sourceState,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.source, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () =>
                  setState(() => _showSourcePicker = !_showSourcePicker),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        debugState.selectedSource?.bookSourceName ?? '选择书源...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: debugState.selectedSource != null
                              ? null
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Icon(
                      _showSourcePicker ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (debugState.selectedSource != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              tooltip: '清除选择',
              onPressed: () =>
                  ref.read(debugProvider.notifier).selectSource(null),
            ),
          ],
        ],
      ),
    );
  }

  /// 输入区域
  Widget _buildInputArea(
    ThemeData theme,
    DebugState debugState,
    DebugProvider provider,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText: debugState.selectedSource != null
                    ? '输入搜索关键词或 URL...'
                    : '请先选择书源',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                prefixIcon: const Icon(Icons.search, size: 20),
              ),
              onChanged: (value) => provider.setInputText(value),
              onSubmitted: (_) {
                if (debugState.selectedSource != null) {
                  provider.runStep(DebugStep.search);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 步骤操作按钮
  Widget _buildStepButtons(
    ThemeData theme,
    DebugState debugState,
    DebugProvider provider,
  ) {
    final hasSource = debugState.selectedSource != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        children: [
          // 步骤按钮行
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: DebugStep.values.map((step) {
                final isRunning = debugState.runningStep == step;
                final hasResult = debugState.resultFor(step) != null;
                final isSuccess =
                    debugState.resultFor(step)?.isSuccess ?? false;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildStepButton(
                    theme: theme,
                    step: step,
                    isEnabled: hasSource && !debugState.isRunningAll,
                    isRunning: isRunning,
                    hasResult: hasResult,
                    isSuccess: isSuccess,
                    onPressed: () => provider.runStep(step),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // 运行全部按钮
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: hasSource && !debugState.isRunningAll
                  ? () => provider.runAllSteps()
                  : null,
              icon: debugState.isRunningAll
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow, size: 18),
              label: Text(debugState.isRunningAll ? '运行中...' : '运行所有步骤'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepButton({
    required ThemeData theme,
    required DebugStep step,
    required bool isEnabled,
    required bool isRunning,
    required bool hasResult,
    required bool isSuccess,
    required VoidCallback onPressed,
  }) {
    Color? backgroundColor;
    Color? foregroundColor;

    if (hasResult) {
      if (isSuccess) {
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        foregroundColor = Colors.green.shade700;
      } else {
        backgroundColor = theme.colorScheme.errorContainer;
        foregroundColor = theme.colorScheme.onErrorContainer;
      }
    }

    return FilterChip(
      label: Text(step.label),
      selected: hasResult,
      selectedColor: backgroundColor,
      avatar: isRunning
          ? SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foregroundColor ?? theme.colorScheme.primary,
              ),
            )
          : hasResult
          ? Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              size: 16,
              color: foregroundColor,
            )
          : null,
      onSelected: isEnabled ? (_) => onPressed : null,
    );
  }

  /// 结果展示区域
  Widget _buildResultsArea(ThemeData theme, DebugState debugState) {
    if (!debugState.hasAnyResult && debugState.error == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bug_report_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              '选择一个书源，输入关键词或 URL',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '然后点击上方步骤按钮开始调试',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    if (debugState.error != null && !debugState.hasAnyResult) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              debugState.error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // 全局错误提示
        if (debugState.error != null)
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, size: 16, color: theme.colorScheme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    debugState.error!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // 各步骤结果
        ...DebugStep.values.map((step) {
          final result = debugState.resultFor(step);
          if (result == null) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: DebugResultView(result: result),
          );
        }),
      ],
    );
  }
}
