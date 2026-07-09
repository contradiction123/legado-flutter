import '../../core/network/http_helper.dart';
import '../../core/network/response_model.dart';

/// URL 分析引擎
///
/// 对标原：AnalyzeUrl.kt
/// 处理 URL 模板变量替换、请求发送、响应获取
class AnalyzeUrl {
  final HttpHelper _http;

  AnalyzeUrl() : _http = HttpHelper.create();

  /// 替换 URL 模板中的变量
  /// 例如：`/search?keyword={{key}}&page={{page}}` + `{key: "小说", page: 1}`
  /// → `/search?keyword=小说&page=1`
  String buildUrl(String urlTemplate, Map<String, dynamic> variables) {
    if (!urlTemplate.contains('{{')) return urlTemplate;

    var url = urlTemplate;
    for (final entry in variables.entries) {
      final placeholder = '{{${entry.key}}}';
      url = url.replaceAll(placeholder, Uri.encodeComponent(entry.value.toString()));
    }
    return url;
  }

  /// 构建完整 URL（处理相对路径）
  String resolveUrl(String baseUrl, String? relativeUrl) {
    if (relativeUrl == null || relativeUrl.isEmpty) return baseUrl;
    if (relativeUrl.startsWith('http://') || relativeUrl.startsWith('https://')) {
      return relativeUrl;
    }
    try {
      final base = Uri.parse(baseUrl);
      return base.resolve(relativeUrl).toString();
    } catch (e) {
      return '$baseUrl$relativeUrl';
    }
  }

  /// 发送 GET 请求并获取响应体
  Future<StrResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    return _http.get(url, headers: headers, queryParameters: queryParameters);
  }

  /// 发送 POST 请求并获取响应体
  Future<StrResponse> post(
    String url, {
    String? body,
    Map<String, String>? headers,
  }) {
    return _http.postBody(url, body: body, headers: headers);
  }

  /// 根据 Content-Type 自动解析响应
  /// 返回 HTML 或纯文本
  Future<String> fetchAsString(
    String url, {
    Map<String, String>? headers,
    String? method,
    String? body,
  }) async {
    final response = method?.toUpperCase() == 'POST'
        ? await _http.postBody(url, body: body, headers: headers)
        : await _http.get(url, headers: headers);

    return response.body ?? '';
  }

  /// 批量构建 URL（用于多页场景）
  List<String> buildUrls(String urlTemplate, Map<String, dynamic> baseVariables, {int pageCount = 1}) {
    if (pageCount <= 1) {
      return [buildUrl(urlTemplate, baseVariables)];
    }

    final urls = <String>[];
    for (var page = 1; page <= pageCount; page++) {
      final vars = Map<String, dynamic>.from(baseVariables);
      vars['page'] = page.toString();
      urls.add(buildUrl(urlTemplate, vars));
    }
    return urls;
  }
}
