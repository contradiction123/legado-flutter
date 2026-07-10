import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tts_models.dart';
import '../providers/tts_provider.dart';

/// TTS 朗读控制面板
///
/// 对标原版：ReadAloudSheet.kt
class TtsControlSheet extends ConsumerStatefulWidget {
  const TtsControlSheet({super.key});

  @override
  ConsumerState<TtsControlSheet> createState() => _TtsControlSheetState();
}

class _TtsControlSheetState extends ConsumerState<TtsControlSheet> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ttsProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 拖动指示条
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          Text('朗读控制', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),

          // 当前朗读文本
          if (state.currentText != null && state.currentText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                state.currentText!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),

          LinearProgressIndicator(
            value: state.progress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(state.elapsedSeconds),
                style: theme.textTheme.labelSmall,
              ),
              if (state.timerMode == TtsTimerMode.countdown)
                Text(
                  '剩余 ${state.timerMinutes} 分钟',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // 主控制按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ControlButton(
                icon: Icons.skip_previous_rounded,
                onPressed: () => ref.read(ttsProvider.notifier).prevParagraph(),
              ),
              const SizedBox(width: 12),
              _PlayButton(
                isPlaying: state.playState == TtsPlayState.playing,
                onPressed: () =>
                    ref.read(ttsProvider.notifier).togglePlayPause(),
              ),
              const SizedBox(width: 12),
              _ControlButton(
                icon: Icons.skip_next_rounded,
                onPressed: () => ref.read(ttsProvider.notifier).nextParagraph(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () => ref.read(ttsProvider.notifier).stop(),
                icon: const Icon(Icons.stop_rounded, size: 18),
                label: const Text('停止'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => ref.read(ttsProvider.notifier).addTimer(),
                icon: const Icon(Icons.timer_outlined, size: 18),
                label: Text(
                  state.timerMinutes > 0 ? '${state.timerMinutes}分' : '定时',
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => _showConfig(context),
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('设置'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showConfig(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => SizedBox(height: 280, child: const TtsConfigSheet()),
    );
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _ControlButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      iconSize: 28,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;
  const _PlayButton({required this.isPlaying, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
      ),
      iconSize: 56,
      color: Theme.of(context).colorScheme.primary,
      onPressed: onPressed,
    );
  }
}

/// TTS 配置面板
/// 对标原版：ReadAloudConfigSheet.kt
class TtsConfigSheet extends ConsumerStatefulWidget {
  const TtsConfigSheet({super.key});

  @override
  ConsumerState<TtsConfigSheet> createState() => _TtsConfigSheetState();
}

class _TtsConfigSheetState extends ConsumerState<TtsConfigSheet> {
  @override
  Widget build(BuildContext context) {
    final config = ref.watch(ttsProvider).playState == TtsPlayState.stopped
        ? const TtsConfig()
        : ref.read(ttsProvider.notifier).engine.config;
    final provider = ref.read(ttsProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('朗读设置', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 20),
          _SliderConfig(
            label: '语速',
            value: config.speed,
            min: 0.2,
            max: 2.0,
            displayValue: '${(config.speed * 100).round()}%',
            onChanged: (v) => provider.setSpeed(v),
          ),
          const SizedBox(height: 16),
          _SliderConfig(
            label: '音调',
            value: config.pitch,
            min: 0.5,
            max: 2.0,
            displayValue: config.pitch.toStringAsFixed(1),
            onChanged: (v) => provider.setPitch(v),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('完成'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliderConfig extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String displayValue;
  final ValueChanged<double> onChanged;

  const _SliderConfig({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.displayValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
        SizedBox(
          width: 48,
          child: Text(
            displayValue,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
