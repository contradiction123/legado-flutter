import 'package:dio/dio.dart';

/// Cookie 持久化存储
///
/// 对标原：CookieStore.kt
/// 将 Cookie 持久化到 drift 数据库
///
/// 用法：
///   1. CookieStore 与 DioClient 配合，通过 getCookies / saveCookies 与数据库交互
///   2. 具体的数据库操作待 Repository 层对接
class CookieStore {
  /// 从存储获取指定域名的 Cookie
  ///
  /// [url] 关联的 URL
  /// 返回 Cookie 字符串（格式："key1=value1; key2=value2"）
  static Future<String> getCookies(String url) async {
    // TODO: 接入 Cookies 表读取
    // SELECT cookie FROM cookies WHERE url = ?
    return '';
  }

  /// 保存 Cookie 到存储
  ///
  /// [url] 关联的 URL
  /// [cookies] Cookie 字符串
  static Future<void> saveCookies(String url, String cookies) async {
    // TODO: 接入 Cookies 表写入（upsert）
    // INSERT OR REPLACE INTO cookies (url, cookie) VALUES (?, ?)
  }

  /// 清空所有 Cookie
  static Future<void> clearAll() async {
    // TODO: DELETE FROM cookies
  }
}

/// Cookie 拦截器
///
/// 对标原：OkHttpUtils 中 Cookie 拦截器 + CookieManager.kt
/// Dio 拦截器，在请求/响应时自动管理 Cookie
class CookieInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 在请求前从存储加载 Cookie 并设置到请求头
    // 暂不启用自动注入，等 Repository 层对接后完善
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 在响应后将 Set-Cookie 保存到存储
    // 暂不启用自动存储，等 Repository 层对接后完善
    handler.next(response);
  }
}
