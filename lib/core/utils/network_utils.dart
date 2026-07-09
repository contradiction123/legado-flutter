import 'dart:io';

/// 网络状态判断工具
///
/// 对标原：NetworkUtils.kt
class NetworkUtils {
  /// 检查网络是否可用
  ///
  /// 尝试连接一个已知可靠的地址（Google DNS）
  /// 返回 true 表示有网络连接
  static Future<bool> isNetworkAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// 将相对 URL 解析为绝对 URL
  ///
  /// [baseUrl] 基础 URL
  /// [relativeUrl] 相对 URL
  /// 返回绝对 URL 字符串
  static String resolveUrl(String baseUrl, String relativeUrl) {
    try {
      final base = Uri.parse(baseUrl);
      final resolved = base.resolve(relativeUrl);
      return resolved.toString();
    } catch (_) {
      return relativeUrl;
    }
  }

  /// 从 URL 提取域名
  static String? extractHost(String url) {
    try {
      return Uri.parse(url).host;
    } catch (_) {
      return null;
    }
  }

  /// 判断 URL 是否为有效的 HTTP/HTTPS 链接
  static bool isValidHttpUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'http' || uri.scheme == 'https';
    } catch (_) {
      return false;
    }
  }
}
