import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

/// EPUB 书籍模型 — 解析后的完整数据结构
class EpubBook {
  /// 书名
  final String title;

  /// 作者
  final String author;

  /// 简介
  final String? description;

  /// 封面图片数据
  final List<int>? coverImage;

  /// 章节列表（按 spine 顺序）
  final List<EpubChapter> chapters;

  /// 所有资源（href → 数据）
  final Map<String, List<int>> resources;

  const EpubBook({
    required this.title,
    this.author = '',
    this.description,
    this.coverImage,
    this.chapters = const [],
    this.resources = const {},
  });
}

/// EPUB 单章模型
class EpubChapter {
  /// 章节标题
  final String title;

  /// 章节原始 HTML 内容
  final String htmlContent;

  /// 该章节对应的资源 href（用于图片路径解析）
  final String resourceHref;

  /// 章节索引
  final int index;

  const EpubChapter({
    required this.title,
    required this.htmlContent,
    required this.resourceHref,
    required this.index,
  });
}

/// EPUB 文件解析器
///
/// 对标原版：EpubFile.kt + me.ag2s.epublib 库
///
/// ### 解析流程
/// 1. 用 archive 包解压 EPUB（ZIP）
/// 2. 解析 META-INF/container.xml → 找到 OPF 路径
/// 3. 解析 OPF 文件 → metadata + manifest + spine
/// 4. 解析 NCX 或导航文件 → 目录结构
/// 5. 按 spine 顺序读取章节 HTML → 提取正文
/// 6. 解析并缓存所有资源文件（图片/CSS）
class EpubParser {
  /// 解析 EPUB 文件，返回 EpubBook 模型
  static Future<EpubBook> parse(List<int> bytes) async {
    // 1. 解压 ZIP
    final archive = ZipDecoder().decodeBytes(bytes);
    final files = <String, List<int>>{};
    for (final file in archive) {
      if (file.isFile) {
        files[file.name] = file.content as List<int>;
      }
    }

    // 2. 查找 container.xml
    final containerXml = _readTextFile(files, 'META-INF/container.xml');
    if (containerXml == null) {
      throw FormatException('EPUB: 未找到 META-INF/container.xml');
    }

    // 解析 container.xml → 获取 OPF 路径
    final containerDoc = XmlDocument.parse(containerXml);
    final rootfileEl = containerDoc
        .findAllElements('rootfile')
        .firstWhere(
          (e) => e.getAttribute('media-type') == 'application/oebps-package+xml',
        );
    final opfPath = rootfileEl.getAttribute('full-path')!;

    // OPF 所在目录（用于解析相对路径）
    final opfDir = opfPath.contains('/')
        ? opfPath.substring(0, opfPath.lastIndexOf('/') + 1)
        : '';

    // 3. 解析 OPF
    final opfXml = _readTextFile(files, opfPath);
    if (opfXml == null) {
      throw FormatException('EPUB: 未找到 OPF 文件: $opfPath');
    }
    final opfDoc = XmlDocument.parse(opfXml);

    // --- Metadata ---
    final metadataEl = opfDoc.findAllElements('metadata').firstOrNull;
    final title = _extractMetadataText(metadataEl, 'title') ?? '未知书名';
    final author = _extractMetadataText(metadataEl, 'creator') ?? '';
    final description = _extractMetadataText(metadataEl, 'description');

    // --- Manifest (所有文件清单) ---
    final manifest = <String, String>{}; // id → href
    final manifestMediaTypes = <String, String>{}; // id → media-type
    for (final itemEl in opfDoc.findAllElements('item')) {
      final id = itemEl.getAttribute('id') ?? '';
      final href = itemEl.getAttribute('href') ?? '';
      final mediaType = itemEl.getAttribute('media-type') ?? '';
      manifest[id] = href;
      manifestMediaTypes[id] = mediaType;
    }

    // --- Spine (阅读顺序) ---
    final spineRefs = <String>[]; // idref 列表（有序）
    for (final itemrefEl in opfDoc.findAllElements('itemref')) {
      final idref = itemrefEl.getAttribute('idref');
      if (idref != null) spineRefs.add(idref);
    }

    // 封面图片
    List<int>? coverImage;
    final coverId = _findCoverId(opfDoc);
    if (coverId != null) {
      final coverHref = manifest[coverId];
      if (coverHref != null) {
        final coverPath = _resolvePath(opfDir, coverHref);
        coverImage = files[coverPath];
      }
    }

    // 4. 解析目录 (NCX 或 nav)
    final tocHref = _findTocHref(opfDoc, manifest);
    final tocEntries = <_TocEntry>[];
    if (tocHref != null) {
      final tocPath = _resolvePath(opfDir, tocHref);
      final tocContent = _readTextFile(files, tocPath);
      if (tocContent != null) {
        // 尝试作为 NCX 解析
        if (tocHref.endsWith('.ncx')) {
          tocEntries.addAll(_parseNcx(tocContent));
        } else {
          // 尝试作为 XHTML nav 解析
          tocEntries.addAll(_parseNav(tocContent));
        }
      }
    }

    // 如果 NCX/nav 为空，从 spine 生成目录
    if (tocEntries.isEmpty) {
      for (var i = 0; i < spineRefs.length; i++) {
        final href = manifest[spineRefs[i]];
        if (href != null) {
          tocEntries.add(_TocEntry(
            title: '第${i + 1}章',
            href: _resolvePath(opfDir, href),
            fragmentId: null,
          ));
        }
      }
    }

    // 5. 提取章节内容
    final chapters = <EpubChapter>[];
    final processedHrefs = <String>{};

    for (var i = 0; i < tocEntries.length; i++) {
      final entry = tocEntries[i];
      if (entry.href.isEmpty) continue;

      // 分离 href 和 fragment
      final hrefWithoutFragment = entry.href.contains('#')
          ? entry.href.substring(0, entry.href.indexOf('#'))
          : entry.href;
      final fragmentId = entry.href.contains('#')
          ? entry.href.substring(entry.href.indexOf('#') + 1)
          : entry.fragmentId;

      // 读取 HTML 内容
      final htmlData = files[hrefWithoutFragment];
      if (htmlData == null) continue;

      var htmlContent = String.fromCharCodes(htmlData);

      // 如果多个 TOC 条目指向同一个 HTML 文件，需要用 fragment 截取
      if (processedHrefs.contains(hrefWithoutFragment) && fragmentId != null) {
        // 用 fragment ID 截取
        htmlContent = _extractByFragmentId(htmlContent, fragmentId);
      } else {
        // 第一个条目：去除 script/style/display:none
        htmlContent = _cleanHtml(htmlContent, fragmentId: fragmentId);
      }
      processedHrefs.add(hrefWithoutFragment);

      // 解析 <title> 作为后备标题
      var chapterTitle = entry.title;
      if (chapterTitle.isEmpty) {
        final titleMatch = RegExp(r'<title[^>]*>([^<]+)</title>',
                caseSensitive: false)
            .firstMatch(htmlContent);
        chapterTitle = titleMatch?.group(1)?.trim() ?? '第${i + 1}章';
      }

      chapters.add(EpubChapter(
        title: chapterTitle,
        htmlContent: htmlContent,
        resourceHref: hrefWithoutFragment,
        index: i,
      ));
    }

    // 6. 收集所有资源
    final resources = <String, List<int>>{};
    for (final entry in manifest.entries) {
      final href = _resolvePath(opfDir, entry.value);
      if (files.containsKey(href)) {
        resources[href] = files[href]!;
      }
    }
    // 也索引直接路径
    for (final entry in files.entries) {
      if (!resources.containsKey(entry.key)) {
        resources[entry.key] = entry.value;
      }
    }

    return EpubBook(
      title: title,
      author: author,
      description: description,
      coverImage: coverImage,
      chapters: chapters,
      resources: resources,
    );
  }

  /// 从 ZIP 中读取文本文件
  static String? _readTextFile(Map<String, List<int>> files, String path) {
    final data = files[path];
    if (data == null) return null;
    // 尝试检测编码并解码
    try {
      return String.fromCharCodes(data);
    } catch (_) {
      return String.fromCharCodes(data);
    }
  }

  /// 提取元数据文本（处理 dc: 命名空间）
  static String? _extractMetadataText(XmlElement? metadataEl, String localName) {
    if (metadataEl == null) return null;
    try {
      // 尝试带命名空间
      final el = metadataEl.findElements(localName).firstOrNull;
      if (el != null && el.innerText.trim().isNotEmpty) {
        return el.innerText.trim();
      }
      // 尝试 dc: 前缀
      for (final child in metadataEl.childElements) {
        final name = child.name.local;
        if (name == localName && child.innerText.trim().isNotEmpty) {
          return child.innerText.trim();
        }
      }
    } catch (_) {}
    return null;
  }

  /// 查找封面图片 ID
  static String? _findCoverId(XmlDocument opfDoc) {
    // 尝试 meta[name='cover']
    for (final meta in opfDoc.findAllElements('meta')) {
      if (meta.getAttribute('name')?.toLowerCase() == 'cover') {
        return meta.getAttribute('content');
      }
    }
    // 尝试 manifest 中 id 或 href 含 'cover' 的
    for (final item in opfDoc.findAllElements('item')) {
      final id = item.getAttribute('id') ?? '';
      final href = item.getAttribute('href') ?? '';
      if (id.toLowerCase().contains('cover') ||
          href.toLowerCase().contains('cover')) {
        return id;
      }
    }
    return null;
  }

  /// 查找目录文件（toc）的 href
  static String? _findTocHref(XmlDocument opfDoc, Map<String, String> manifest) {
    // 查找 spine 中的 toc 属性
    final spineEl = opfDoc.findAllElements('spine').firstOrNull;
    if (spineEl != null) {
      final tocId = spineEl.getAttribute('toc');
      if (tocId != null && manifest.containsKey(tocId)) {
        return manifest[tocId];
      }
    }
    // 或查找 manifest 中 media-type 为 application/x-dtbncx+xml 的
    for (final item in opfDoc.findAllElements('item')) {
      final mediaType = item.getAttribute('media-type') ?? '';
      if (mediaType == 'application/x-dtbncx+xml') {
        return item.getAttribute('href');
      }
    }
    // 后备：查找 id 为 'ncx' 或 'toc' 的
    for (final item in opfDoc.findAllElements('item')) {
      final id = item.getAttribute('id') ?? '';
      if (id == 'ncx' || id == 'toc') {
        return item.getAttribute('href');
      }
    }
    return null;
  }

  /// 解析 NCX 目录文件
  static List<_TocEntry> _parseNcx(String ncxContent) {
    final entries = <_TocEntry>[];
    try {
      final doc = XmlDocument.parse(ncxContent);
      // 遍历 navMap → navPoint
      for (final navPoint in doc.findAllElements('navPoint')) {
        final navLabel = navPoint
            .findAllElements('navLabel')
            .firstOrNull
            ?.findElements('text')
            .firstOrNull;
        final content = navPoint.findAllElements('content').firstOrNull;
        final title = navLabel?.innerText.trim() ?? '';
        var src = content?.getAttribute('src') ?? '';
        if (title.isNotEmpty && src.isNotEmpty) {
          final fragmentId = src.contains('#')
              ? src.substring(src.indexOf('#') + 1)
              : null;
          if (src.contains('#')) src = src.substring(0, src.indexOf('#'));
          entries.add(_TocEntry(title: title, href: src, fragmentId: fragmentId));
        }
      }
    } catch (_) {
      // NCX 解析失败时返回空
    }
    return entries;
  }

  /// 解析 XHTML nav 目录
  static List<_TocEntry> _parseNav(String navContent) {
    final entries = <_TocEntry>[];
    try {
      final doc = XmlDocument.parse(navContent);
      // 查找 nav 元素
      for (final navEl in doc.findAllElements('nav')) {
        if (navEl.getAttribute('epub:type') == 'toc' ||
            navEl.getAttribute('type') == 'toc') {
          for (final a in navEl.findAllElements('a')) {
            final href = a.getAttribute('href') ?? '';
            final title = a.innerText.trim();
            if (title.isNotEmpty && href.isNotEmpty) {
              final fragmentId = href.contains('#')
                  ? href.substring(href.indexOf('#') + 1)
                  : null;
              final cleanHref = href.contains('#')
                  ? href.substring(0, href.indexOf('#'))
                  : href;
              entries.add(_TocEntry(
                title: title,
                href: cleanHref,
                fragmentId: fragmentId,
              ));
            }
          }
        }
      }
    } catch (_) {}
    return entries;
  }

  /// 清除 HTML 中的无用元素，按 fragmentId 截取
  static String _cleanHtml(String html, {String? fragmentId}) {
    // 简单实现：用正则移除 script/style 标签
    var cleaned = html.replaceAll(RegExp(r'<script[^>]*>[\s\S]*?</script>',
        caseSensitive: false), '');
    cleaned = cleaned.replaceAll(RegExp(r'<style[^>]*>[\s\S]*?</style>',
        caseSensitive: false), '');
    cleaned = cleaned.replaceAll(
        RegExp(r'style\s*=\s*"[^"]*display\s*:\s*none[^"]*"',
            caseSensitive: false),
        '');

    // 如有 fragmentId，截取到对应元素
    if (fragmentId != null && fragmentId.isNotEmpty) {
      // 用 id 查找并截取 - 简化实现：返回含有该 id 的元素及后续兄弟
      final escapedId = RegExp.escape(fragmentId);
      final idPattern = RegExp(
        '<[^>]+id\\s*=\\s*["\']' + escapedId + '["\'][^>]*>',
        caseSensitive: false,
      );
      final idMatch = idPattern.firstMatch(cleaned);
      if (idMatch != null) {
        final start = idMatch.start;
          // 查找下一个 id 元素或结尾
          final afterStartStr = cleaned.substring(start + 1);
          final nextIdPattern = RegExp(
            '<[^>]+id\\s*=\\s*["\'](?!' + escapedId + ')["\'][^>]*>',
            caseSensitive: false,
          );
          final nextMatch = nextIdPattern.firstMatch(afterStartStr);
          final end = nextMatch != null ? start + 1 + nextMatch.start : cleaned.length;
          return cleaned.substring(start, end);
      }
    }

    return cleaned;
  }

  /// 按 fragment ID 从完整 HTML 中截取章节内容
  static String _extractByFragmentId(String html, String fragmentId) {
    final escapedId = RegExp.escape(fragmentId);
    final idPattern = RegExp(
      '<[^>]+id\\s*=\\s*["\']' + escapedId + '["\'][^>]*>',
      caseSensitive: false,
    );
    final idMatch = idPattern.firstMatch(html);
    if (idMatch != null) {
      final start = idMatch.start;
      // 查找下一个 id 元素或结尾
      final afterStartStr = html.substring(start + 1);
      final nextIdPattern = RegExp(
        '<[^>]+id\\s*=\\s*["\'](?!' + escapedId + ')["\'][^>]*>',
        caseSensitive: false,
      );
      final nextMatch = nextIdPattern.firstMatch(afterStartStr);
      final end = nextMatch != null ? start + 1 + nextMatch.start : html.length;
      return html.substring(start, end);
    }
    return html;
  }

  /// 解析相对路径（基于 OPF 目录）
  static String _resolvePath(String baseDir, String href) {
    if (href.startsWith('/')) return href.substring(1);
    if (href.startsWith('http://') || href.startsWith('https://')) return href;
    return baseDir + href;
  }
}

/// 内部目录条目
class _TocEntry {
  final String title;
  final String href;
  final String? fragmentId;

  const _TocEntry({
    required this.title,
    required this.href,
    this.fragmentId,
  });
}
