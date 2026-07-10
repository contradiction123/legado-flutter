import 'package:dio/dio.dart';

import 'dio_client.dart';
import 'response_model.dart';

/// HTTP 请求便捷方法
///
/// 对标原：HttpHelper.kt
/// 提供与 Legado 原版一致的 HTTP 请求接口
class HttpHelper {
  final Dio _dio;
  final Stopwatch _stopwatch = Stopwatch();

  HttpHelper._(DioClient client) : _dio = client.dio;

  /// 创建 HttpHelper 实例
  static HttpHelper create() => HttpHelper._(DioClient.instance);

  /// GET 请求
  Future<StrResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    _stopwatch
      ..reset()
      ..start();
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      _stopwatch.stop();
      return strResponseFromDio(
        response,
        callTime: _stopwatch.elapsedMilliseconds,
      );
    } on DioException catch (e) {
      _stopwatch.stop();
      return strResponseFromError(e, callTime: _stopwatch.elapsedMilliseconds);
    }
  }

  /// POST 请求（Form 表单）
  Future<StrResponse> postForm(
    String url, {
    Map<String, dynamic>? formData,
    Map<String, dynamic>? headers,
  }) async {
    _stopwatch
      ..reset()
      ..start();
    try {
      final response = await _dio.post(
        url,
        data: formData != null ? FormData.fromMap(formData) : null,
        options: Options(headers: headers),
      );
      _stopwatch.stop();
      return strResponseFromDio(
        response,
        callTime: _stopwatch.elapsedMilliseconds,
      );
    } on DioException catch (e) {
      _stopwatch.stop();
      return strResponseFromError(e, callTime: _stopwatch.elapsedMilliseconds);
    }
  }

  /// POST 请求（JSON body）
  Future<StrResponse> postJson(
    String url, {
    dynamic jsonData,
    Map<String, dynamic>? headers,
  }) async {
    _stopwatch
      ..reset()
      ..start();
    try {
      final response = await _dio.post(
        url,
        data: jsonData,
        options: Options(
          headers: headers,
          contentType: Headers.jsonContentType,
        ),
      );
      _stopwatch.stop();
      return strResponseFromDio(
        response,
        callTime: _stopwatch.elapsedMilliseconds,
      );
    } on DioException catch (e) {
      _stopwatch.stop();
      return strResponseFromError(e, callTime: _stopwatch.elapsedMilliseconds);
    }
  }

  /// POST 请求（纯文本 body）
  Future<StrResponse> postBody(
    String url, {
    String? body,
    Map<String, dynamic>? headers,
    String? contentType,
  }) async {
    _stopwatch
      ..reset()
      ..start();
    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(headers: headers, contentType: contentType),
      );
      _stopwatch.stop();
      return strResponseFromDio(
        response,
        callTime: _stopwatch.elapsedMilliseconds,
      );
    } on DioException catch (e) {
      _stopwatch.stop();
      return strResponseFromError(e, callTime: _stopwatch.elapsedMilliseconds);
    }
  }

  /// 带重试的 GET 请求
  Future<StrResponse> getWithRetry(
    String url, {
    int retry = 3,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    for (var i = 0; i < retry; i++) {
      final result = await get(
        url,
        queryParameters: queryParameters,
        headers: headers,
      );
      if (result.isSuccessful) return result;
    }
    return get(url, queryParameters: queryParameters, headers: headers);
  }

  /// 释放资源
  void dispose() {
    _dio.close(force: true);
  }
}
