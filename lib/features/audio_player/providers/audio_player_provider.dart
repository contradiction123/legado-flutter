import 'package:flutter_riverpod/legacy.dart';

import '../engine/audio_player_engine.dart';

/// 有声书状态管理
class AudioPlayerProvider extends StateNotifier<AudioPlayerState> {
  final AudioPlayerEngine _engine;

  AudioPlayerProvider() : _engine = AudioPlayerEngine(), super(const AudioPlayerState()) {
    _engine.onStateChanged = () {
      state = _engine.state;
    };
  }

  /// 设置播放列表
  void setPlaylist(List<String> urls, {int startIndex = 0}) {
    _engine.setPlaylist(urls, startIndex: startIndex);
    state = _engine.state;
  }

  /// 设置元数据
  void setMetadata({String? bookTitle, String? bookAuthor}) {
    if (bookTitle != null) _engine.bookTitle = bookTitle;
    if (bookAuthor != null) _engine.bookAuthor = bookAuthor;
  }

  /// 设置当前章节标题
  void setCurrentChapterTitle(String title) {
    _engine.currentChapterTitle = title;
  }

  Future<void> play() => _engine.play();
  Future<void> pause() => _engine.pause();
  Future<void> stop() => _engine.stop();
  Future<void> togglePlayPause() => _engine.togglePlayPause();
  Future<void> previous() => _engine.previous();
  Future<void> next() => _engine.next();
  Future<void> seekTo(int index) => _engine.seekTo(index);

  Future<void> seekToPosition(Duration position) =>
      _engine.seekToPosition(position);

  void toggleLoopMode() => _engine.toggleLoopMode();
  void toggleShuffle() => _engine.toggleShuffle();
  Future<void> setVolume(double volume) => _engine.setVolume(volume);
  Future<void> setSpeed(double speed) => _engine.setSpeed(speed);

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerProvider, AudioPlayerState>((ref) {
  return AudioPlayerProvider();
});
