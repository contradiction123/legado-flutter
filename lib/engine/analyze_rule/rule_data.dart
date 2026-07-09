/// 规则数据上下文
///
/// 对标原：RuleData.kt
/// 保存规则执行过程中所有可用的变量和数据
class RuleData {
  /// 当前正在处理的原始数据（HTML 字符串、JSON 字符串等）
  dynamic rawData;

  /// 书源上下文变量（搜索关键词、页码、书籍 URL 等）
  final Map<String, dynamic> sourceContext = {};

  /// 变量存储（可通过 put()/get() 存取）
  final Map<String, dynamic> variables = {};

  /// 上一规则执行结果缓存
  String? lastResult;

  RuleData({this.rawData});

  /// 存入变量
  void put(String key, dynamic value) {
    variables[key] = value;
  }

  /// 取出变量
  T? get<T>(String key) {
    final value = variables[key];
    if (value is T) return value;
    return null;
  }

  /// 获取原始数据的字符串表示
  String get rawString {
    if (rawData == null) return '';
    if (rawData is String) return rawData as String;
    return rawData.toString();
  }

  /// 从 sourceContext 中获取值，支持链式 key（如 "book.name"）
  dynamic getFromSource(String key) {
    final parts = key.split('.');
    dynamic current = sourceContext;
    for (final part in parts) {
      if (current is Map) {
        current = current[part];
      } else {
        return null;
      }
    }
    return current;
  }

  /// 将完整上下文转为 Map（供规则使用）
  Map<String, dynamic> toContextMap() {
    return {
      ...sourceContext,
      ...variables,
      if (lastResult != null) 'result': lastResult,
    };
  }
}
