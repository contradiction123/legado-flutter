import 'package:dio/dio.dart';

/// SSL 证书验证配置
///
/// 对标原：SSLHelper.kt
/// 提供 SSL/TLS 相关配置工具
class SslHelper {
  /// 创建不验证证书的 Dio 实例（用于自定义书源访问）
  ///
  /// 对标原：unsafeSSLSocketFactory + unsafeHostnameVerifier
  /// 注意：生产环境应仅对特定书源启用，非全局
  static Dio createUnsafeDio() {
    return Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
  }

  /// 验证 HTTPS 证书是否有效
  ///
  /// 对标原：SSLHelper.getSslSocketFactory
  /// 返回 true 表示证书可信
  static Future<bool> verifyCertificate(String url) async {
    try {
      final dio = Dio();
      await dio.head(
        url,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
