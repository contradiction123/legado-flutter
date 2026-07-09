import 'dart:convert';

import 'package:json_path/json_path.dart';

/// JSONPath 规则解析器
///
/// 对标原：AnalyzeByJSonPath.kt
/// 使用 `json_path` 包实现 JSONPath 查询
class AnalyzeByJsonPath {
  /// 解析 JSON 字符串
  dynamic _parse(String jsonContent) {
    try {
      return jsonDecode(jsonContent);
    } catch (e) {
      return null;
    }
  }

  /// 执行 JSONPath 查询，返回所有匹配值的字符串表示列表
  List<String> getStrings(String jsonContent, String jsonPathExpr) {
    if (jsonContent.isEmpty || jsonPathExpr.isEmpty) return [];
    try {
      final data = _parse(jsonContent);
      if (data == null) return [];
      final jsonPath = JsonPath(jsonPathExpr);
      final values = jsonPath.read(data);
      return values.map((v) => v.value?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    } catch (e) {
      return [];
    }
  }

  /// 执行 JSONPath 查询，返回第一个匹配值的字符串
  String? getString(String jsonContent, String jsonPathExpr) {
    final results = getStrings(jsonContent, jsonPathExpr);
    return results.isNotEmpty ? results.first : null;
  }

  /// 执行 JSONPath 查询，返回所有匹配的原始对象
  List<dynamic> getObjects(String jsonContent, String jsonPathExpr) {
    if (jsonContent.isEmpty || jsonPathExpr.isEmpty) return [];
    try {
      final data = _parse(jsonContent);
      if (data == null) return [];
      final jsonPath = JsonPath(jsonPathExpr);
      final values = jsonPath.read(data);
      return values.map((v) => v.value).toList();
    } catch (e) {
      return [];
    }
  }

  /// 执行 JSONPath 查询，返回第一个匹配的原始对象
  dynamic getObject(String jsonContent, String jsonPathExpr) {
    final results = getObjects(jsonContent, jsonPathExpr);
    return results.isNotEmpty ? results.first : null;
  }

  /// 判断 JSONPath 是否有匹配
  bool exists(String jsonContent, String jsonPathExpr) {
    try {
      final data = _parse(jsonContent);
      if (data == null) return false;
      final jsonPath = JsonPath(jsonPathExpr);
      final values = jsonPath.read(data);
      return values.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
