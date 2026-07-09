import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/audio_player_engine.dart';
import '../providers/audio_player_provider.dart';

/// 播放列表/章节选择组件
class PlaylistWidget extends ConsumerWidget {
  final List<PlaylistItem> items;
  final int? activeIndex;

  const PlaylistWidget({
    super.key,
    required this.items,
    this.activeIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isCurrent = index == state.currentIndex;

        return ListTile(
          dense: true,
          selected: isCurrent,
          selectedTileColor:
              Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
          leading: isCurrent
              ? Icon(Icons.play_arrow_rounded,
                  color: Theme.of(context).colorScheme.primary)
              : Icon(Icons.music_note_outlined,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
          title: Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: item.duration != null
              ? Text(
                  _formatDuration(item.duration!),
                  style: Theme.of(context).textTheme.labelSmall,
                )
              : null,
          onTap: () {
            ref.read(audioPlayerProvider.notifier).seekTo(index);
          },
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

/// 播放列表条目
class PlaylistItem {
  final String title;
  final String url;
  final Duration? duration;

  const PlaylistItem({
    required this.title,
    required this.url,
    this.duration,
  });
}
