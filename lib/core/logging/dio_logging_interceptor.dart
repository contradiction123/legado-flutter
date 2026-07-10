import 'package:dio/dio.dart';

import 'app_logger.dart';
import 'log_tag.dart';

class DioLoggingInterceptor extends Interceptor {
  DioLoggingInterceptor(this._logger);

  static const _requestStartKey = '__log_request_start__';

  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_requestStartKey] = DateTime.now().microsecondsSinceEpoch;
    _logger.debug(
      LogTag.netDio,
      'Request Start',
      extra: {
        'Method': options.method,
        'Url': options.uri.toString(),
        'Headers': Map<String, dynamic>.from(options.headers),
        'Query': options.queryParameters,
        'Body': options.data,
      },
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final request = response.requestOptions;
    _logger.info(
      LogTag.netDio,
      'Request Success',
      extra: {
        'Method': request.method,
        'Url': request.uri.toString(),
        'StatusCode': response.statusCode,
        'DurationMs': _durationMs(request),
        'RequestHeaders': Map<String, dynamic>.from(request.headers),
        'RequestQuery': request.queryParameters,
        'RequestBody': request.data,
        'ResponseHeaders': Map<String, dynamic>.from(response.headers.map),
        'ResponseBody': response.data,
      },
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final request = err.requestOptions;
    _logger.error(
      LogTag.netDio,
      'Request Error',
      error: err.error ?? err,
      stackTrace: err.stackTrace,
      extra: {
        'Method': request.method,
        'Url': request.uri.toString(),
        'StatusCode': err.response?.statusCode,
        'DurationMs': _durationMs(request),
        'RequestHeaders': Map<String, dynamic>.from(request.headers),
        'RequestQuery': request.queryParameters,
        'RequestBody': request.data,
        'ResponseHeaders': err.response == null
            ? null
            : Map<String, dynamic>.from(err.response!.headers.map),
        'ResponseBody': err.response?.data,
        'DioMessage': err.message,
        'DioType': err.type.name,
      },
    );
    handler.next(err);
  }

  int? _durationMs(RequestOptions options) {
    final startMicros = options.extra[_requestStartKey];
    if (startMicros is! int) {
      return null;
    }
    return (DateTime.now().microsecondsSinceEpoch - startMicros) ~/ 1000;
  }
}
