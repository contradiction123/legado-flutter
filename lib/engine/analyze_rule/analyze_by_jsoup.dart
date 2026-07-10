import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;

/// JSoup 规则解析器（CSS 选择器）
///
/// 对标原：AnalyzeByJSoup.kt
/// 使用 Dart `html` 包实现 CSS 选择器解析 HTML
class AnalyzeByJSoup {
  /// 解析 HTML，用 CSS 选择器提取元素列表
  List<dom.Element> elements(String htmlContent, String cssSelector) {
    if (htmlContent.isEmpty || cssSelector.isEmpty) return [];
    try {
      final doc = html.parse(htmlContent);
      return doc.querySelectorAll(cssSelector);
    } catch (e) {
      return [];
    }
  }

  /// 获取第一个匹配元素
  dom.Element? element(String htmlContent, String cssSelector) {
    if (htmlContent.isEmpty || cssSelector.isEmpty) return null;
    try {
      final doc = html.parse(htmlContent);
      return doc.querySelector(cssSelector);
    } catch (e) {
      return null;
    }
  }

  /// 从元素中提取属性值
  /// @text → 文本内容
  /// @html → HTML 内容
  /// @ownText → 自身文本（不含子元素文本）
  /// @href, @src → 属性值
  static String? getAttr(dom.Element el, String attr) {
    switch (attr) {
      case 'text':
        return el.text;
      case 'html':
        return el.innerHtml;
      case 'ownText':
        return el.nodes
            .where((n) => n.nodeType == dom.Node.TEXT_NODE)
            .map((n) => n.text)
            .join();
      default:
        return el.attributes[attr];
    }
  }

  /// 获取单个字符串结果（CSS 选择器 + 属性提取）
  String? getString(String htmlContent, String cssSelector) {
    final result = getFirst(htmlContent, cssSelector);
    return result;
  }

  /// 批量获取字符串结果
  List<String> getStrings(String htmlContent, String cssSelector) {
    final results = getList(htmlContent, cssSelector);
    return results;
  }

  /// 解析 "css@attr" 格式的规则字符串
  /// 例如："div.title@text" → 选择器 div.title，提取 text
  /// 如果无 @ 符号，默认提取 text
  (String selector, String attr) parseRule(String rule) {
    final atIndex = rule.lastIndexOf('@');
    if (atIndex < 0) {
      return (rule.trim(), 'text');
    }
    return (
      rule.substring(0, atIndex).trim(),
      rule.substring(atIndex + 1).trim(),
    );
  }

  /// 获取第一个匹配的结果
  String? getFirst(String htmlContent, String rule) {
    final (selector, attr) = parseRule(rule);
    final el = element(htmlContent, selector);
    if (el == null) return null;
    return getAttr(el, attr);
  }

  /// 获取所有匹配的结果
  List<String> getList(String htmlContent, String rule) {
    final (selector, attr) = parseRule(rule);
    final els = elements(htmlContent, selector);
    return els
        .map((el) => getAttr(el, attr) ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }
}
