import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

import '../models/tts_models.dart';

/// TTS 朗读引擎
///
/// 对标原版：BaseReadAloudService.kt + TTSReadAloudService.kt
///
/// 功能：
/// - 段落队列逐句朗读
/// - 播放/暂停/停止/跳转
/// - 语速/音调调节
/// - 定时关闭
/// - 跨章节自动继续
class ReadAloudEngine {
  final FlutterTts _tts = FlutterTts();
  List<String> _paragraphQueue = [];
  int _currentParagraphIndex = 0;
  TtsPlayState _state = TtsPlayState.stopped;
  TtsConfig _config = const TtsConfig();
  Timer? _progressTimer;
  Timer? _countdownTimer;
  int _elapsedSeconds = 0;
  int _timerMinutes = 0;
  TtsTimerMode _timerMode = TtsTimerMode.none;

  /// 状态回调
  void Function(TtsState state)? onStateChanged;

  /// 请求下一章回调（返回下一章文本列表）
  Future<List<String>> Function()? onRequestNextChapter;

  /// 请求上一章回调
  Future<List<String>> Function()? onRequestPrevChapter;

  ReadAloudEngine() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('zh-CN');
    await _tts.setSpeechRate(_config.speed);
    await _tts.setPitch(_config.pitch);
    await _tts.setVolume(_config.volume);

    _tts.setProgressHandler((String text, int start, int end, String word) {
      _elapsedSeconds = (start / 1000).round();
      _emitState();
    });

    _tts.setCompletionHandler(() {
      _onParagraphComplete();
    });

    _tts.setErrorHandler((msg) {
      _emitState(error: 'TTS 错误: $msg');
    });
  }

  /// 开始朗读指定段落列表
  Future<void> start(List<String> paragraphs, {int startIndex = 0}) async {
    _paragraphQueue = paragraphs;
    _currentParagraphIndex = startIndex.clamp(0, paragraphs.length - 1);
    _state = TtsPlayState.playing;
    _elapsedSeconds = 0;

    if (_timerMode == TtsTimerMode.none) {
      _startProgressTimer();
    }

    await _speakCurrent();
    _emitState();
  }

  /// 暂停
  Future<void> pause() async {
    if (_state != TtsPlayState.playing) return;
    _state = TtsPlayState.paused;
    await _tts.stop();
    _progressTimer?.cancel();
    _emitState();
  }

  /// 继续
  Future<void> resume() async {
    if (_state != TtsPlayState.paused) return;
    _state = TtsPlayState.playing;
    _startProgressTimer();
    await _speakCurrent();
    _emitState();
  }

  /// 停止
  Future<void> stop() async {
    _state = TtsPlayState.stopped;
    await _tts.stop();
    _progressTimer?.cancel();
    _countdownTimer?.cancel();
    _paragraphQueue = [];
    _currentParagraphIndex = 0;
    _elapsedSeconds = 0;
    _emitState();
  }

  /// 跳转到指定段落
  Future<void> seekTo(int paragraphIndex) async {
    if (paragraphIndex < 0 || paragraphIndex >= _paragraphQueue.length) return;
    _currentParagraphIndex = paragraphIndex;
    if (_state == TtsPlayState.playing) {
      await _tts.stop();
      await _speakCurrent();
    }
    _emitState();
  }

  /// 下一句
  Future<void> nextParagraph() async {
    if (_currentParagraphIndex < _paragraphQueue.length - 1) {
      _currentParagraphIndex++;
      if (_state == TtsPlayState.playing) {
        await _tts.stop();
        await _speakCurrent();
      }
    } else if (onRequestNextChapter != null) {
      final nextParagraphs = await onRequestNextChapter!();
      if (nextParagraphs.isNotEmpty) {
        _paragraphQueue = nextParagraphs;
        _currentParagraphIndex = 0;
        if (_state == TtsPlayState.playing) {
          await _tts.stop();
          await _speakCurrent();
        }
      }
    }
    _emitState();
  }

  /// 上一句
  Future<void> prevParagraph() async {
    if (_currentParagraphIndex > 0) {
      _currentParagraphIndex--;
      if (_state == TtsPlayState.playing) {
        await _tts.stop();
        await _speakCurrent();
      }
    } else if (onRequestPrevChapter != null) {
      final prevParagraphs = await onRequestPrevChapter!();
      if (prevParagraphs.isNotEmpty) {
        _paragraphQueue = prevParagraphs;
        _currentParagraphIndex = _paragraphQueue.length - 1;
        if (_state == TtsPlayState.playing) {
          await _tts.stop();
          await _speakCurrent();
        }
      }
    }
    _emitState();
  }

  /// 设置语速
  Future<void> setSpeed(double speed) async {
    _config = _config.copyWith(speed: speed.clamp(0.0, 2.0));
    await _tts.setSpeechRate(_config.speed);
  }

  /// 设置音调
  Future<void> setPitch(double pitch) async {
    _config = _config.copyWith(pitch: pitch.clamp(0.5, 2.0));
    await _tts.setPitch(_config.pitch);
  }

  /// 设置定时器（分钟）
  void setTimer(int minutes) {
    _timerMinutes = minutes;
    _timerMode = minutes > 0 ? TtsTimerMode.countdown : TtsTimerMode.none;
    _countdownTimer?.cancel();
    if (_timerMode == TtsTimerMode.countdown) {
      _countdownTimer = Timer.periodic(const Duration(minutes: 1), (_) {
        _timerMinutes--;
        if (_timerMinutes <= 0) {
          _timerMinutes = 0;
          stop();
        }
        _emitState();
      });
    }
    _emitState();
  }

  /// 添加定时器（+10分钟）
  void addTimer() {
    setTimer(_timerMinutes + 10);
  }

  /// 获取配置
  TtsConfig get config => _config;

  /// 获取当前状态快照
  TtsState get state => TtsState(
        playState: _state,
        currentText: _paragraphQueue.isNotEmpty &&
                _currentParagraphIndex < _paragraphQueue.length
            ? _paragraphQueue[_currentParagraphIndex]
            : null,
        progress: _paragraphQueue.isNotEmpty
            ? _currentParagraphIndex / _paragraphQueue.length
            : 0,
        elapsedSeconds: _elapsedSeconds,
        timerMinutes: _timerMinutes,
        timerMode: _timerMode,
      );

  /// 朗读当前段落
  Future<void> _speakCurrent() async {
    if (_paragraphQueue.isEmpty) {
      await stop();
      return;
    }
    if (_currentParagraphIndex >= _paragraphQueue.length) {
      _onParagraphComplete();
      return;
    }
    final text = _paragraphQueue[_currentParagraphIndex];
    await _tts.speak(text);
  }

  /// 段落朗读完成回调
  void _onParagraphComplete() {
    if (_state != TtsPlayState.playing) return;
    _currentParagraphIndex++;

    if (_currentParagraphIndex >= _paragraphQueue.length) {
      // 当前段落列表读完，请求下一章
      if (onRequestNextChapter != null) {
        onRequestNextChapter!().then((nextParagraphs) {
          if (nextParagraphs.isNotEmpty) {
            _paragraphQueue = nextParagraphs;
            _currentParagraphIndex = 0;
            _speakCurrent();
            _emitState();
          } else {
            stop();
          }
        });
      } else {
        stop();
      }
    } else {
      _speakCurrent();
      _emitState();
    }
  }

  /// 进度计时器
  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
      _emitState();
    });
  }

  /// 发出状态通知
  void _emitState({String? error}) {
    onStateChanged?.call(TtsState(
      playState: _state,
      currentText: _paragraphQueue.isNotEmpty &&
              _currentParagraphIndex < _paragraphQueue.length
          ? _paragraphQueue[_currentParagraphIndex]
          : null,
      progress: _paragraphQueue.isNotEmpty
          ? _currentParagraphIndex / _paragraphQueue.length
          : 0,
      elapsedSeconds: _elapsedSeconds,
      timerMinutes: _timerMinutes,
      timerMode: _timerMode,
      error: error,
    ));
  }

  /// 释放资源
  Future<void> dispose() async {
    await stop();
    await _tts.stop();
  }
}
