import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/audio_player_engine.dart';
import '../providers/audio_player_provider.dart';

/// 播放控制组件
class PlayerControls extends ConsumerWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    final notifier = ref.read(audioPlayerProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 进度条
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: state.progressPercent,
            onChanged: (v) {
              final pos = state.duration * v;
              notifier.seekToPosition(pos);
            },
          ),
        ),

        // 时间显示
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(state.position),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              Text(
                _formatDuration(state.duration),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 主控制按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 上一首
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded, size: 32),
              onPressed: state.currentIndex > 0
                  ? () => notifier.previous()
                  : null,
            ),
            const SizedBox(width: 16),

            // 播放/暂停
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: IconButton(
                icon: Icon(
                  state.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  size: 36,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () => notifier.togglePlayPause(),
              ),
            ),
            const SizedBox(width: 16),

            // 下一首
            IconButton(
              icon: const Icon(Icons.skip_next_rounded, size: 32),
              onPressed: state.currentIndex < state.totalTracks - 1
                  ? () => notifier.next()
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 辅助按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AuxButton(
              icon: state.isShuffleEnabled ? Icons.shuffle_on : Icons.shuffle,
              label: '随机',
              isActive: state.isShuffleEnabled,
              onPressed: () => notifier.toggleShuffle(),
            ),
            const SizedBox(width: 8),
            _AuxButton(
              icon: Icons.repeat,
              label: state.loopModeLabel,
              isActive: state.loopMode != PlayRepeatMode.off,
              onPressed: () => notifier.toggleLoopMode(),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    if (h > 0) return '$h:$m:$s';
    return '$m:$s';
  }
}

class _AuxButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const _AuxButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: TextButton.styleFrom(
        foregroundColor: isActive
            ? Theme.of(context).colorScheme.primary
            : null,
      ),
    );
  }
}
