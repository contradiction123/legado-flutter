/// TTS 播放状态
enum TtsPlayState { stopped, playing, paused }

/// TTS 定时器模式
enum TtsTimerMode { none, countdown, chapterEnd }

/// TTS 配置
class TtsConfig {
  final double speed; // 0.0 ~ 2.0
  final double pitch; // 0.5 ~ 2.0
  final double volume; // 0.0 ~ 1.0
  final String? language;
  final bool useSystemTts;
  final bool readByPage;

  const TtsConfig({
    this.speed = 1.0,
    this.pitch = 1.0,
    this.volume = 1.0,
    this.language,
    this.useSystemTts = true,
    this.readByPage = false,
  });

  TtsConfig copyWith({
    double? speed,
    double? pitch,
    double? volume,
    String? language,
    bool? useSystemTts,
    bool? readByPage,
  }) {
    return TtsConfig(
      speed: speed ?? this.speed,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
      language: language ?? this.language,
      useSystemTts: useSystemTts ?? this.useSystemTts,
      readByPage: readByPage ?? this.readByPage,
    );
  }
}

/// TTS 状态
class TtsState {
  final TtsPlayState playState;
  final String? currentText;
  final double progress; // 0.0 ~ 1.0
  final int elapsedSeconds;
  final int timerMinutes;
  final TtsTimerMode timerMode;
  final String? error;

  const TtsState({
    this.playState = TtsPlayState.stopped,
    this.currentText,
    this.progress = 0,
    this.elapsedSeconds = 0,
    this.timerMinutes = 0,
    this.timerMode = TtsTimerMode.none,
    this.error,
  });

  TtsState copyWith({
    TtsPlayState? playState,
    String? currentText,
    double? progress,
    int? elapsedSeconds,
    int? timerMinutes,
    TtsTimerMode? timerMode,
    String? error,
  }) {
    return TtsState(
      playState: playState ?? this.playState,
      currentText: currentText ?? this.currentText,
      progress: progress ?? this.progress,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      timerMinutes: timerMinutes ?? this.timerMinutes,
      timerMode: timerMode ?? this.timerMode,
      error: error,
    );
  }
}
