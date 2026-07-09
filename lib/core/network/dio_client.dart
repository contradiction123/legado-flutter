import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

/// Dio HTTP 客户端单例
///
/// 对标原：OkHttpUtils.kt + HttpHelper.kt
/// 提供全局统一的 HTTP 请求配置
class DioClient {
  static DioClient? _instance;

  late final Dio _dio;
  late final CookieJar _cookieJar;

  DioClient._() {
    _cookieJar = CookieJar();
    _dio = _createDio();
  }

  /// 全局单例
  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  /// 获取 Dio 实例
  Dio get dio => _dio;

  /// 获取 CookieJar
  CookieJar get cookieJar => _cookieJar;

  /// 创建并配置 Dio 实例
  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 60),
        followRedirects: true,
        maxRedirects: 5,
        validateStatus: (status) => true, // 不抛出 HTTP 错误状态
        headers: {
          'User-Agent': _defaultUserAgent,
        },
      ),
    );

    // 添加拦截器
    dio.interceptors.addAll([
      // Cookie 管理器
      CookieManager(_cookieJar),
      // 异常处理拦截器
      _ErrorInterceptor(),
    ]);

    return dio;
  }

  /// 默认 User-Agent
  String get _defaultUserAgent =>
      'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

  /// 重置 Cookie（清除所有 Cookie）
  Future<void> clearCookies() async {
    await _cookieJar.deleteAll();
  }

  /// 为指定 URL 设置自定义 User-Agent
  void setCustomUserAgent(String userAgent) {
    _dio.options.headers['User-Agent'] = userAgent;
  }
}

/// 异常处理拦截器
///
/// 对标原：OkHttpExceptionInterceptor.kt
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 统一错误处理
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
