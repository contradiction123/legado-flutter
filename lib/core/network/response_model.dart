import 'package:dio/dio.dart';

/// HTTP 响应封装
///
/// 对标原：StrResponse.kt（轻量级 HTTP 响应包装）
class StrResponse {
  final String url;
  final String? body;
  final int statusCode;
  final String? statusMessage;
  final Map<String, List<String>> headers;
  final int callTime;

  const StrResponse({
    required this.url,
    this.body,
    this.statusCode = 200,
    this.statusMessage,
    this.headers = const {},
    this.callTime = 0,
  });

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;

  @override
  String toString() =>
      'StrResponse(url: $url, statusCode: $statusCode, body: ${body?.length ?? 0} chars)';
}

/// 从 Dio Response 构建 StrResponse
StrResponse strResponseFromDio(Response<dynamic> response,
    {int callTime = 0}) {
  final body = response.data;
  return StrResponse(
    url: response.requestOptions.uri.toString(),
    body: body is String ? body : body?.toString(),
    statusCode: response.statusCode ?? 200,
    statusMessage: response.statusMessage,
    headers: response.headers.map,
    callTime: callTime,
  );
}

/// 从错误响应构建 StrResponse
StrResponse strResponseFromError(DioException error, {int callTime = 0}) {
  final response = error.response;
  return StrResponse(
    url: error.requestOptions.uri.toString(),
    body: response?.data?.toString(),
    statusCode: response?.statusCode ?? 0,
    statusMessage: error.message,
    callTime: callTime,
  );
}
