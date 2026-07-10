import 'package:flutter/material.dart';

/// Material 3 主题生成
///
/// 对标原：AppTheme.kt + ThemeEngine.kt
class AppTheme {
  /// 生成浅色主题
  static ThemeData light({Color? seedColor}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor ?? Colors.blue,
      brightness: Brightness.light,
    );
    return _buildTheme(colorScheme);
  }

  /// 生成深色主题
  static ThemeData dark({Color? seedColor}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor ?? Colors.blue,
      brightness: Brightness.dark,
    );
    return _buildTheme(colorScheme);
  }

  /// 构建 Material 3 ThemeData
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        indicatorColor: colorScheme.secondaryContainer,
        backgroundColor: colorScheme.surface,
      ),
    );
  }
}
