import 'package:html/parser.dart' as html;
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

/// XPath 规则解析器
///
/// 对标原：AnalyzeByXPath.kt
/// 使用 `xpath_selector_html_parser` 实现 XPath 查询
class AnalyzeByXPath {
  /// 执行 XPath 查询，返回所有匹配结果的字符串值列表
  /// 对于 `//a/@href` 类属性查询，返回属性值
  /// 对于 `//div` 类节点查询，返回节点文本
  List<String> getStrings(String htmlContent, String xpathExpr) {
    if (htmlContent.isEmpty || xpathExpr.isEmpty) return [];
    try {
      final doc = html.parse(htmlContent);
      final root = doc.documentElement;
      if (root == null) return [];
      final result = root.queryXPath(xpathExpr);
      // 优先使用 attrs（属性查询），其次是 nodes 的 text
      if (result.attrs.any((a) => a != null)) {
        return result.attrs.whereType<String>().toList();
      }
      return result.nodes.map((n) => n.text?.trim() ?? '').toList();
    } catch (e) {
      return [];
    }
  }

  /// 执行 XPath 查询，返回第一个匹配节点的字符串值
  String? getString(String htmlContent, String xpathExpr) {
    final results = getStrings(htmlContent, xpathExpr);
    return results.isNotEmpty ? results.first : null;
  }

  /// 执行 XPath 查询，返回文本内容列表
  List<String> getTexts(String htmlContent, String xpathExpr) {
    if (htmlContent.isEmpty || xpathExpr.isEmpty) return [];
    try {
      final doc = html.parse(htmlContent);
      final root = doc.documentElement;
      if (root == null) return [];
      final result = root.queryXPath(xpathExpr);
      return result.nodes
          .map((n) => n.text?.trim() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 判断是否匹配
  bool exists(String htmlContent, String xpathExpr) {
    try {
      final doc = html.parse(htmlContent);
      final root = doc.documentElement;
      if (root == null) return false;
      final result = root.queryXPath(xpathExpr);
      return result.nodes.isNotEmpty || result.attrs.any((a) => a != null);
    } catch (e) {
      return false;
    }
  }
}
