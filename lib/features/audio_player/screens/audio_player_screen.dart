import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../engine/audio_player_engine.dart';
import '../providers/audio_player_provider.dart';
import '../widgets/player_controls.dart';
import '../widgets/playlist_widget.dart';

/// 有声书播放页面
///
/// 对标原版：AudioPlayActivity.kt / AudioPlayViewModel.kt
class AudioPlayerScreen extends ConsumerStatefulWidget {
  /// 音频文件 URL 列表（本地路径或网络 URL）
  final List<String>? urls;

  /// 章节标题列表
  final List<String>? titles;

  /// 书籍名称
  final String? bookTitle;

  /// 作者
  final String? bookAuthor;

  const AudioPlayerScreen({
    super.key,
    this.urls,
    this.titles,
    this.bookTitle,
    this.bookAuthor,
  });

  @override
  ConsumerState<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends ConsumerState<AudioPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initPlayer();
    });
  }

  void _initPlayer() {
    if (widget.urls != null && widget.urls!.isNotEmpty) {
      final notifier = ref.read(audioPlayerProvider.notifier);
      notifier.setPlaylist(widget.urls!);
      notifier.setMetadata(
        bookTitle: widget.bookTitle,
        bookAuthor: widget.bookAuthor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(audioPlayerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.bookTitle ?? '有声书',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (state.isPlaying)
            IconButton(
              icon: const Icon(Icons.minimize),
              tooltip: '最小化',
              onPressed: () => Navigator.pop(context),
            ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(flex: 2),

          // 封面目占位
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.headphones,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 书名 + 章节
          Text(
            widget.bookTitle ?? '',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            state.currentChapterTitle.isNotEmpty
                ? state.currentChapterTitle
                : widget.titles?.isNotEmpty == true
                    ? widget.titles![state.currentIndex.clamp(
                        0, widget.titles!.length - 1)]
                    : '',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 1),

          // 播放控制
          const PlayerControls(),
          const SizedBox(height: 16),

          // 播放列表
          if (widget.titles != null) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '章节列表',
                    style: theme.textTheme.titleSmall,
                  ),
                  const Spacer(),
                  Text(
                    '${state.totalTracks} 章',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: PlaylistWidget(
                items: _buildPlaylistItems(),
                activeIndex: state.currentIndex,
              ),
            ),
          ],

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  List<PlaylistItem> _buildPlaylistItems() {
    final titles = widget.titles ?? [];
    final urls = widget.urls ?? [];
    final items = <PlaylistItem>[];

    for (var i = 0; i < urls.length && i < titles.length; i++) {
      items.add(PlaylistItem(
        title: titles[i],
        url: urls[i],
      ));
    }

    return items;
  }
}
