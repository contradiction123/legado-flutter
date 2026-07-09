import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 翻页模式
enum PageAnimationMode {
  slide('滑动'),
  scroll('滚动'),
  cover('覆盖'),
  simulation('仿真'),
  none('无动画'),
  fade('淡入淡出');

  final String label;
  const PageAnimationMode(this.label);
}

/// 阅读主题（预设背景色）
class ReaderTheme {
  final String name;
  final Color bgColor;
  final Color textColor;

  const ReaderTheme({
    required this.name,
    required this.bgColor,
    required this.textColor,
  });

  /// 模拟原版 Legado 的几种经典主题
  static const white = ReaderTheme(
    name: '羊皮纸',
    bgColor: Color(0xFFF5F0E6),
    textColor: Color(0xFF3A3A3A),
  );

  static const green = ReaderTheme(
    name: '护眼绿',
    bgColor: Color(0xFFC7EDCC),
    textColor: Color(0xFF3A3A3A),
  );

  static const dark = ReaderTheme(
    name: '深色',
    bgColor: Color(0xFF1E1E1E),
    textColor: Color(0xFFE0E0E0),
  );

  static const black = ReaderTheme(
    name: '纯黑',
    bgColor: Color(0xFF000000),
    textColor: Color(0xFF808080),
  );

  static const blue = ReaderTheme(
    name: '淡蓝',
    bgColor: Color(0xFFDAECF0),
    textColor: Color(0xFF3A3A3A),
  );

  static const all = [white, green, dark, black, blue];
}

/// 阅读配置状态
class ReaderConfigState {
  final double fontSize;
  final double lineHeight;
  final EdgeInsets margin;
  final ReaderTheme theme;
  final PageAnimationMode pageAnimation;
  final double brightness; // 0.0 ~ 1.0
  final bool followSystemBrightness;

  const ReaderConfigState({
    this.fontSize = 18.0,
    this.lineHeight = 1.8,
    this.margin = const EdgeInsets.fromLTRB(20, 18, 20, 18),
    this.theme = ReaderTheme.white,
    this.pageAnimation = PageAnimationMode.slide,
    this.brightness = 1.0,
    this.followSystemBrightness = true,
  });

  ReaderConfigState copyWith({
    double? fontSize,
    double? lineHeight,
    EdgeInsets? margin,
    ReaderTheme? theme,
    PageAnimationMode? pageAnimation,
    double? brightness,
    bool? followSystemBrightness,
  }) {
    return ReaderConfigState(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      margin: margin ?? this.margin,
      theme: theme ?? this.theme,
      pageAnimation: pageAnimation ?? this.pageAnimation,
      brightness: brightness ?? this.brightness,
      followSystemBrightness: followSystemBrightness ?? this.followSystemBrightness,
    );
  }

  factory ReaderConfigState.initial() => const ReaderConfigState();
}

/// 阅读配置管理
///
/// 使用 shared_preferences 持久化所有配置项
class ReaderConfigProvider extends StateNotifier<ReaderConfigState> {
  ReaderConfigProvider() : super(ReaderConfigState.initial()) {
    load();
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  static const _kFontSize = 'reader_font_size';
  static const _kLineHeight = 'reader_line_height';
  static const _kMarginLeft = 'reader_margin_left';
  static const _kMarginRight = 'reader_margin_right';
  static const _kMarginTop = 'reader_margin_top';
  static const _kMarginBottom = 'reader_margin_bottom';
  static const _kThemeIndex = 'reader_theme_index';
  static const _kPageAnim = 'reader_page_anim';
  static const _kBrightness = 'reader_brightness';
  static const _kFollowSysBrightness = 'reader_follow_sys_brightness';

  /// 从 SharedPreferences 加载配置
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_disposed) return;

      final fontSize = prefs.getDouble(_kFontSize) ?? 18.0;
      final lineHeight = prefs.getDouble(_kLineHeight) ?? 1.8;
      final marginLeft = prefs.getDouble(_kMarginLeft) ?? 20.0;
      final marginRight = prefs.getDouble(_kMarginRight) ?? 20.0;
      final marginTop = prefs.getDouble(_kMarginTop) ?? 18.0;
      final marginBottom = prefs.getDouble(_kMarginBottom) ?? 18.0;
      final themeIndex = prefs.getInt(_kThemeIndex) ?? 0;
      final pageAnimIndex = prefs.getInt(_kPageAnim) ?? 0;
      final brightness = prefs.getDouble(_kBrightness) ?? 1.0;
      final followSystemBrightness = prefs.getBool(_kFollowSysBrightness) ?? true;

      if (!_disposed) {
        state = ReaderConfigState(
          fontSize: fontSize,
          lineHeight: lineHeight,
          margin: EdgeInsets.fromLTRB(marginLeft, marginTop, marginRight, marginBottom),
          theme: ReaderTheme.all[themeIndex.clamp(0, ReaderTheme.all.length - 1)],
          pageAnimation: PageAnimationMode.values[pageAnimIndex.clamp(0, PageAnimationMode.values.length - 1)],
          brightness: brightness,
          followSystemBrightness: followSystemBrightness,
        );
      }
    } catch (_) {
      // 使用默认值
    }
  }

  /// 保存所有配置到 SharedPreferences
  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_kFontSize, state.fontSize);
      await prefs.setDouble(_kLineHeight, state.lineHeight);
      await prefs.setDouble(_kMarginLeft, state.margin.left);
      await prefs.setDouble(_kMarginRight, state.margin.right);
      await prefs.setDouble(_kMarginTop, state.margin.top);
      await prefs.setDouble(_kMarginBottom, state.margin.bottom);
      await prefs.setInt(_kThemeIndex, ReaderTheme.all.indexOf(state.theme));
      await prefs.setInt(_kPageAnim, PageAnimationMode.values.indexOf(state.pageAnimation));
      await prefs.setDouble(_kBrightness, state.brightness);
      await prefs.setBool(_kFollowSysBrightness, state.followSystemBrightness);
    } catch (_) {
      // 保存失败忽略
    }
  }

  void setFontSize(double size) {
    state = state.copyWith(fontSize: size.clamp(12.0, 40.0));
    _save();
  }

  void setLineHeight(double height) {
    state = state.copyWith(lineHeight: height.clamp(1.0, 3.0));
    _save();
  }

  void setMarginLeft(double value) {
    state = state.copyWith(
      margin: EdgeInsets.fromLTRB(value, state.margin.top, state.margin.right, state.margin.bottom),
    );
    _save();
  }

  void setMarginRight(double value) {
    state = state.copyWith(
      margin: EdgeInsets.fromLTRB(state.margin.left, state.margin.top, value, state.margin.bottom),
    );
    _save();
  }

  void setMarginTop(double value) {
    state = state.copyWith(
      margin: EdgeInsets.fromLTRB(state.margin.left, value, state.margin.right, state.margin.bottom),
    );
    _save();
  }

  void setMarginBottom(double value) {
    state = state.copyWith(
      margin: EdgeInsets.fromLTRB(state.margin.left, state.margin.top, state.margin.right, value),
    );
    _save();
  }

  void setTheme(ReaderTheme theme) {
    if (ReaderTheme.all.contains(theme)) {
      state = state.copyWith(theme: theme);
      _save();
    }
  }

  void setPageAnimation(PageAnimationMode mode) {
    state = state.copyWith(pageAnimation: mode);
    _save();
  }

  void setBrightness(double value) {
    state = state.copyWith(brightness: value.clamp(0.0, 1.0));
    _save();
  }

  void setFollowSystemBrightness(bool value) {
    state = state.copyWith(followSystemBrightness: value);
    _save();
  }
}

/// 全局阅读配置提供者
final readerConfigProvider =
    StateNotifierProvider<ReaderConfigProvider, ReaderConfigState>((ref) {
  return ReaderConfigProvider();
});
