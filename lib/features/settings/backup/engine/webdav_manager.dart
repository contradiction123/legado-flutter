import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

/// WebDAV 管理器
///
/// 对标原：AppWebDav.kt + WebDavManager.kt
/// 基于 Dio HTTP 客户端实现 WebDAV 操作
class WebDavManager {
  final String baseUrl;
  final String username;
  final String password;
  final String _basePath;
  final Dio _dio;

  WebDavManager({
    required this.baseUrl,
    required this.username,
    required this.password,
    String basePath = '/legado_backup',
    Dio? dio,
  }) : _basePath = basePath,
       _dio = dio ?? Dio();

  String get _authHeader {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    return 'Basic $credentials';
  }

  /// 测试 WebDAV 连接
  Future<bool> testConnection() async {
    try {
      final uri = Uri.parse(_normalizeUrl(baseUrl));
      final response = await _dio.requestUri(
        uri,
        options: Options(
          method: 'PROPFIND',
          headers: {'Authorization': _authHeader, 'Depth': '0'},
        ),
      );
      final status = response.statusCode ?? 0;
      return status == 200 || status == 207 || status == 301 || status == 302;
    } catch (e) {
      return false;
    }
  }

  /// 确保远程目录存在
  Future<bool> ensureDirectory() async {
    try {
      final uri = Uri.parse('${_normalizeUrl(baseUrl)}$_basePath');
      await _dio.requestUri(
        uri,
        options: Options(
          method: 'MKCOL',
          headers: {'Authorization': _authHeader},
        ),
      );
      return true;
    } catch (e) {
      // 405 = 目录已存在，也算成功
      if (e is DioException && e.response?.statusCode == 405) {
        return true;
      }
      return false;
    }
  }

  /// 上传备份文件
  Future<bool> uploadBackup(String localPath) async {
    try {
      final file = File(localPath);
      if (!await file.exists()) return false;

      final fileName = localPath.split('/').last;
      final uri = Uri.parse('${_normalizeUrl(baseUrl)}$_basePath/$fileName');
      final bytes = await file.readAsBytes();

      final response = await _dio.putUri(
        uri,
        data: bytes,
        options: Options(
          headers: {
            'Authorization': _authHeader,
            'Content-Type': 'application/octet-stream',
          },
        ),
      );
      final status = response.statusCode ?? 0;
      return status == 201 || status == 204;
    } catch (e) {
      return false;
    }
  }

  /// 下载备份文件列表
  Future<List<WebDavFileInfo>> listBackups() async {
    try {
      await ensureDirectory();
      final uri = Uri.parse('${_normalizeUrl(baseUrl)}$_basePath/');
      final response = await _dio.requestUri(
        uri,
        options: Options(
          method: 'PROPFIND',
          headers: {'Authorization': _authHeader, 'Depth': '1'},
          responseType: ResponseType.plain,
        ),
      );
      if (response.statusCode != 207) return [];

      final body = response.data as String;
      return _parsePropfind(body);
    } catch (e) {
      return [];
    }
  }

  /// 下载备份文件
  Future<String?> downloadBackup(String fileName) async {
    try {
      final uri = Uri.parse('${_normalizeUrl(baseUrl)}$_basePath/$fileName');
      final response = await _dio.getUri(
        uri,
        options: Options(
          headers: {'Authorization': _authHeader},
          responseType: ResponseType.bytes,
        ),
      );
      if (response.statusCode != 200) return null;

      final bytes = response.data as List<int>;
      final dir = Directory.systemTemp.path;
      final localPath = '$dir/$fileName';
      await File(localPath).writeAsBytes(bytes);
      return localPath;
    } catch (e) {
      return null;
    }
  }

  /// 删除远程备份文件
  Future<bool> deleteBackup(String fileName) async {
    try {
      final uri = Uri.parse('${_normalizeUrl(baseUrl)}$_basePath/$fileName');
      final response = await _dio.deleteUri(
        uri,
        options: Options(headers: {'Authorization': _authHeader}),
      );
      final status = response.statusCode ?? 0;
      return status == 204 || status == 200;
    } catch (e) {
      return false;
    }
  }

  /// 解析 PROPFIND 响应
  List<WebDavFileInfo> _parsePropfind(String xml) {
    final files = <WebDavFileInfo>[];
    final hrefRegex = RegExp(r'<d:href>([^<]+)</d:href>');
    final nameRegex = RegExp(r'<d:displayname>([^<]*)</d:displayname>');
    final sizeRegex = RegExp(r'<d:getcontentlength>(\d+)</d:getcontentlength>');
    final dateRegex = RegExp(r'<d:getlastmodified>([^<]+)</d:getlastmodified>');

    final entries = xml.split('</d:response>');
    for (final entry in entries) {
      if (!entry.contains('<d:href>')) continue;

      final href = hrefRegex.firstMatch(entry)?.group(1) ?? '';
      if (href == _basePath || href == '$_basePath/') continue;

      final isCollection = entry.contains('<d:collection/>');
      if (isCollection) continue;

      final fileName = href.split('/').last;
      if (!fileName.contains('legado_backup')) continue;

      final name = nameRegex.firstMatch(entry)?.group(1) ?? fileName;
      final size =
          int.tryParse(sizeRegex.firstMatch(entry)?.group(1) ?? '0') ?? 0;
      final date = dateRegex.firstMatch(entry)?.group(1) ?? '';

      files.add(
        WebDavFileInfo(
          fileName: fileName,
          displayName: name,
          size: size,
          lastModified: date,
        ),
      );
    }
    return files;
  }

  String _normalizeUrl(String url) {
    if (url.endsWith('/')) {
      return url.substring(0, url.length - 1);
    }
    return url;
  }

  void dispose() {
    _dio.close();
  }
}

/// WebDAV 文件信息
class WebDavFileInfo {
  final String fileName;
  final String displayName;
  final int size;
  final String lastModified;

  const WebDavFileInfo({
    required this.fileName,
    required this.displayName,
    this.size = 0,
    this.lastModified = '',
  });
}
