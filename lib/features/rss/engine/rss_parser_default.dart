import '../../../domain/models/rss_source.dart';
import 'package:xml/xml.dart';

/// 默认 RSS/Atom 解析器
///
/// 对标原：RssParserDefault.kt
/// 使用 Dart `xml` 包解析标准 RSS 2.0 / Atom XML
class RssParserDefault {
  /// 解析 RSS XML，返回文章列表
  List<RssArticleItem> parse(String xmlContent, RssSource source) {
    try {
      final document = XmlDocument.parse(xmlContent);
      final root = document.rootElement;

      // 判断是 RSS 2.0 还是 Atom
      if (root.name.local == 'rss') {
        return _parseRss(root, source);
      } else if (root.name.local == 'feed') {
        return _parseAtom(root, source);
      }
      return [];
    } catch (e) {
      throw Exception('解析 RSS/Atom XML 失败: $e');
    }
  }

  /// 解析 RSS 2.0 格式
  List<RssArticleItem> _parseRss(XmlElement rss, RssSource source) {
    final channel = rss.findElements('channel').firstOrNull;
    if (channel == null) return [];

    return channel.findElements('item').map((item) {
      final title = item.findElements('title').firstOrNull?.innerText ?? '';
      final link = item.findElements('link').firstOrNull?.innerText ?? '';
      final description =
          item.findElements('description').firstOrNull?.innerText ?? '';
      final content =
          item.findElements('content:encoded').firstOrNull?.innerText ??
          description;
      final pubDate = item.findElements('pubDate').firstOrNull?.innerText ?? '';
      final image = _extractImage(item);
      final guid = item.findElements('guid').firstOrNull?.innerText ?? link;

      return RssArticleItem(
        title: title.trim(),
        link: link.trim(),
        description: description.trim(),
        content: content.trim(),
        pubDate: pubDate.trim(),
        image: image,
        guid: guid,
      );
    }).toList();
  }

  /// 解析 Atom 格式
  List<RssArticleItem> _parseAtom(XmlElement feed, RssSource source) {
    return feed.findElements('entry').map((entry) {
      final title = entry.findElements('title').firstOrNull?.innerText ?? '';
      final link =
          entry.findElements('link').firstOrNull?.getAttribute('href') ?? '';
      final summary =
          entry.findElements('summary').firstOrNull?.innerText ?? '';
      final content =
          entry.findElements('content').firstOrNull?.innerText ?? summary;
      final published =
          entry.findElements('published').firstOrNull?.innerText ?? '';
      final updated =
          entry.findElements('updated').firstOrNull?.innerText ?? '';
      final pubDate = published.isNotEmpty ? published : updated;
      final image = _extractImage(entry);
      final id = entry.findElements('id').firstOrNull?.innerText ?? link;

      return RssArticleItem(
        title: title.trim(),
        link: link.trim(),
        description: summary.trim(),
        content: content.trim(),
        pubDate: pubDate.trim(),
        image: image,
        guid: id,
      );
    }).toList();
  }

  /// 从 XML 元素中提取图片 URL
  String _extractImage(XmlElement element) {
    // 检查 media:content / media:thumbnail
    final mediaContent = element.findElements('media:content').firstOrNull;
    if (mediaContent != null) {
      final url = mediaContent.getAttribute('url');
      if (url != null && url.isNotEmpty) return url;
    }

    final mediaThumbnail = element.findElements('media:thumbnail').firstOrNull;
    if (mediaThumbnail != null) {
      final url = mediaThumbnail.getAttribute('url');
      if (url != null && url.isNotEmpty) return url;
    }

    // 检查 enclosure
    final enclosure = element.findElements('enclosure').firstOrNull;
    if (enclosure != null) {
      final url = enclosure.getAttribute('url');
      if (url != null &&
          url.isNotEmpty &&
          (enclosure.getAttribute('type') ?? '').startsWith('image')) {
        return url;
      }
    }

    return '';
  }
}

/// RSS 文章条目（解析器产出）
class RssArticleItem {
  final String title;
  final String link;
  final String description;
  final String content;
  final String pubDate;
  final String image;
  final String guid;

  const RssArticleItem({
    required this.title,
    required this.link,
    this.description = '',
    this.content = '',
    this.pubDate = '',
    this.image = '',
    this.guid = '',
  });
}
