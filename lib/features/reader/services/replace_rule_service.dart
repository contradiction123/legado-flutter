import '../../../domain/models/replace_rule.dart';

/// 替换净化服务
///
/// 将替换规则应用于章节内容文本。
/// 支持正则替换和普通文本替换两种模式。
class ReplaceRuleService {
  /// 应用一批替换规则到文本内容
  ///
  /// [content] 原始章节内容
  /// [rules] 替换规则列表（仅已启用的规则）
  /// [chapterTitle] 当前章节标题（用于 scope/title 匹配）
  /// 返回替换后的文本
  String applyRules({
    required String content,
    required List<ReplaceRule> rules,
    String? chapterTitle,
  }) {
    if (rules.isEmpty) return content;

    // 按 order 排序
    final sorted = List<ReplaceRule>.from(rules)
      ..sort((a, b) => a.order.compareTo(b.order));

    var result = content;
    for (final rule in sorted) {
      if (!rule.isEnabled) continue;

      // 检查 scope 是否匹配
      if (!_isInScope(rule, chapterTitle)) continue;

      result = _applySingleRule(result, rule);
    }

    return result;
  }

  /// 检查规则是否适用于当前范围
  bool _isInScope(ReplaceRule rule, String? chapterTitle) {
    // 如果 scopeTitle 为 true，需要匹配标题
    if (rule.scopeTitle && chapterTitle != null && rule.scope != null && rule.scope!.isNotEmpty) {
      if (!_matchScope(chapterTitle, rule.scope!)) return false;
    }

    // 如果 excludeScope 不为空，排除匹配的章节
    if (rule.excludeScope != null && rule.excludeScope!.isNotEmpty && chapterTitle != null) {
      if (_matchScope(chapterTitle, rule.excludeScope!)) return false;
    }

    return true;
  }

  /// 检查标题是否匹配 scope 表达式
  /// scope 可以是正则或普通关键词
  bool _matchScope(String title, String scope) {
    try {
      final regex = RegExp(scope, caseSensitive: false);
      return regex.hasMatch(title);
    } catch (_) {
      return title.contains(scope);
    }
  }

  /// 应用单条替换规则
  String _applySingleRule(String text, ReplaceRule rule) {
    if (rule.pattern.isEmpty) return text;

    try {
      if (rule.isRegex) {
        final regex = RegExp(
          rule.pattern,
          multiLine: true,
          dotAll: true,
          caseSensitive: false,
        );
        return text.replaceAllMapped(regex, (match) {
          // 支持 $1, $2 等反向引用
          var replacement = rule.replacement;
          for (var i = 0; i <= match.groupCount; i++) {
            replacement = replacement.replaceAll(
              '\$$i',
              match.group(i) ?? '',
            );
          }
          return replacement;
        });
      } else {
        // 普通文本替换
        return text.replaceAll(rule.pattern, rule.replacement);
      }
    } catch (_) {
      // 单条规则失败不影响其他替换
      return text;
    }
  }
}
