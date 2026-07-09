import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// WebView 响应结果
class WebViewResponse {
  final String url;
  final String? body;
  final int? statusCode;

  const WebViewResponse({
    required this.url,
    this.body,
    this.statusCode,
  });
}

/// WebView 配置参数
class WebViewConfig {
  final String? url;
  final String? html;
  final String? encode;
  final String? tag;
  final Map<String, String>? headerMap;
  final String? sourceRegex;
  final String? overrideUrlRegex;
  final String? javaScript;
  final int delayTimeMs;

  const WebViewConfig({
    this.url,
    this.html,
    this.encode,
    this.tag,
    this.headerMap,
    this.sourceRegex,
    this.overrideUrlRegex,
    this.javaScript,
    this.delayTimeMs = 0,
  });
}

/// 后台无头 WebView 管理器
///
/// 对标原：BackstageWebView.kt
/// 使用 flutter_inappwebview 的 HeadlessInAppWebView 实现双平台兼容
///
/// 功能：
/// 1. 加载 URL 或 HTML 内容，等待页面渲染
/// 2. 执行 JS 获取渲染后 HTML（默认：document.documentElement.outerHTML）
/// 3. 资源嗅探：匹配 sourceRegex 后立即返回资源 URL
/// 4. URL 拦截：匹配 overrideUrlRegex 后立即返回跳转 URL
/// 5. 最多 30 次 JS 重试 + 60 秒全局超时
class HeadlessWebViewManager {
  late Completer<WebViewResponse> _completer;
  Timer? _delayTimer;
  Timer? _retryTimer;
  int _retryCount = 0;
  bool _isDone = false;
  late String _currentUrl;

  static const int _maxRetries = 30;
  static const int _retryIntervalMs = 1000;
  static const int _globalTimeoutMs = 60000;
  static const String _defaultJs = 'document.documentElement.outerHTML';

  /// 获取渲染后的页面内容
  Future<WebViewResponse> getPageContent(WebViewConfig config) async {
    _completer = Completer<WebViewResponse>();
    _retryCount = 0;
    _isDone = false;
    _currentUrl = config.url ?? '';

    final js = config.javaScript ?? _defaultJs;
    final isSniffMode =
        config.sourceRegex != null || config.overrideUrlRegex != null;

    // 全局超时
    Timer(const Duration(milliseconds: _globalTimeoutMs), () {
      if (!_isDone) _finish(null, statusCode: 408);
    });

    try {
      // ignore: unused_local_variable
      final _ = HeadlessInAppWebView(
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          domStorageEnabled: true,
          mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          blockNetworkImage: true,
        ),
        initialData: config.html != null
            ? InAppWebViewInitialData(
                data: config.html!,
                mimeType: 'text/html',
                encoding: config.encode ?? 'utf-8',
                baseUrl: WebUri(config.url ?? ''),
              )
            : null,
        initialUrlRequest: config.html == null && config.url != null
            ? URLRequest(
                url: WebUri(config.url!),
                headers: config.headerMap,
              )
            : null,
        onLoadStop: (controller, url) async {
          if (_isDone) return;
          _currentUrl = url.toString();

          if (isSniffMode) {
            if (js.isNotEmpty) {
              _delayTimer = Timer(
                Duration(milliseconds: 1000 + config.delayTimeMs),
                () async {
                  try {
                    await controller.evaluateJavascript(source: js);
                  } catch (_) {}
                },
              );
            }
          } else {
            _scheduleJsEval(controller, _currentUrl, js);
          }
        },
        onReceivedError: (controller, request, error) {
          if (!_isDone) {
            _finish(null, statusCode: _errorTypeToCode(error.type),
                error: error.description);
          }
        },
        shouldOverrideUrlLoading: (controller, navigation) async {
          if (!isSniffMode || _isDone) {
            return NavigationActionPolicy.ALLOW;
          }
          final requestUrl = navigation.request.url.toString();
          if (config.overrideUrlRegex != null) {
            try {
              if (RegExp(config.overrideUrlRegex!).hasMatch(requestUrl)) {
                _finish(requestUrl);
                return NavigationActionPolicy.CANCEL;
              }
            } catch (_) {}
          }
          return NavigationActionPolicy.ALLOW;
        },
        onLoadResource: (controller, resource) {
          if (!isSniffMode || _isDone) return;
          if (config.sourceRegex != null) {
            try {
              if (RegExp(config.sourceRegex!).hasMatch(resource.url.toString())) {
                _finish(resource.url.toString());
              }
            } catch (_) {}
          }
        },
      );
    } catch (e) {
      if (!_isDone) _finish(null, error: e.toString());
    }

    return _completer.future;
  }

  void _scheduleJsEval(
      InAppWebViewController controller, String url, String js) {
    _delayTimer = Timer(
      Duration(milliseconds: 1000 + _retryIntervalMs),
      () => _executeJs(controller, url, js),
    );
  }

  Future<void> _executeJs(
      InAppWebViewController controller, String url, String js) async {
    if (_isDone) return;
    try {
      final result = await controller.evaluateJavascript(source: js);
      final body = result?.toString();
      if (body != null && body.isNotEmpty && body != 'null') {
        _finish(_unescapeJsString(body));
        return;
      }
    } catch (_) {}

    if (!_isDone) {
      _retryCount++;
      if (_retryCount >= _maxRetries) {
        _finish(null, statusCode: 408, error: 'JS 执行超时（30次重试）');
        return;
      }
      _retryTimer = Timer(
        Duration(milliseconds: _retryIntervalMs),
        () => _executeJs(controller, url, js),
      );
    }
  }

  void _finish(String? body, {int? statusCode, String? error}) {
    if (_isDone) return;
    _isDone = true;
    _delayTimer?.cancel();
    _retryTimer?.cancel();
    _completer.complete(WebViewResponse(
      url: _currentUrl,
      body: body,
      statusCode: statusCode,
    ));
  }

  String _unescapeJsString(String input) {
    var result = input.trim();
    if (result.startsWith('"') && result.endsWith('"')) {
      result = result.substring(1, result.length - 1);
    }
    return result
        .replaceAll('\\"', '"')
        .replaceAll("\\'", "'")
        .replaceAll('\\\\', '\\')
        .replaceAll('\\n', '\n')
        .replaceAll('\\r', '\r')
        .replaceAll('\\t', '\t');
  }

  int _errorTypeToCode(WebResourceErrorType type) {
    final typeStr = type.toString();
    if (typeStr.contains('TIMEOUT')) {
      return 408;
    }
    if (typeStr.contains('CANNOT_CONNECT') ||
        typeStr.contains('HOST_LOOKUP') ||
        typeStr.contains('UNREACHABLE')) {
      return 502;
    }
    if (typeStr.contains('FILE_NOT_FOUND')) {
      return 404;
    }
    if (typeStr.contains('UNSUPPORTED_SCHEME')) {
      return 501;
    }
    return 500;
  }
}

/// 便捷函数：获取页面内容（对应 java.webView）
Future<String?> webViewGetContent({
  String? html,
  String? url,
  String? js,
  String? tag,
  Map<String, String>? headers,
}) async {
  final manager = HeadlessWebViewManager();
  final result = await manager.getPageContent(WebViewConfig(
    url: url,
    html: html,
    javaScript: js,
    tag: tag,
    headerMap: headers,
  ));
  return result.body;
}

/// 便捷函数：嗅探资源 URL（对应 java.webViewGetSource）
Future<String?> webViewSniffSource({
  String? html,
  String? url,
  String? sourceRegex,
  String? js,
  String? tag,
  Map<String, String>? headers,
  int delayTimeMs = 0,
}) async {
  final manager = HeadlessWebViewManager();
  final result = await manager.getPageContent(WebViewConfig(
    url: url,
    html: html,
    javaScript: js,
    sourceRegex: sourceRegex,
    tag: tag,
    headerMap: headers,
    delayTimeMs: delayTimeMs,
  ));
  return result.body;
}

/// 便捷函数：嗅探跳转 URL（对应 java.webViewGetOverrideUrl）
Future<String?> webViewSniffOverrideUrl({
  String? html,
  String? url,
  String? overrideUrlRegex,
  String? js,
  String? tag,
  Map<String, String>? headers,
  int delayTimeMs = 0,
}) async {
  final manager = HeadlessWebViewManager();
  final result = await manager.getPageContent(WebViewConfig(
    url: url,
    html: html,
    javaScript: js,
    overrideUrlRegex: overrideUrlRegex,
    tag: tag,
    headerMap: headers,
    delayTimeMs: delayTimeMs,
  ));
  return result.body;
}
