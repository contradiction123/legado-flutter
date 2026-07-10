import 'package:flutter/material.dart';

/// 文本测量器
///
/// 对标原版：TextMeasure.kt
/// 使用 Flutter TextPainter 替代 Android Paint.measureText()
class TextMeasurer {
  TextPainter _painter;

  /// 中文字符通用宽度（用于快速估算，减少 TextPainter 调用）
  double _chineseCommonWidth;

  // ascii 字符宽度缓存
  final List<double> _asciiWidths = List.filled(128, -1.0);

  // 非 ascii 码点宽度缓存
  final Map<int, double> _codePointWidths = {};

  // 中文字符 Unicode 范围
  static const int _cjkStart = 0x4E00;
  static const int _cjkEnd = 0x9FA5;

  TextMeasurer({required TextStyle textStyle})
    : _painter = TextPainter(textDirection: TextDirection.ltr),
      _chineseCommonWidth = 0 {
    _painter.text = TextSpan(text: '一', style: textStyle);
    _painter.layout();
    _chineseCommonWidth = _painter.width;
  }

  /// 更新文本样式（字体变化时调用）
  void updateStyle(TextStyle textStyle) {
    _painter = TextPainter(textDirection: TextDirection.ltr);
    _painter.text = TextSpan(text: '一', style: textStyle);
    _painter.layout();
    _chineseCommonWidth = _painter.width;
    _codePointWidths.clear();
    _asciiWidths.fillRange(0, 128, -1.0);
  }

  /// 测量单一码位宽度
  double _measureCodePoint(int codePoint) {
    if (codePoint < 128) {
      if (_asciiWidths[codePoint] >= 0) return _asciiWidths[codePoint];
    } else if (codePoint >= _cjkStart && codePoint <= _cjkEnd) {
      return _chineseCommonWidth;
    } else {
      final cached = _codePointWidths[codePoint];
      if (cached != null) return cached;
    }

    // 未缓存，实际测量
    final char = String.fromCharCode(codePoint);
    _painter.text = TextSpan(text: char);
    _painter.layout();
    final width = _painter.width.ceilToDouble();

    if (codePoint < 128) {
      _asciiWidths[codePoint] = width;
    } else {
      _codePointWidths[codePoint] = width;
    }
    return width;
  }

  /// 批量测量码位宽度
  void _measureCodePoints(List<int> codePoints) {
    if (codePoints.isEmpty) return;
    final text = String.fromCharCodes(codePoints);
    _painter.text = TextSpan(text: text);
    _painter.layout();

    final boxes = _painter.getBoxesForSelection(
      TextSelection(baseOffset: 0, extentOffset: text.length),
    );

    for (var i = 0; i < codePoints.length && i < boxes.length; i++) {
      final width = boxes[i].toRect().width.ceilToDouble();
      final cp = codePoints[i];
      if (cp < 128) {
        _asciiWidths[cp] = width;
      } else {
        _codePointWidths[cp] = width;
      }
    }

    // 如果 boxes 不够，挨个测量剩余字符
    if (boxes.length < codePoints.length) {
      for (var i = boxes.length; i < codePoints.length; i++) {
        final cp = codePoints[i];
        final char = String.fromCharCode(cp);
        _painter.text = TextSpan(text: char);
        _painter.layout();
        final w = _painter.width.ceilToDouble();
        if (cp < 128) {
          _asciiWidths[cp] = w;
        } else {
          _codePointWidths[cp] = w;
        }
      }
    }
  }

  /// 将文本拆分为字符列表 + 宽度列表
  /// 对标原版 measureTextSplit()
  (List<String> chars, List<double> widths) measureTextSplit(String text) {
    final codePoints = text.runes.toList();
    final size = codePoints.length;
    final widths = List.filled(size, -1.0);
    final charList = <String>[];
    final unknownCodePoints = <int>[];

    for (var i = 0; i < size; i++) {
      final cp = codePoints[i];
      final w = _measureCodePoint(cp);
      if (w >= 0) {
        widths[i] = w;
      } else {
        unknownCodePoints.add(cp);
      }
      charList.add(String.fromCharCode(cp));
    }

    if (unknownCodePoints.isNotEmpty) {
      _measureCodePoints(unknownCodePoints);
      for (var i = 0; i < size; i++) {
        if (widths[i] < 0) {
          widths[i] = _measureCodePoint(codePoints[i]);
        }
      }
    }

    return (charList, widths);
  }

  /// 测量整段文本的宽度
  double measureText(String text) {
    var totalWidth = 0.0;
    final codePoints = text.runes.toList();
    final unknownCodePoints = <int>[];

    for (final cp in codePoints) {
      final w = _measureCodePoint(cp);
      if (w >= 0) {
        totalWidth += w;
      } else {
        unknownCodePoints.add(cp);
      }
    }

    if (unknownCodePoints.isNotEmpty) {
      _measureCodePoints(unknownCodePoints);
      for (final cp in codePoints) {
        final w = _measureCodePoint(cp);
        if (w < 0) continue;
        totalWidth += w;
      }
    }

    return totalWidth;
  }

  /// 获取指定样式的行高度
  static double getLineHeight(TextStyle style) {
    final painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: '测', style: style),
    )..layout();
    return painter.height;
  }

  /// 获取当前中文参考宽度
  double get chineseWidth => _chineseCommonWidth;

  /// 清空缓存（字体变化时调用）
  void invalidate() {
    _chineseCommonWidth = _painter.width;
    _codePointWidths.clear();
    _asciiWidths.fillRange(0, 128, -1.0);
  }
}
