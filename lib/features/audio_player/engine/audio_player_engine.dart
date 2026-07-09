import 'package:just_audio/just_audio.dart' as just;

/// 有声书播放引擎
///
/// 对标原版：AudioPlayService.kt（ExoPlayer 封装）
class AudioPlayerEngine {
  final just.AudioPlayer _player = just.AudioPlayer();
  List<just.AudioSource> _playlist = [];
  int _currentIndex = 0;
  just.LoopMode _loopMode = just.LoopMode.off;
  bool _shuffleEnabled = false;

  void Function()? onStateChanged;
  String currentChapterTitle = '';
  String bookTitle = '';
  String bookAuthor = '';

  AudioPlayerEngine() {
    _player.playerStateStream.listen((_) => onStateChanged?.call());
    _player.positionStream.listen((_) => onStateChanged?.call());
    _player.currentIndexStream.listen((index) {
      if (index != null) _currentIndex = index;
      onStateChanged?.call();
    });
    _player.processingStateStream.listen((state) {
      if (state == just.ProcessingState.completed) {
        onStateChanged?.call();
      }
    });
  }

  void setPlaylist(List<String> urls, {int startIndex = 0}) {
    _playlist = urls.map((url) {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        return just.AudioSource.uri(Uri.parse(url));
      } else {
        return just.AudioSource.file(url);
      }
    }).toList();
    _currentIndex = startIndex.clamp(0, _playlist.length - 1);
    _player.setAudioSource(
      just.ConcatenatingAudioSource(children: _playlist),
      initialIndex: _currentIndex,
    );
  }

  Future<void> play() async {
    if (_player.processingState == just.ProcessingState.idle && _playlist.isNotEmpty) {
      await _player.seek(Duration.zero, index: _currentIndex);
    }
    await _player.play();
  }

  Future<void> pause() async => await _player.pause();
  Future<void> stop() async => await _player.stop();

  Future<void> togglePlayPause() async {
    if (_player.playing) { await pause(); } else { await play(); }
  }

  Future<void> seekTo(int index) async {
    if (index < 0 || index >= _playlist.length) return;
    _currentIndex = index;
    await _player.seek(Duration.zero, index: index);
  }

  Future<void> previous() async {
    if (_currentIndex > 0) await seekTo(_currentIndex - 1);
  }

  Future<void> next() async {
    if (_currentIndex < _playlist.length - 1) await seekTo(_currentIndex + 1);
  }

  Future<void> seekToPosition(Duration position) async => await _player.seek(position);

  void toggleLoopMode() {
    switch (_loopMode) {
      case just.LoopMode.off: _loopMode = just.LoopMode.one; break;
      case just.LoopMode.one: _loopMode = just.LoopMode.all; break;
      case just.LoopMode.all: _loopMode = just.LoopMode.off; break;
    }
    _player.setLoopMode(_loopMode);
  }

  void toggleShuffle() {
    _shuffleEnabled = !_shuffleEnabled;
    _player.setShuffleModeEnabled(_shuffleEnabled);
  }

  Future<void> setVolume(double volume) async =>
      await _player.setVolume(volume.clamp(0.0, 1.0));

  Future<void> setSpeed(double speed) async =>
      await _player.setSpeed(speed.clamp(0.5, 3.0));

  AudioPlayerState get state => AudioPlayerState(
        isPlaying: _player.playing,
        isPaused: _player.processingState == just.ProcessingState.ready && !_player.playing,
        currentIndex: _currentIndex,
        totalTracks: _playlist.length,
        position: _player.position,
        duration: _player.duration ?? Duration.zero,
        loopMode: _convertLoopMode(_loopMode),
        isShuffleEnabled: _shuffleEnabled,
        currentChapterTitle: currentChapterTitle,
        bookTitle: bookTitle,
        bookAuthor: bookAuthor,
      );

  static PlayRepeatMode _convertLoopMode(just.LoopMode mode) {
    switch (mode) {
      case just.LoopMode.off: return PlayRepeatMode.off;
      case just.LoopMode.one: return PlayRepeatMode.one;
      case just.LoopMode.all: return PlayRepeatMode.all;
    }
  }

  Future<void> dispose() async => await _player.dispose();
}

/// 音频播放器状态
class AudioPlayerState {
  final bool isPlaying;
  final bool isPaused;
  final int currentIndex;
  final int totalTracks;
  final Duration position;
  final Duration duration;
  final PlayRepeatMode loopMode;
  final bool isShuffleEnabled;
  final String currentChapterTitle;
  final String bookTitle;
  final String bookAuthor;

  const AudioPlayerState({
    this.isPlaying = false,
    this.isPaused = false,
    this.currentIndex = 0,
    this.totalTracks = 0,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.loopMode = PlayRepeatMode.off,
    this.isShuffleEnabled = false,
    this.currentChapterTitle = '',
    this.bookTitle = '',
    this.bookAuthor = '',
  });

  double get progressPercent =>
      duration.inMilliseconds > 0
          ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
          : 0.0;

  String get progressText => '${_fmt(position)} / ${_fmt(duration)}';

  String get loopModeLabel {
    switch (loopMode) {
      case PlayRepeatMode.off: return '顺序';
      case PlayRepeatMode.one: return '单曲';
      case PlayRepeatMode.all: return '循环';
    }
  }

  static String _fmt(Duration d) {
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '${d.inHours}:$m:$s';
  }
}

/// 循环模式
enum PlayRepeatMode { off, one, all }
