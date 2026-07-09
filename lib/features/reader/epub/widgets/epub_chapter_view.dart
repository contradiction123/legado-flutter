import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// EPUB 章节阅读视图 — WebView 封装
///
/// 接收章节 HTML 内容，在 WebView 中渲染。
/// 支持：CSS 注入 / JS 通信 / 滚动位置
class EpubChapterView extends StatefulWidget {
  final String htmlContent;
  final String resourceBaseHref;
  final ReaderThemeConfig themeConfig;
  final ValueChanged<double>? onScrollChanged;
  final VoidCallback? onContentTapped;

  const EpubChapterView({
    super.key,
    required this.htmlContent,
    this.resourceBaseHref = '',
    this.themeConfig = const ReaderThemeConfig(),
    this.onScrollChanged,
    this.onContentTapped,
  });

  @override
  State<EpubChapterView> createState() => _EpubChapterViewState();
}

class _EpubChapterViewState extends State<EpubChapterView> {
  late final WebViewController _controller;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => _onPageLoaded(),
        onUrlChange: (change) {
          // 用户点击了链接
          if (change.url != null && change.url!.isNotEmpty) {
            widget.onContentTapped?.call();
          }
        },
      ))
      ..addJavaScriptChannel('FlutterBridge', onMessageReceived: (msg) {
        if (msg.message == 'scrollChanged') {
          // scroll position changed - pass to parent
        } else if (msg.message == 'contentTapped') {
          widget.onContentTapped?.call();
        }
      });
  }

  @override
  void didUpdateWidget(EpubChapterView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.htmlContent != widget.htmlContent) {
      _isLoaded = false;
      _loadContent();
    } else if (oldWidget.themeConfig != widget.themeConfig && _isLoaded) {
      _injectTheme();
    }
  }

  void _onPageLoaded() {
    _isLoaded = true;
    _injectTheme();
    _injectTapHandler();
  }

  void _loadContent() {
    _controller.loadHtmlString(widget.htmlContent);
  }

  void _injectTheme() {
    final config = widget.themeConfig;
    final bgColor = _colorToHex(config.bgColor);
    final textColor = _colorToHex(config.textColor);
    final js = '''
    (function() {
      var style = document.createElement('style');
      style.id = '__reader_theme';
      style.textContent = `
        html, body {
          background-color: ${bgColor} !important;
          color: ${textColor} !important;
        }
      `;
      var existing = document.getElementById('__reader_theme');
      if (existing) existing.remove();
      document.head.appendChild(style);
    })();
    ''';
    _controller.runJavaScript(js);
  }

  void _injectTapHandler() {
    _controller.runJavaScript('''
    document.addEventListener('click', function() {
      FlutterBridge.postMessage('contentTapped');
    });
    ''');
  }

  static String _colorToHex(Color color) {
    final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#${r}${g}${b}';
  }

  /// 更新主题（外部调用）
  void updateTheme(ReaderThemeConfig config) {
    setState(() {});
    if (_isLoaded) _injectTheme();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

/// 阅读器主题配置
class ReaderThemeConfig {
  final Color bgColor;
  final Color textColor;
  final double fontSize;
  final double lineHeight;

  const ReaderThemeConfig({
    this.bgColor = const Color(0xFFF5F0E6),
    this.textColor = const Color(0xFF3A3A3A),
    this.fontSize = 18,
    this.lineHeight = 1.8,
  });
}
