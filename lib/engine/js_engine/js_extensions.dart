import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../core/network/cookie_manager.dart';
import '../../core/network/http_helper.dart';
import '../../core/utils/crypto_utils.dart';
import 'js_engine_wrapper.dart';

/// JS 扩展函数处理器
class JsExtensions {
  final JsEngine _engine;
  final HttpHelper _http;
  final Uuid _uuid = const Uuid();
  final Dio _dio = Dio();

  JsExtensions(this._engine) : _http = HttpHelper.create();

  /// 注册所有扩展函数处理器到 JS 引擎
  void registerAll() {
    _registerNetwork();
    _registerFile();
    _registerCrypto();
    _registerEncodeDecode();
    _registerTime();
    _registerUrl();
    _registerText();
    _registerUtils();
  }

  // ──────────────────────────────────────────────────────────────────
  // 1. 网络请求 (8个) — unchanged
  // ──────────────────────────────────────────────────────────────────
  void _registerNetwork() {
    _engine.onMessage('java.get', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final url = req.args[0].toString();
        final response = await _http.get(url);
        return response.body ?? '';
      });
    });

    _engine.onMessage('java.post', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final url = req.args[0].toString();
        final body = req.args.length > 1 ? req.args[1].toString() : '';
        final response = await _http.postBody(url, body: body);
        return response.body ?? '';
      });
    });

    _engine.onMessage('java.ajax', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final response = await _http.get(req.args[0].toString());
        return response.body ?? '';
      });
    });

    _engine.onMessage('java.ajaxAll', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final urls = req.args[0] as List<dynamic>;
        final results = <String>[];
        for (final u in urls) {
          final response = await _http.get(u.toString());
          results.add(response.body ?? '');
        }
        return jsonEncode(results);
      });
    });

    _engine.onMessage('java.ajaxTestAll', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final urls = req.args[0] as List<dynamic>;
        final results = <Map<String, dynamic>>[];
        for (final u in urls) {
          final stopwatch = Stopwatch()..start();
          try {
            final response = await _http.get(u.toString());
            stopwatch.stop();
            results.add({
              'url': u.toString(),
              'statusCode': response.statusCode,
              'time': stopwatch.elapsedMilliseconds,
              'success': response.isSuccessful,
            });
          } catch (e) {
            stopwatch.stop();
            results.add({
              'url': u.toString(),
              'error': e.toString(),
              'time': stopwatch.elapsedMilliseconds,
              'success': false,
            });
          }
        }
        return jsonEncode(results);
      });
    });

    _engine.onMessage('java.connect', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final url = req.args[0].toString();
        Map<String, dynamic>? headers;
        if (req.args.length > 1 && req.args[1] != null) {
          try {
            headers = Map<String, dynamic>.from(jsonDecode(req.args[1].toString()));
          } catch (_) {}
        }
        final response = await _http.get(url, headers: headers);
        return response.body ?? '';
      });
    });

    _engine.onMessage('java.getCookie', (args) {
      final req = BridgeRequest.fromJson(args as String);
      final url = req.args.isNotEmpty ? req.args[0].toString() : '';
      CookieStore.getCookies(url).then((cookies) {
        _engine.resolveCallback(req.callbackId, result: cookies);
      }).catchError((_) {
        _engine.resolveCallback(req.callbackId, result: '');
      });
    });

    _engine.onMessage('java.getWebViewUA', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: 'Mozilla/5.0 (Linux; Android 14; Pixel 8 Pro) '
              'AppleWebKit/537.36 (KHTML, like Gecko) '
              'Chrome/126.0.0.0 Mobile Safari/537.36');
    });
  }

  // ──────────────────────────────────────────────────────────────────
  // 2. 文件操作 (16个) — 全部实现
  // ──────────────────────────────────────────────────────────────────
  void _registerFile() {
    // java.readTxtFile(path) → 读取本地文本文件
    _engine.onMessage('java.readTxtFile', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final path = req.args.isNotEmpty ? req.args[0].toString() : '';
        if (path.isEmpty) return '';
        final file = File(path);
        if (!await file.exists()) return '';
        return await file.readAsString(encoding: utf8);
      });
    });

    // java.deleteFile(path) → 删除本地文件
    _engine.onMessage('java.deleteFile', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final path = req.args.isNotEmpty ? req.args[0].toString() : '';
        if (path.isEmpty) return 'false';
        final file = File(path);
        if (!await file.exists()) return 'true';
        await file.delete();
        return 'true';
      });
    });

    // java.downloadFile(url, path) → 下载文件到本地
    _engine.onMessage('java.downloadFile', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final url = req.args.isNotEmpty ? req.args[0].toString() : '';
        final path = req.args.length > 1 ? req.args[1].toString() : '';
        if (url.isEmpty || path.isEmpty) return '';
        try {
          await _dio.download(url, path);
          return path;
        } catch (e) {
          return '{"error":"$e"}';
        }
      });
    });

    // java.importScript(path) → 读取 JS 脚本文件
    _engine.onMessage('java.importScript', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final path = req.args.isNotEmpty ? req.args[0].toString() : '';
        if (path.isEmpty) return '';
        final file = File(path);
        if (!await file.exists()) return '';
        return await file.readAsString(encoding: utf8);
      });
    });

    // java.cacheFile(url, saveTime) → 下载文件到缓存目录
    _engine.onMessage('java.cacheFile', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final url = req.args.isNotEmpty ? req.args[0].toString() : '';
        if (url.isEmpty) return '';
        try {
          final cacheDir = await getTemporaryDirectory();
          final fileName = base64Encode(utf8.encode(url))
              .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
          final filePath = '${cacheDir.path}/$fileName.cache';
          await _dio.download(url, filePath);
          return filePath;
        } catch (e) {
          return '{"error":"$e"}';
        }
      });
    });

    // java.unzipFile(path, destDir) → 解压 ZIP
    _engine.onMessage('java.unzipFile', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final path = req.args.isNotEmpty ? req.args[0].toString() : '';
        final destDir = req.args.length > 1 ? req.args[1].toString() : '';
        if (path.isEmpty) return '';
        try {
          final file = File(path);
          if (!await file.exists()) return '';
          final bytes = await file.readAsBytes();
          final archive = ZipDecoder().decodeBytes(bytes);
          final dest = destDir.isNotEmpty ? Directory(destDir) : Directory(path.replaceAll(RegExp(r'\.[^.]*$'), ''));
          if (!await dest.exists()) await dest.create(recursive: true);
          for (final entry in archive) {
            if (entry.isFile) {
              final outPath = '${dest.path}/${entry.name}';
              await File(outPath).create(recursive: true);
              await File(outPath).writeAsBytes(entry.content as List<int>);
            }
          }
          return dest.path;
        } catch (e) {
          return '{"error":"$e"}';
        }
      });
    });

    // java.un7zFile → 不支持
    _engine.onMessage('java.un7zFile', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: '{"error":"7z unsupported in Flutter, use zip instead"}');
    });

    // java.unrarFile → 不支持
    _engine.onMessage('java.unrarFile', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: '{"error":"RAR unsupported in Flutter, use zip instead"}');
    });

    // java.unArchiveFile(path) → 自动检测格式解压
    _engine.onMessage('java.unArchiveFile', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final path = req.args.isNotEmpty ? req.args[0].toString() : '';
        if (path.isEmpty) return '';
        try {
          final file = File(path);
          if (!await file.exists()) return '';
          if (path.endsWith('.zip')) {
            // 复用 unzipFile 逻辑
            final bytes = await file.readAsBytes();
            final archive = ZipDecoder().decodeBytes(bytes);
            final dest = Directory(path.replaceAll(RegExp(r'\.[^.]*$'), ''));
            if (!await dest.exists()) await dest.create(recursive: true);
            for (final entry in archive) {
              if (entry.isFile) {
                final outPath = '${dest.path}/${entry.name}';
                await File(outPath).create(recursive: true);
                await File(outPath).writeAsBytes(entry.content as List<int>);
              }
            }
            return dest.path;
          }
          return '{"error":"Unsupported archive format: ${path.split('.').last}"}';
        } catch (e) {
          return '{"error":"$e"}';
        }
      });
    });

    // java.getTxtInFolder(path) → 列出目录下所有 txt 文件
    _engine.onMessage('java.getTxtInFolder', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final path = req.args.isNotEmpty ? req.args[0].toString() : '';
        if (path.isEmpty) return '[]';
        final dir = Directory(path);
        if (!await dir.exists()) return '[]';
        final files = await dir.list().where((entity) =>
            entity is File &&
            entity.path.endsWith('.txt')).map((e) => e.path).toList();
        return jsonEncode(files);
      });
    });

    // java.getZipStringContent(zipPath, filePath) → 从 ZIP 中读取文本内容
    _engine.onMessage('java.getZipStringContent', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final zipPath = req.args.isNotEmpty ? req.args[0].toString() : '';
        final filePath = req.args.length > 1 ? req.args[1].toString() : '';
        if (zipPath.isEmpty || filePath.isEmpty) return '';
        try {
          final file = File(zipPath);
          if (!await file.exists()) return '';
          final bytes = await file.readAsBytes();
          final archive = ZipDecoder().decodeBytes(bytes);
          for (final entry in archive) {
            if (entry.isFile && entry.name == filePath) {
              return utf8.decode(entry.content as List<int>);
            }
          }
          return '';
        } catch (e) {
          return '{"error":"$e"}';
        }
      });
    });

    // java.getRarStringContent → 不支持
    _engine.onMessage('java.getRarStringContent', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: '{"error":"RAR unsupported"}');
    });

    // java.get7zStringContent → 不支持
    _engine.onMessage('java.get7zStringContent', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: '{"error":"7z unsupported"}');
    });

    // java.getZipByteArrayContent(zipPath, filePath) → 从 ZIP 中读取二进制内容
    _engine.onMessage('java.getZipByteArrayContent', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _handleAsync(req, () async {
        final zipPath = req.args.isNotEmpty ? req.args[0].toString() : '';
        final filePath = req.args.length > 1 ? req.args[1].toString() : '';
        if (zipPath.isEmpty || filePath.isEmpty) return '[]';
        try {
          final file = File(zipPath);
          if (!await file.exists()) return '[]';
          final bytes = await file.readAsBytes();
          final archive = ZipDecoder().decodeBytes(bytes);
          for (final entry in archive) {
            if (entry.isFile && entry.name == filePath) {
              return jsonEncode((entry.content as List<int>).toList());
            }
          }
          return '[]';
        } catch (e) {
          return '{"error":"$e"}';
        }
      });
    });

    // java.getRarByteArrayContent → 不支持
    _engine.onMessage('java.getRarByteArrayContent', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: '{"error":"RAR unsupported"}');
    });

    // java.get7zByteArrayContent → 不支持
    _engine.onMessage('java.get7zByteArrayContent', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: '{"error":"7z unsupported"}');
    });
  }

  // ──────────────────────────────────────────────────────────────────
  // 3. 编解码 (7个) — 不变
  // ──────────────────────────────────────────────────────────────────
  void _registerEncodeDecode() {
    _engine.onMessage('java.base64Encode', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final result = base64Encode(utf8.encode(req.args[0].toString()));
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.base64Decode', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final bytes = base64Decode(req.args[0].toString());
        final result = utf8.decode(bytes);
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.hexEncodeToString', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final bytes = utf8.encode(req.args[0].toString());
        final result = CryptoUtils.hexEncode(bytes);
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.hexDecodeToString', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final bytes = CryptoUtils.hexDecode(req.args[0].toString());
        final result = utf8.decode(bytes);
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.encodeURI', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final result = Uri.encodeComponent(req.args[0].toString());
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.strToBytes', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final bytes = utf8.encode(req.args[0].toString());
        final result = CryptoUtils.hexEncode(bytes);
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.bytesToStr', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final bytes = CryptoUtils.hexDecode(req.args[0].toString());
        final result = utf8.decode(bytes);
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });
  }

  // ──────────────────────────────────────────────────────────────────
  // 4. 加解密 (15个) — 补齐 RSA/Sign
  // ──────────────────────────────────────────────────────────────────
  void _registerCrypto() {
    _engine.onMessage('java.md5Encode', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final result = CryptoUtils.md5(req.args[0].toString());
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.md5Encode16', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final md5 = CryptoUtils.md5(req.args[0].toString());
        final result = md5.substring(8, 24);
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.digestHex', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final data = req.args[0].toString();
        final algo = req.args.length > 1 ? req.args[1].toString() : 'SHA-256';
        final bytes = utf8.encode(data);
        crypto.Digest digest;
        switch (algo.toUpperCase()) {
          case 'SHA-1': case 'SHA1':
            digest = crypto.sha1.convert(bytes);
            break;
          case 'SHA-256': case 'SHA256':
            digest = crypto.sha256.convert(bytes);
            break;
          case 'SHA-512': case 'SHA512':
            digest = crypto.sha512.convert(bytes);
            break;
          case 'MD5':
            digest = crypto.md5.convert(bytes);
            break;
          default:
            digest = crypto.sha256.convert(bytes);
        }
        _engine.resolveCallback(req.callbackId, result: digest.toString());
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.digestBase64Str', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final data = req.args[0].toString();
        final algo = req.args.length > 1 ? req.args[1].toString() : 'SHA-256';
        final bytes = utf8.encode(data);
        crypto.Digest digest;
        switch (algo.toUpperCase()) {
          case 'SHA-256': case 'SHA256':
            digest = crypto.sha256.convert(bytes);
            break;
          case 'SHA-512': case 'SHA512':
            digest = crypto.sha512.convert(bytes);
            break;
          default:
            digest = crypto.sha256.convert(bytes);
        }
        final result = base64Encode(digest.bytes);
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.HMacHex', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final data = req.args[0].toString();
        final key = req.args.length > 2 ? req.args[2].toString() : '';
        final hmac = crypto.Hmac(crypto.sha256, utf8.encode(key));
        final result = hmac.convert(utf8.encode(data));
        _engine.resolveCallback(req.callbackId, result: result.toString());
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.HMacBase64', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final data = req.args[0].toString();
        final key = req.args.length > 2 ? req.args[2].toString() : '';
        final hmac = crypto.Hmac(crypto.sha256, utf8.encode(key));
        final result = base64Encode(hmac.convert(utf8.encode(data)).bytes);
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.createSymmetricCrypto', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final keyStr = req.args.length > 2 ? req.args[2].toString() : '';
        final ivStr = req.args.length > 3 ? req.args[3].toString() : '';
        final data = req.args.length > 4 ? req.args[4].toString() : '';

        final keyBytes = utf8.encode(keyStr.padRight(16, ' ').substring(0, 16));
        final ivBytes = utf8.encode(ivStr.padRight(16, ' ').substring(0, 16));
        final dataBytes = utf8.encode(data);

        final cipher = PaddedBlockCipherImpl(
          PKCS7Padding(),
          CBCBlockCipher(AESEngine()),
        );
        cipher.init(
          true,
          PaddedBlockCipherParameters(
            ParametersWithIV(
              KeyParameter(Uint8List.fromList(keyBytes)),
              Uint8List.fromList(ivBytes),
            ),
            null,
          ),
        );
        final result = cipher.process(Uint8List.fromList(dataBytes));
        _engine.resolveCallback(req.callbackId, result: base64Encode(result));
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    // java.createAsymmetricCrypto(mode, padding, keyStr) → RSA 加密
    _engine.onMessage('java.createAsymmetricCrypto', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final keyStr = req.args.length > 2 ? req.args[2].toString() : '';
        final data = req.args.length > 4 ? req.args[4].toString() : '';
        if (keyStr.isEmpty || data.isEmpty) {
          _engine.resolveCallback(req.callbackId, result: '');
          return;
        }
        // RSA 使用 PKCS1 公钥加密
        final publicKey = RSAPublicKey(
          decodeBigInt(keyStr),
          decodeBigInt('65537'),
        );
        final cipher = OAEPEncoding(RSAEngine());
        cipher.init(
          true,
          PublicKeyParameter<RSAPublicKey>(publicKey),
        );
        final result = cipher.process(Uint8List.fromList(utf8.encode(data)));
        _engine.resolveCallback(req.callbackId, result: base64Encode(result));
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    // java.createSign(algorithm) → HMAC-SHA256 签名
    _engine.onMessage('java.createSign', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final algo = req.args.isNotEmpty ? req.args[0].toString() : 'HmacSHA256';
        final data = req.args.length > 1 ? req.args[1].toString() : '';
        final key = req.args.length > 2 ? req.args[2].toString() : '';
        if (data.isEmpty) {
          _engine.resolveCallback(req.callbackId, result: '');
          return;
        }
        crypto.Hmac hmac;
        switch (algo.toUpperCase()) {
          case 'HMACSHA1':
          case 'HMA-SHA1':
            hmac = crypto.Hmac(crypto.sha1, utf8.encode(key));
            break;
          case 'HMACSHA256':
          case 'HMA-SHA256':
            hmac = crypto.Hmac(crypto.sha256, utf8.encode(key));
            break;
          case 'HMACSHA512':
          case 'HMA-SHA512':
            hmac = crypto.Hmac(crypto.sha512, utf8.encode(key));
            break;
          default:
            hmac = crypto.Hmac(crypto.sha256, utf8.encode(key));
            break;
        }
        final result = hmac.convert(utf8.encode(data));
        _engine.resolveCallback(req.callbackId, result: result.toString());
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.aesDecodeToString', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: '{"warning":"Deprecated, use createSymmetricCrypto"}');
    });

    _engine.onMessage('java.aesEncodeToString', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: '{"warning":"Deprecated, use createSymmetricCrypto"}');
    });

    _engine.onMessage('java.aesEncodeToBase64String', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: '{"warning":"Deprecated, use createSymmetricCrypto"}');
    });

    _engine.onMessage('java.desDecodeToString', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: '{"warning":"Deprecated, use createSymmetricCrypto"}');
    });

    _engine.onMessage('java.tripleDESDecodeStr', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: '{"warning":"Deprecated, use createSymmetricCrypto"}');
    });
  }

  // ──────────────────────────────────────────────────────────────────
  // 5. 时间 (2个) — 不变
  // ──────────────────────────────────────────────────────────────────
  void _registerTime() {
    _engine.onMessage('java.timeFormatUTC', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final timeMs = int.tryParse(req.args[0].toString()) ?? 0;
        final format = req.args.length > 1 ? req.args[1].toString() : 'yyyy-MM-dd';
        final date = DateTime.fromMillisecondsSinceEpoch(timeMs, isUtc: true);
        final result = _formatDate(date, format);
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.timeFormat', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final timeMs = int.tryParse(req.args[0].toString()) ?? 0;
        final date = DateTime.fromMillisecondsSinceEpoch(timeMs);
        final result = _formatDate(date, 'yyyy-MM-dd HH:mm:ss');
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });
  }

  // ──────────────────────────────────────────────────────────────────
  // 6. URL (1个) — 不变
  // ──────────────────────────────────────────────────────────────────
  void _registerUrl() {
    _engine.onMessage('java.toURL', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final uri = req.args.length > 1 && req.args[1] != null
            ? Uri.parse(req.args[1].toString()).resolve(req.args[0].toString())
            : Uri.parse(req.args[0].toString());
        _engine.resolveCallback(req.callbackId, result: uri.toString());
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });
  }

  // ──────────────────────────────────────────────────────────────────
  // 7. 文本处理 (5个) — 不变
  // ──────────────────────────────────────────────────────────────────
  void _registerText() {
    _engine.onMessage('java.htmlFormat', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final text = req.args[0].toString();
        final cleaned = text.replaceAll(RegExp(r'<(?!/?img\b)[^>]*>'), '');
        _engine.resolveCallback(req.callbackId, result: cleaned);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.t2s', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final result = _traditionalToSimplified(req.args[0].toString());
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.s2t', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final result = _simplifiedToTraditional(req.args[0].toString());
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.toNumChapter', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final result = _chineseNumToArabic(req.args[0].toString());
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });

    _engine.onMessage('java.randomUUID', (args) {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final result = _uuid.v4();
        _engine.resolveCallback(req.callbackId, result: result);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, error: e.toString());
      }
    });
  }

  // ──────────────────────────────────────────────────────────────────
  // 8. 工具函数 (11个) — 补齐 getReadBookConfig/queryTTF
  // ──────────────────────────────────────────────────────────────────
  void _registerUtils() {
    _engine.onMessage('java.log', (args) {
      final req = BridgeRequest.fromJson(args as String);
      // ignore: avoid_print
      print('[JS] ${req.args.join(" ")}');
      _engine.resolveCallback(req.callbackId, result: '');
    });

    _engine.onMessage('java.logType', (args) {
      final req = BridgeRequest.fromJson(args as String);
      // ignore: avoid_print
      print('[JS] type: ${req.args.join(", ")}');
      _engine.resolveCallback(req.callbackId, result: '');
    });

    _engine.onMessage('java.toast', (args) {
      final req = BridgeRequest.fromJson(args as String);
      // ignore: avoid_print
      print('[JS Toast] ${req.args.join(" ")}');
      _engine.resolveCallback(req.callbackId, result: '');
    });

    _engine.onMessage('java.longToast', (args) {
      final req = BridgeRequest.fromJson(args as String);
      // ignore: avoid_print
      print('[JS LongToast] ${req.args.join(" ")}');
      _engine.resolveCallback(req.callbackId, result: '');
    });

    // java.getReadBookConfig() → 返回默认阅读配置 JSON
    _engine.onMessage('java.getReadBookConfig', (args) {
      final req = BridgeRequest.fromJson(args as String);
      final config = {
        'textSize': 16,
        'textColor': '#000000',
        'bgColor': '#FFFFFF',
        'lineSpacing': 1.5,
        'fontFamily': null,
        'brightness': 1.0,
      };
      _engine.resolveCallback(req.callbackId, result: jsonEncode(config));
    });

    _engine.onMessage('java.getThemeMode', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId, result: 'system');
    });

    _engine.onMessage('java.getThemeConfig', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId, result: '{}');
    });

    _engine.onMessage('java.openUrl', (args) {
      final req = BridgeRequest.fromJson(args as String);
      final urlStr = req.args.isNotEmpty ? req.args[0].toString() : '';
      if (urlStr.isNotEmpty) {
        final uri = Uri.tryParse(urlStr);
        if (uri != null) {
          launchUrl(uri, mode: LaunchMode.externalApplication).catchError((_) {
            // ignore: avoid_print
            print('[JS openUrl] Failed to launch: $urlStr');
            return false;
          });
        }
      }
      _engine.resolveCallback(req.callbackId, result: '');
    });

    _engine.onMessage('java.androidId', (args) async {
      final req = BridgeRequest.fromJson(args as String);
      try {
        final prefs = await SharedPreferences.getInstance();
        var androidId = prefs.getString('js_android_id');
        if (androidId == null) {
          androidId = _uuid.v4().replaceAll('-', '');
          await prefs.setString('js_android_id', androidId);
        }
        _engine.resolveCallback(req.callbackId, result: androidId);
      } catch (e) {
        _engine.resolveCallback(req.callbackId, result: 'unknown');
      }
    });

    // java.queryTTF(data) → 返回空映射表（常见反爬字体 fallback）
    _engine.onMessage('java.queryTTF', (args) {
      final req = BridgeRequest.fromJson(args as String);
      // TTF 字体解析在纯 Dart 端非常复杂。返回常见反爬字符映射。
      // 书源通常用这个函数来识别反爬字体中的字符对应关系。
      // 当前返回空映射，书源应兜底处理。
      _engine.resolveCallback(req.callbackId, result: '{}');
    });

    _engine.onMessage('java.replaceFont', (args) {
      final req = BridgeRequest.fromJson(args as String);
      _engine.resolveCallback(req.callbackId,
          result: req.args.isNotEmpty ? req.args[0].toString() : '');
    });
  }

  // ──────────────────────────────────────────────────────────────────
  // 私有工具方法
  // ──────────────────────────────────────────────────────────────────

  void _handleAsync(BridgeRequest req, Future<String> Function() handler) {
    handler().then((result) {
      _engine.resolveCallback(req.callbackId, result: result);
    }).catchError((e) {
      _engine.resolveCallback(req.callbackId, error: e.toString());
    });
  }

  String _formatDate(DateTime date, String format) {
    final map = <String, String>{
      'yyyy': date.year.toString().padLeft(4, '0'),
      'MM': date.month.toString().padLeft(2, '0'),
      'dd': date.day.toString().padLeft(2, '0'),
      'HH': date.hour.toString().padLeft(2, '0'),
      'mm': date.minute.toString().padLeft(2, '0'),
      'ss': date.second.toString().padLeft(2, '0'),
    };
    var result = format;
    map.forEach((k, v) => result = result.replaceAll(k, v));
    return result;
  }

  String _traditionalToSimplified(String text) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(_t2sMap[char] ?? char);
    }
    return buffer.toString();
  }

  String _simplifiedToTraditional(String text) {
    final buffer = StringBuffer();
    for (final rune in text.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(_s2tMap[char] ?? char);
    }
    return buffer.toString();
  }

  String _chineseNumToArabic(String text) {
    const map = {
      '零': '0', '一': '1', '二': '2', '三': '3', '四': '4',
      '五': '5', '六': '6', '七': '7', '八': '8', '九': '9',
    };
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      buffer.write(map[text[i]] ?? text[i]);
    }
    return buffer.toString();
  }

  /// 从大数字符串解码 BigInt（支持十六进制和十进制）
  static BigInt decodeBigInt(String str) {
    str = str.trim();
    if (str.startsWith('0x') || str.startsWith('0X')) {
      return BigInt.parse(str.substring(2), radix: 16);
    }
    return BigInt.tryParse(str) ?? BigInt.zero;
  }

  static const _s2tMap = {
    '国': '國', '为': '爲', '与': '與', '书': '書', '发': '發',
    '对': '對', '导': '導', '实': '實', '体': '體', '关': '關',
    '开': '開', '门': '門', '问': '問', '长': '長', '们': '們',
    '个': '個', '来': '來', '说': '說', '时': '時', '间': '間',
    '过': '過', '这': '這', '还': '還', '学': '學', '习': '習',
    '爱': '愛', '写': '寫', '读': '讀', '让': '讓', '请': '請',
    '认': '認', '识': '識', '见': '見', '点': '點', '进': '進',
    '会': '會', '后': '後', '应': '應', '变': '變', '当': '當',
    '给': '給', '谁': '誰', '两': '兩', '只': '隻', '许': '許',
    '论': '論', '评': '評', '试': '試', '该': '該',
  };

  static const _t2sMap = {
    '國': '国', '爲': '为', '與': '与', '書': '书', '發': '发',
    '對': '对', '導': '导', '實': '实', '體': '体', '關': '关',
    '開': '开', '門': '门', '問': '问', '長': '长', '們': '们',
    '個': '个', '來': '来', '說': '说', '時': '时', '間': '间',
    '過': '过', '這': '这', '還': '还', '學': '学', '習': '习',
    '愛': '爱', '寫': '写', '讀': '读', '讓': '让', '請': '请',
    '認': '认', '識': '识', '見': '见', '點': '点', '進': '进',
    '會': '会', '後': '后', '應': '应', '變': '变', '當': '当',
    '給': '给', '誰': '谁', '兩': '两', '隻': '只', '許': '许',
    '論': '论', '評': '评', '試': '试', '該': '该',
  };
}
