/// 字符串工具函数
///
/// 对标原：StringExtensions.kt
class StringUtils {
  /// 截断字符串到指定长度
  static String? truncate(String? value, int maxLength) {
    if (value == null) return null;
    if (value.length <= maxLength) return value;
    return value.substring(0, maxLength);
  }

  /// 判断字符串是否为空或空白
  static bool isBlank(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// 安全的字符串转换
  static String safeString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  /// HTML 解码
  static String htmlDecode(String input) {
    return input
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');
  }
}
