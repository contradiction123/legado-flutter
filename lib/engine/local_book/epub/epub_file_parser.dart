import 'dart:convert';
import 'dart:io';

import '../../../domain/models/book.dart';
import '../../../domain/models/book_chapter.dart';
import '../base_parser.dart';
import 'epub_parser.dart' as parser;

/// EPUB 文件解析器适配器
///
/// 实现 BaseLocalBookParser 接口，对接 EpubParser
class EpubFileParser implements BaseLocalBookParser {
  /// 缓存已解析的 EPUB 书籍，避免重复解压
  final Map<String, parser.EpubBook> _cache = {};

  @override
  Future<void> updateBookInfo(Book book) async {
    final epub = await _loadEpub(book);
    // 更新 Book 对象的元数据
    // Book 是不可变的 freezed 类，这里记录到文件中
    // 实际修改通过 repository 完成
  }

  @override
  Future<List<BookChapter>> getChapterList(Book book) async {
    final epub = await _loadEpub(book);
    final chapters = <BookChapter>[];

    for (var i = 0; i < epub.chapters.length; i++) {
      final ch = epub.chapters[i];
      chapters.add(
        BookChapter(
          url: ch.resourceHref,
          title: ch.title,
          baseUrl: book.bookUrl,
          bookUrl: book.bookUrl,
          index: i,
          isVolume: false,
          isVip: false,
          isPay: false,
        ),
      );
    }

    return chapters;
  }

  @override
  Future<String?> getContent(Book book, BookChapter chapter) async {
    final epub = await _loadEpub(book);
    final index = chapter.index;

    if (index < 0 || index >= epub.chapters.length) return null;

    final ch = epub.chapters[index];

    // 构建完整的 HTML 文档，包含 CSS 内联和资源引用
    final html = _buildChapterHtml(ch, epub);
    return html;
  }

  @override
  Future<List<int>?> getResource(Book book, String href) async {
    final epub = await _loadEpub(book);
    return epub.resources[href];
  }

  /// 加载并缓存 EPUB 文件
  Future<parser.EpubBook> _loadEpub(Book book) async {
    if (_cache.containsKey(book.bookUrl)) {
      return _cache[book.bookUrl]!;
    }

    // 读取文件
    final file = File(book.bookUrl);
    if (!await file.exists()) {
      throw FileSystemException('EPUB file not found', book.bookUrl);
    }

    final bytes = await file.readAsBytes();

    // 解析
    final epub = await parser.EpubParser.parse(bytes);
    _cache[book.bookUrl] = epub;
    return epub;
  }

  /// 构建可在 WebView 中渲染的完整 HTML 文档
  String _buildChapterHtml(parser.EpubChapter chapter, parser.EpubBook book) {
    final resourceDir = chapter.resourceHref.contains('/')
        ? chapter.resourceHref.substring(
            0,
            chapter.resourceHref.lastIndexOf('/') + 1,
          )
        : '';

    return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
  /* EPUB 默认阅读样式 */
  html, body {
    padding: 16px;
    margin: 0;
    line-height: 1.8;
    -webkit-text-size-adjust: none;
    overflow-x: hidden;
    word-wrap: break-word;
  }
  img {
    max-width: 100% !important;
    height: auto !important;
  }
  p {
    margin: 0.5em 0;
    text-indent: 2em;
  }
  h1, h2, h3, h4, h5, h6 {
    margin: 1em 0 0.5em;
    text-indent: 0;
  }
  a { color: inherit; text-decoration: none; }
  table { max-width: 100%; overflow-x: auto; display: block; }
  pre { white-space: pre-wrap; word-wrap: break-word; }
  video { max-width: 100%; height: auto; }
</style>
</head>
<body>
${chapter.htmlContent}
</body>
</html>
''';
  }

  /// 清空缓存
  void clearCache() {
    _cache.clear();
  }

  /// 获取解析后的完整 EPUB 数据（供渲染器使用）
  Future<parser.EpubBook?> getEpubBook(Book book) async {
    try {
      return await _loadEpub(book);
    } catch (_) {
      return null;
    }
  }

  /// 获取 EPUB 的原始资源数据（用于 WebView 加载图片等）
  Future<String?> getResourceAsDataUri(Book book, String href) async {
    final resource = await getResource(book, href);
    if (resource == null) return null;

    final ext = href.split('.').last.toLowerCase();
    String mimeType;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        mimeType = 'image/jpeg';
        break;
      case 'png':
        mimeType = 'image/png';
        break;
      case 'gif':
        mimeType = 'image/gif';
        break;
      case 'webp':
        mimeType = 'image/webp';
        break;
      case 'svg':
        mimeType = 'image/svg+xml';
        break;
      case 'css':
        mimeType = 'text/css';
        break;
      case 'ttf':
      case 'otf':
        mimeType = 'font/otf';
        break;
      default:
        mimeType = 'application/octet-stream';
    }

    final base64 = base64Encode(resource);
    return 'data:$mimeType;base64,$base64';
  }
}
