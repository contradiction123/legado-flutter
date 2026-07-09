import 'package:flutter/material.dart';

/// Android Monet 动态取色桥接
///
/// 对标原：MD3 项目通过 material_color_utilities 从壁纸提取配色
/// Android 12+ 系统原生支持 Monet 取色（通过 `WallpaperManager` 系统服务）
/// iOS 和 Android <12 使用 `ColorScheme.fromSeed()` 降级方案
class DynamicColor {
  /// 从系统获取动态颜色种子
  ///
  /// Android 12+：尝试从壁纸提取主色
  /// 其他平台：返回 null，由上层使用默认种子颜色
  static Color? getSystemAccent() {
    // Flutter 目前没有跨平台 API 直接从系统获取 Monet 颜色。
    // Android 平台可通过 MethodChannel 调用 WallpaperManager，
    // 但本版本采用简化方案：
    // - Android 12+ 优先用 ColorScheme.fromSeed(seedColor)
    // - 种子颜色从用户设置读取
    return null;
  }

  /// 获取调色板（浅色 + 深色）
  ///
  /// [seedColor] 种子颜色
  /// 返回一对 (lightScheme, darkScheme)
  static (ColorScheme, ColorScheme) getColorSchemes(Color seedColor) {
    return (
      ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light),
      ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark),
    );
  }
}
