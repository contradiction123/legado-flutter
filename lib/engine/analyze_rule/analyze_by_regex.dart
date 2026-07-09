/// 正则规则解析器
///
/// 对标原：AnalyzeByRegex.kt
/// 使用 Dart RegExp 实现正则匹配
class AnalyzeByRegex {
  /// 执行正则匹配，返回第一个匹配的完整字符串
  String? getString(String input, String regex) {
    if (input.isEmpty || regex.isEmpty) return null;
    try {
      final regExp = RegExp(regex);
      final match = regExp.firstMatch(input);
      return match?.group(0);
    } catch (e) {
      return null;
    }
  }

  /// 执行正则匹配，返回指定捕获组的内容
  String? getGroup(String input, String regex, {int group = 1}) {
    if (input.isEmpty || regex.isEmpty) return null;
    try {
      final regExp = RegExp(regex);
      final match = regExp.firstMatch(input);
      return match?.group(group);
    } catch (e) {
      return null;
    }
  }

  /// 全局匹配，返回所有匹配的完整字符串列表
  List<String> getStrings(String input, String regex) {
    if (input.isEmpty || regex.isEmpty) return [];
    try {
      final regExp = RegExp(regex);
      return regExp.allMatches(input).map((m) => m.group(0) ?? '').toList();
    } catch (e) {
      return [];
    }
  }

  /// 全局匹配，返回所有匹配的指定捕获组内容列表
  List<String> getGroups(String input, String regex, {int group = 1}) {
    if (input.isEmpty || regex.isEmpty) return [];
    try {
      final regExp = RegExp(regex);
      return regExp
          .allMatches(input)
          .map((m) => m.group(group) ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 替换匹配内容
  String replace(String input, String regex, String replacement) {
    if (input.isEmpty || regex.isEmpty) return input;
    try {
      return input.replaceAll(RegExp(regex), replacement);
    } catch (e) {
      return input;
    }
  }

  /// 判断是否匹配
  bool test(String input, String regex) {
    if (input.isEmpty || regex.isEmpty) return false;
    try {
      return RegExp(regex).hasMatch(input);
    } catch (e) {
      return false;
    }
  }

  /// 按正则分割字符串
  List<String> split(String input, String regex) {
    if (input.isEmpty || regex.isEmpty) return [input];
    try {
      return input.split(RegExp(regex));
    } catch (e) {
      return [input];
    }
  }

  /// 自动判断是否使用捕获组
  /// 如果正则包含捕获组且不提取特定组，返回第一个捕获组
  /// 否则返回完整匹配
  String? autoGet(String input, String regex) {
    if (input.isEmpty || regex.isEmpty) return null;
    try {
      final regExp = RegExp(regex);
      final match = regExp.firstMatch(input);
      if (match == null) return null;
      // 如果有捕获组，返回第一个捕获组
      if (match.groupCount >= 1 && match.group(1)!.isNotEmpty) {
        return match.group(1);
      }
      return match.group(0);
    } catch (e) {
      return null;
    }
  }
}
