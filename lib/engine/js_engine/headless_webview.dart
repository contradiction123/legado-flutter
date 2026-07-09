import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// 后台 WebView 模式枚举
///
/// 对标原项目的 BackstageWebView 三种模式：
/// - [normal]: 普通加载，等待页面渲染完成，获取完整 HTML
/// - [sniff]: 嗅探模式，拦截匹配指定规则的资源 URL
/// - [intercept]: 拦截模式，拦截所有请求并捕获跳转 URL
enum HeadlessWebViewMode {
  normal,
  sniff,
  intercept,
}

/// 后台 WebView 封装
///
/// 对标原项目的 BackstageWebView，用于获取 JS 渲染后的页面内容。
/// 使用 [HeadlessInAppWebView] 实现真正的无头浏览器渲染，无需在屏幕上
/// 创建可见的 WebView 实例，同时支持 iOS 和 Android 双平台。
///
/// 三种模式：
/// - [HeadlessWebViewMode.normal]: 页面完全加载后获取 outerHTML
/// - [HeadlessWebViewMode.sniff]: 资源加载时匹配正则，匹配即返回
/// - [HeadlessWebViewMode.intercept]: URL 跳转时匹配正则，匹配即返回
class HeadlessWebView {
  HeadlessInAppWebView? _webView;
  Completer<String>? _completer;
  Timer? _timeoutTimer;
  bool _isDisposed = false;
  bool _isDone = false;

  static const Duration _defaultTimeout = Duration(seconds: 15);

  /// 获取 WebView 渲染后的页面内容
  ///
  /// [url] 目标页面地址
  /// [headers] 自定义请求头（可选）
  /// [timeout] 超时时长，默认 15 秒
  /// [mode] WebView 运行模式，默认 [HeadlessWebViewMode.normal]
  /// [sourceRegex] 嗅探模式下的资源匹配正则（仅 sniff 模式有效）
  /// [overrideUrlRegex] 拦截模式下的 URL 匹配正则（仅 intercept 模式有效）
  /// [javascript] 页面加载后注入的自定义 JS（可选）
  Future<String> getContent(
    String url, {
    Map<String, String>? headers,
    Duration timeout = _defaultTimeout,
    HeadlessWebViewMode mode = HeadlessWebViewMode.normal,
    String? sourceRegex,
    String? overrideUrlRegex,
    String? javascript,
  }) async {
    if (_isDisposed) {
      throw StateError('HeadlessWebView has already been disposed');
    }

    _completer = Completer<String>();
    _isDone = false;

    final isSniffMode = mode == HeadlessWebViewMode.sniff;
    final isInterceptMode = mode == HeadlessWebViewMode.intercept;

    // 设置全局超时
    _timeoutTimer = Timer(timeout, () {
      if (!_isDone) {
        _finishWithError('加载超时（${timeout.inSeconds}秒）');
      }
    });

    try {
      _webView = HeadlessInAppWebView(
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          domStorageEnabled: true,
          mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
          blockNetworkImage: true,
          allowFileAccessFromFileURLs: true,
        ),
        initialUrlRequest: URLRequest(
          url: WebUri(url),
          headers: headers,
        ),
        onLoadStop: (controller, currentUrl) async {
          if (_isDone || _isDisposed) return;

          if (isSniffMode || isInterceptMode) {
            // 嗅探/拦截模式下，页面加载只是前置条件
            // 实际结果由 onLoadResource / shouldOverrideUrlLoading 回调处理
            return;
          }

          // 普通模式：等待页面渲染，执行 JS 获取 HTML
          try {
            final result = await controller.evaluateJavascript(
              source: javascript ?? 'document.documentElement.outerHTML',
            );
            final body = result?.toString();
            if (body != null && body.isNotEmpty && body != 'null') {
              _finish(_unescapeJsString(body));
            } else {
              // 如果 JS 返回空，重试一次（部分 SPA 页面需要时间）
              await Future.delayed(const Duration(milliseconds: 500));
              if (!_isDone && !_isDisposed) {
                final retryResult = await controller.evaluateJavascript(
                  source:
                      javascript ?? 'document.documentElement.outerHTML',
                );
                final retryBody = retryResult?.toString();
                if (retryBody != null &&
                    retryBody.isNotEmpty &&
                    retryBody != 'null') {
                  _finish(_unescapeJsString(retryBody));
                } else {
                  _finishWithError('页面内容为空');
                }
              }
            }
          } catch (e) {
            if (!_isDone) {
              _finishWithError('JS 执行失败: $e');
            }
          }
        },
        onLoadResource: (controller, resource) {
          if (!isSniffMode || _isDone || _isDisposed) return;

          if (sourceRegex != null) {
            try {
              if (RegExp(sourceRegex).hasMatch(resource.url.toString())) {
                _finish(resource.url.toString());
              }
            } catch (e) {
              // 正则表达式无效，忽略此回调
            }
          }
        },
        shouldOverrideUrlLoading: (controller, navigation) async {
          if (!isInterceptMode || _isDone || _isDisposed) {
            return NavigationActionPolicy.ALLOW;
          }

          final requestUrl = navigation.request.url.toString();
          if (overrideUrlRegex != null) {
            try {
              if (RegExp(overrideUrlRegex).hasMatch(requestUrl)) {
                _finish(requestUrl);
                return NavigationActionPolicy.CANCEL;
              }
            } catch (_) {}
          }
          return NavigationActionPolicy.ALLOW;
        },
        onReceivedError: (controller, request, error) {
          if (!_isDone && !_isDisposed) {
            _finishWithError('页面加载失败: ${error.description}');
          }
        },
      );
    } catch (e) {
      if (!_isDone) {
        _finishWithError('创建 HeadlessInAppWebView 失败: $e');
      }
    }

    return _completer!.future;
  }

  /// 关闭 WebView，释放资源
  void dispose() {
    _isDisposed = true;
    _timeoutTimer?.cancel();
    _webView?.dispose();
    _webView = null;
    _completer = null;
  }

  /// 标记完成并返回结果
  void _finish(String result) {
    if (_isDone || _isDisposed) return;
    _isDone = true;
    _timeoutTimer?.cancel();
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete(result);
    }
  }

  /// 标记完成并返回错误
  void _finishWithError(String error) {
    if (_isDone || _isDisposed) return;
    _isDone = true;
    _timeoutTimer?.cancel();
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.completeError(Exception(error));
    }
  }

  /// 反转义 JS 字符串中的转义字符
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
        .replaceAll('\\t', '\t')
        .replaceAll('\\/', '/');
  }
}
