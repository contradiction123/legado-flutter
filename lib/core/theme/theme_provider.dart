import 'package:flutter/material.dart';

/// 主题模式
enum ThemeModeType {
  light,
  dark,
  system,
}

/// 主题状态
class ThemeState {
  final ThemeModeType mode;
  final Color? seedColor;

  const ThemeState({
    this.mode = ThemeModeType.system,
    this.seedColor,
  });

  ThemeState copyWith({
    ThemeModeType? mode,
    Color? seedColor,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  /// 转换为 Flutter ThemeMode
  ThemeMode get flutterMode {
    switch (mode) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
      case ThemeModeType.system:
        return ThemeMode.system;
    }
  }
}

/// 主题状态管理（非 Riverpod 版本，供 get_it 使用）
class ThemeManager extends ValueNotifier<ThemeState> {
  ThemeManager() : super(const ThemeState());

  void setMode(ThemeModeType mode) {
    value = value.copyWith(mode: mode);
  }

  void setSeedColor(Color color) {
    value = value.copyWith(seedColor: color);
  }

  void toggleMode() {
    switch (value.mode) {
      case ThemeModeType.light:
        setMode(ThemeModeType.dark);
      case ThemeModeType.dark:
        setMode(ThemeModeType.system);
      case ThemeModeType.system:
        setMode(ThemeModeType.light);
    }
  }
}
