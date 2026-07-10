import 'chinese_convert_data.dart';

/// 简繁转换工具
///
/// 对标原：JsExtensions.t2s() / s2t()
/// 基于 OpenCC 级别映射表，覆盖 2000+ 常用汉字
class ChineseConvert {
  /// 繁体中文转简体中文
  static String t2s(String text) {
    final buffer = StringBuffer();
    for (final char in text.runes) {
      final c = String.fromCharCode(char);
      buffer.write(ChineseConvertData.t2s[c] ?? c);
    }
    return buffer.toString();
  }

  /// 简体中文转繁体中文
  static String s2t(String text) {
    final buffer = StringBuffer();
    for (final char in text.runes) {
      final c = String.fromCharCode(char);
      buffer.write(ChineseConvertData.s2t[c] ?? c);
    }
    return buffer.toString();
  }

  /// 中文数字转阿拉伯数字
  static String chineseNumToArabic(String text) {
    const map = {
      '零': '0',
      '一': '1',
      '二': '2',
      '三': '3',
      '四': '4',
      '五': '5',
      '六': '6',
      '七': '7',
      '八': '8',
      '九': '9',
      '十': '10',
      '百': '100',
      '千': '1000',
      '壹': '1',
      '贰': '2',
      '叁': '3',
      '肆': '4',
      '伍': '5',
      '陆': '6',
      '柒': '7',
      '捌': '8',
      '玖': '9',
      '拾': '10',
    };
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      buffer.write(map[text[i]] ?? text[i]);
    }
    return buffer.toString();
  }

  /// 判断文本是否包含繁体中文
  static bool isTraditional(String text) {
    var tradCount = 0;
    for (final char in text.runes) {
      final c = String.fromCharCode(char);
      if (ChineseConvertData.t2s.containsKey(c)) {
        tradCount++;
      }
    }
    return tradCount > 0;
  }

  /// 判断文本是否包含简体中文
  static bool isSimplified(String text) {
    var simpCount = 0;
    for (final char in text.runes) {
      final c = String.fromCharCode(char);
      if (ChineseConvertData.s2t.containsKey(c) &&
          c != ChineseConvertData.s2t[c]) {
        simpCount++;
      }
    }
    return simpCount > 0;
  }
}
