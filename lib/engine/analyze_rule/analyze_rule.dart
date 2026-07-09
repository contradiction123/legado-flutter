import '../js_engine/js_engine_wrapper.dart';
import 'analyze_by_jsonpath.dart';
import 'analyze_by_jsoup.dart';
import 'analyze_by_regex.dart';
import 'analyze_by_xpath.dart';
import 'rule_data.dart';

/// 规则分析引擎主入口
///
/// 对标原：AnalyzeRule.kt
/// 负责解析规则字符串，调度到对应的子解析器执行
class AnalyzeRule {
  final AnalyzeByJSoup _jsoup = AnalyzeByJSoup();
  final AnalyzeByXPath _xpath = AnalyzeByXPath();
  final AnalyzeByJsonPath _jsonPath = AnalyzeByJsonPath();
  final AnalyzeByRegex _regex = AnalyzeByRegex();
  final RuleData _data = RuleData();
  final JsEngine _jsEngine = JsEngine();

  /// 设置原始数据
  void setRawData(dynamic rawData) {
    _data.rawData = rawData;
  }

  /// 设置上下文变量
  void put(String key, dynamic value) {
    _data.put(key, value);
  }

  /// 获取上下文变量
  T? get<T>(String key) {
    return _data.get<T>(key);
  }

  /// 执行规则并返回字符串结果
  String? getString(String rule, {dynamic rawData}) {
    if (rule.isEmpty) return null;
    if (rawData != null) _data.rawData = rawData;

    try {
      return _executeRule(rule);
    } catch (e) {
      return null;
    }
  }

  /// 执行规则并返回字符串列表
  List<String> getStrings(String rule, {dynamic rawData}) {
    if (rule.isEmpty) return [];
    if (rawData != null) _data.rawData = rawData;

    try {
      return _executeListRule(rule);
    } catch (e) {
      return [];
    }
  }

  /// 执行单值规则
  String? _executeRule(String rule) {
    final parsed = _parseRuleType(rule);
    final type = parsed.$1;
    final body = parsed.$2;

    switch (type) {
      case RuleType.jsoup:
        return _jsoup.getFirst(_data.rawString, body);
      case RuleType.xpath:
        return _xpath.getString(_data.rawString, body);
      case RuleType.jsonPath:
        return _jsonPath.getString(_data.rawString, body);
      case RuleType.regex:
        return _regex.autoGet(_data.rawString, body);
      case RuleType.js:
        return _executeJsRule(body);
      case RuleType.auto:
        return _autoDetect(body);
    }
  }

  /// 执行列表规则
  List<String> _executeListRule(String rule) {
    final parsed = _parseRuleType(rule);
    final type = parsed.$1;
    final body = parsed.$2;

    switch (type) {
      case RuleType.jsoup:
        return _jsoup.getList(_data.rawString, body);
      case RuleType.xpath:
        return _xpath.getStrings(_data.rawString, body);
      case RuleType.jsonPath:
        return _jsonPath.getStrings(_data.rawString, body);
      case RuleType.regex:
        return _regex.getStrings(_data.rawString, body);
      case RuleType.js:
        final result = _executeJsRule(body);
        return result != null ? [result] : [];
      case RuleType.auto:
        final result = _autoDetect(body);
        return result != null ? [result] : [];
    }
  }

  /// 执行 JS 规则
  ///
  /// 尝试在 JS 引擎中执行规则代码。
  /// 若规则包含 book 上下文，会先注入数据到 JS 作用域。
  String? _executeJsRule(String body) {
    final data = _data.rawString;
    if (data.isEmpty) return null;

    // 尝试直接作为 JS 代码执行
    // 注意：如果 jsEngine 未初始化，evaluate 内部会调用 initialize()
    final jsCode = body.contains('java.')
        ? body
        : '(function() { var result = ($body); return typeof result === "string" ? result : JSON.stringify(result); })()';

    final result = _jsEngine.evaluate(jsCode);
    if (result.isSuccess && result.stringResult.isNotEmpty) {
      return result.stringResult;
    }

    // 兜底：从预设置的数据中查找
    return _data.get<String>('jsResult:$body');
  }

  /// 自动检测数据格式并选择合适的解析方式
  String? _autoDetect(String rule) {
    final data = _data.rawString;
    if (data.isEmpty) return null;

    if (data.trim().startsWith('{') || data.trim().startsWith('[')) {
      final jsonResult = _jsonPath.getString(data, rule);
      if (jsonResult != null) return jsonResult;
    }

    if (rule.contains('//') || rule.startsWith('/')) {
      final xpathResult = _xpath.getString(data, rule);
      if (xpathResult != null) return xpathResult;
    }

    final jsoupResult = _jsoup.getFirst(data, rule);
    if (jsoupResult != null) return jsoupResult;

    return _regex.autoGet(data, rule);
  }

  /// 解析规则类型
  (RuleType, String) _parseRuleType(String rule) {
    final colonIndex = rule.indexOf(':');
    if (colonIndex < 0) {
      return (RuleType.auto, rule);
    }

    final prefix = rule.substring(0, colonIndex).toUpperCase();
    final body = rule.substring(colonIndex + 1);

    switch (prefix) {
      case '@XPath':
      case 'XPATH':
        return (RuleType.xpath, body);
      case '@JSONPATH':
      case 'JSONPATH':
        return (RuleType.jsonPath, body);
      case '@REGEX':
      case 'REGEX':
        return (RuleType.regex, body);
      case '@JS':
      case 'JS':
        return (RuleType.js, body);
      case '@CSS':
      case '@JSOUP':
      case 'CSS':
      case 'JSOUP':
        return (RuleType.jsoup, body);
      default:
        return (RuleType.auto, rule);
    }
  }
}

/// 规则类型枚举
enum RuleType { jsoup, xpath, jsonPath, regex, js, auto }
