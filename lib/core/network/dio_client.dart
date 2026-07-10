import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../logging/app_logger.dart';
import '../logging/dio_logging_interceptor.dart';

class DioClient {
  static DioClient? _instance;

  late final Dio _dio;
  late final CookieJar _cookieJar;

  DioClient._() {
    _cookieJar = CookieJar();
    _dio = _createDio();
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  Dio get dio => _dio;

  CookieJar get cookieJar => _cookieJar;

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 60),
        followRedirects: true,
        maxRedirects: 5,
        validateStatus: (status) => true,
        headers: {'User-Agent': _defaultUserAgent},
      ),
    );

    dio.interceptors.addAll([
      CookieManager(_cookieJar),
      DioLoggingInterceptor(AppLogger.instance),
      _ErrorInterceptor(),
    ]);

    return dio;
  }

  String get _defaultUserAgent =>
      'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

  Future<void> clearCookies() async {
    await _cookieJar.deleteAll();
  }

  void setCustomUserAgent(String userAgent) {
    _dio.options.headers['User-Agent'] = userAgent;
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
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
