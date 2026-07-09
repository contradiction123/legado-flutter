import 'package:flutter_riverpod/legacy.dart';

import '../engine/read_aloud.dart';
import '../models/tts_models.dart';

/// TTS 状态提供者
///
/// 封装 ReadAloudEngine，对外暴露 TtsState 和控制方法
class TtsProvider extends StateNotifier<TtsState> {
  final ReadAloudEngine _engine;

  TtsProvider() : _engine = ReadAloudEngine(), super(const TtsState()) {
    _engine.onStateChanged = (newState) {
      state = newState;
    };
  }

  /// 设置段落队列回调（外部注入当前阅读器内容）
  void setParagraphQueue(List<String> paragraphs, {int startIndex = 0}) {
    _engine.start(paragraphs, startIndex: startIndex);
  }

  /// 设置请求下一章的回调
  void setNextChapterCallback(Future<List<String>> Function() callback) {
    _engine.onRequestNextChapter = callback;
  }

  /// 设置请求上一章的回调
  void setPrevChapterCallback(Future<List<String>> Function() callback) {
    _engine.onRequestPrevChapter = callback;
  }

  /// 开始朗读
  Future<void> play() async {
    await _engine.resume();
  }

  /// 暂停
  Future<void> pause() async {
    await _engine.pause();
  }

  /// 停止
  Future<void> stop() async {
    await _engine.stop();
  }

  /// 切换播放/暂停
  Future<void> togglePlayPause() async {
    if (state.playState == TtsPlayState.playing) {
      await _engine.pause();
    } else {
      await _engine.resume();
    }
  }

  /// 下一句
  Future<void> nextParagraph() async {
    await _engine.nextParagraph();
  }

  /// 上一句
  Future<void> prevParagraph() async {
    await _engine.prevParagraph();
  }

  /// 设置语速
  Future<void> setSpeed(double speed) async {
    await _engine.setSpeed(speed);
  }

  /// 设置音调
  Future<void> setPitch(double pitch) async {
    await _engine.setPitch(pitch);
  }

  /// 设置定时（分钟）
  void setTimer(int minutes) {
    _engine.setTimer(minutes);
  }

  /// 添加定时
  void addTimer() {
    _engine.addTimer();
  }

  /// 获取引擎（供外部高级控制）
  ReadAloudEngine get engine => _engine;

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }
}

final ttsProvider = StateNotifierProvider<TtsProvider, TtsState>((ref) {
  return TtsProvider();
});
