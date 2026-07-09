import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;

/// 加密解密工具
///
/// 对标原：CryptoUtils.kt
class CryptoUtils {
  /// MD5 哈希
  static String md5(String input) {
    final bytes = utf8.encode(input);
    final digest = crypto.md5.convert(bytes);
    return digest.toString();
  }

  /// SHA1 哈希
  static String sha1(String input) {
    final bytes = utf8.encode(input);
    final digest = crypto.sha1.convert(bytes);
    return digest.toString();
  }

  /// Base64 编码
  static String base64Encode(String input) {
    final bytes = utf8.encode(input);
    return base64.encode(bytes);
  }

  /// Base64 解码
  static String base64Decode(String input) {
    final bytes = base64.decode(input);
    return utf8.decode(bytes);
  }

  /// Base64 编码（字节数组）
  static String base64EncodeBytes(Uint8List bytes) {
    return base64.encode(bytes);
  }

  /// Base64 解码为字节数组
  static Uint8List base64DecodeBytes(String input) {
    return base64.decode(input);
  }

  /// Hex 编码
  static String hexEncode(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Hex 解码
  static Uint8List hexDecode(String hex) {
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return Uint8List.fromList(bytes);
  }
}
