import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/models/rss_article.dart';
import '../../../core/utils/chinese_convert.dart';
import '../providers/rss_provider.dart';

/// RSS 文章阅读页面
///
/// 对标原：RssReadActivity.kt
/// 内置阅读器 + WebView 降级
class RssReaderScreen extends ConsumerStatefulWidget {
  final RssArticle article;

  const RssReaderScreen({super.key, required this.article});

  @override
  ConsumerState<RssReaderScreen> createState() => _RssReaderScreenState();
}

class _RssReaderScreenState extends ConsumerState<RssReaderScreen> {
  InAppWebViewController? _webViewController;
  double _progress = 0;
  bool _useWebView = false;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final favorited = await ref
        .read(rssProvider.notifier)
        .isFavorited(widget.article.origin, widget.article.link);
    if (mounted) {
      setState(() => _isFavorited = favorited);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final article = widget.article;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorited ? Icons.star : Icons.star_outline,
              color: _isFavorited ? Colors.amber : null,
            ),
            tooltip: '收藏',
            onPressed: () async {
              await ref.read(rssProvider.notifier).toggleFavorite(article);
              setState(() => _isFavorited = !_isFavorited);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'share':
                  _shareArticle(article);
                  break;
                case 'open_in_browser':
                  _openInBrowser(article.link);
                  break;
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'share',
                child: ListTile(leading: Icon(Icons.share), title: Text('分享')),
              ),
              const PopupMenuItem(
                value: 'open_in_browser',
                child: ListTile(
                  leading: Icon(Icons.open_in_browser),
                  title: Text('浏览器打开'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _useWebView ? _buildWebView() : _buildReader(theme),
      bottomNavigationBar: _useWebView
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.language),
                        label: const Text('网页查看'),
                        onPressed: () {
                          setState(() => _useWebView = true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildReader(ThemeData theme) {
    final article = widget.article;
    // 优先使用 content，没有则使用 description
    final content = (article.content != null && article.content!.isNotEmpty)
        ? article.content!
        : (article.description ?? '');

    // 替换规则净化（可选）
    // 这里可以集成 ReplaceRuleService

    // 渲染内容
    final isHtml = content.contains('<') && content.contains('>');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            article.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          // 元信息
          if (article.pubDate != null && article.pubDate!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                article.pubDate!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          const Divider(height: 24),
          // 正文
          if (isHtml)
            _buildHtmlContent(content, theme)
          else
            Text(
              content,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.8),
            ),
        ],
      ),
    );
  }

  Widget _buildHtmlContent(String html, ThemeData theme) {
    // 简单处理 HTML 标签，提取纯文本
    final text = html
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();

    return Text(text, style: theme.textTheme.bodyLarge?.copyWith(height: 1.8));
  }

  Widget _buildWebView() {
    return Column(
      children: [
        if (_progress < 1.0) LinearProgressIndicator(value: _progress),
        Expanded(
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.article.link)),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onProgressChanged: (controller, progress) {
              setState(() => _progress = progress / 100.0);
            },
          ),
        ),
      ],
    );
  }

  void _shareArticle(RssArticle article) {
    // 简单的分享实现
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('已复制链接: ${article.link}')));
  }

  Future<void> _openInBrowser(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
