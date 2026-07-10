import '../../../domain/models/rss_source.dart';
import '../../../engine/analyze_rule/analyze_rule.dart';
import '../../../core/network/dio_client.dart';
import 'rss_parser_default.dart';

/// 基于规则的 RSS 解析器
///
/// 对标原：RssParserByRule.kt
/// 复用 AnalyzeRule 引擎解析非标准 RSS 页面
class RssParserByRule {
  final DioClient _dioClient;
  final AnalyzeRule _analyzeRule;

  RssParserByRule(this._dioClient, this._analyzeRule);

  /// 使用规则解析 RSS 源，返回文章列表
  Future<List<RssArticleItem>> parse(RssSource source) async {
    try {
      // 获取页面内容
      final response = await _dioClient.dio.get(source.sourceUrl);
      final html = response.data as String;

      _analyzeRule.setRawData(html);

      // 解析文章列表
      final articlesRule = source.ruleArticles;
      if (articlesRule == null || articlesRule.isEmpty) {
        // 没有规则则当作标准 RSS 处理失败
        throw Exception('未配置解析规则');
      }

      final articles = _analyzeRule.getStrings(articlesRule);
      if (articles.isEmpty) return [];

      // 解析每个文章的详细信息
      final results = <RssArticleItem>[];
      for (var i = 0; i < articles.length; i++) {
        _analyzeRule.setRawData(articles[i]);

        final title = _analyzeRule.getString(source.ruleTitle ?? '') ?? '';
        final link = _analyzeRule.getString(source.ruleLink ?? '') ?? '';
        final description =
            _analyzeRule.getString(source.ruleDescription ?? '') ?? '';
        final pubDate = _analyzeRule.getString(source.rulePubDate ?? '') ?? '';
        final image = _analyzeRule.getString(source.ruleImage ?? '') ?? '';
        final content = _analyzeRule.getString(source.ruleContent ?? '') ?? '';

        if (title.isEmpty && link.isEmpty) continue;

        results.add(
          RssArticleItem(
            title: title,
            link: link,
            description: description,
            content: content,
            pubDate: pubDate,
            image: image,
            guid: link,
          ),
        );
      }

      return results;
    } catch (e) {
      throw Exception('基于规则的 RSS 解析失败: $e');
    }
  }
}
