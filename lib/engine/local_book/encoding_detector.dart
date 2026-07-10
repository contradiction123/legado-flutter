/// 编码检测器
///
/// 对标原版：EncodingDetect.kt
/// Dart 使用字符内容分析来猜测编码
class EncodingDetector {
  /// 常见编码列表（按优先级排序）
  static const List<String> commonEncodings = [
    'utf-8',
    'gbk',
    'gb2312',
    'big5',
    'shift-jis',
    'euc-kr',
    'iso-8859-1',
  ];

  /// BOM 标记
  static const Map<List<int>, String> bomSignatures = {
    [0xEF, 0xBB, 0xBF]: 'utf-8',
    [0xFF, 0xFE]: 'utf-16le',
    [0xFE, 0xFF]: 'utf-16be',
  };

  /// 检测编码（基于 BOM + 内容分析）
  ///
  /// 返回检测到的编码名称，默认返回 'utf-8'
  static String detectEncoding(List<int> bytes) {
    // 1. BOM 检测
    for (final entry in bomSignatures.entries) {
      final sig = entry.key;
      if (bytes.length >= sig.length) {
        bool match = true;
        for (var i = 0; i < sig.length; i++) {
          if (bytes[i] != sig[i]) {
            match = false;
            break;
          }
        }
        if (match) return entry.value;
      }
    }

    // 2. 非 ASCII 范围分析
    // 检查是否有非 ASCII 字节
    bool hasNonAscii = false;
    for (final b in bytes) {
      if (b > 127) {
        hasNonAscii = true;
        break;
      }
    }
    if (!hasNonAscii) return 'utf-8';

    // 3. UTF-8 有效性检查
    if (_isValidUtf8(bytes)) return 'utf-8';

    // 4. GBK/GB2312 检测
    if (_isGbk(bytes)) return 'gbk';

    // 5. BIG5 检测
    if (_isBig5(bytes)) return 'big5';

    return 'utf-8';
  }

  /// 判断字节流是否为有效 UTF-8
  static bool _isValidUtf8(List<int> bytes) {
    var i = 0;
    while (i < bytes.length) {
      final b = bytes[i] & 0xFF;
      if (b <= 0x7F) {
        i++;
      } else if (b >= 0xC2 && b <= 0xDF) {
        if (i + 1 >= bytes.length) return false;
        if ((bytes[i + 1] & 0xC0) != 0x80) return false;
        i += 2;
      } else if (b >= 0xE0 && b <= 0xEF) {
        if (i + 2 >= bytes.length) return false;
        if ((bytes[i + 1] & 0xC0) != 0x80 || (bytes[i + 2] & 0xC0) != 0x80) {
          return false;
        }
        i += 3;
      } else if (b >= 0xF0 && b <= 0xF4) {
        if (i + 3 >= bytes.length) return false;
        if ((bytes[i + 1] & 0xC0) != 0x80 ||
            (bytes[i + 2] & 0xC0) != 0x80 ||
            (bytes[i + 3] & 0xC0) != 0x80) {
          return false;
        }
        i += 4;
      } else {
        // 无效 UTF-8 首字节
        return false;
      }
    }
    return true;
  }

  /// 简单 GBK 检测（检查高位字节的连续性）
  static bool _isGbk(List<int> bytes) {
    var gbkSequenceCount = 0;
    var totalHighBytePairs = 0;
    var i = 0;

    while (i < bytes.length - 1) {
      final b1 = bytes[i] & 0xFF;
      final b2 = bytes[i + 1] & 0xFF;

      // GBK 双字节范围：首字节 0x81-0xFE，次字节 0x40-0xFE
      if (b1 >= 0x81 && b1 <= 0xFE && b2 >= 0x40 && b2 <= 0xFE) {
        totalHighBytePairs++;
        // 常见中文字符范围（更可能出现在文本中）
        if (b1 >= 0xB0 && b1 <= 0xF7 && b2 >= 0xA1 && b2 <= 0xFE) {
          gbkSequenceCount++;
        }
        i += 2;
      } else {
        i++;
      }
    }

    // 如果大量连续双字节符合 GBK 模式，判断为 GBK
    return totalHighBytePairs > 3 &&
        (gbkSequenceCount / totalHighBytePairs) > 0.3;
  }

  /// 简单 BIG5 检测
  static bool _isBig5(List<int> bytes) {
    var big5Count = 0;
    var i = 0;

    while (i < bytes.length - 1) {
      final b1 = bytes[i] & 0xFF;
      final b2 = bytes[i + 1] & 0xFF;

      // BIG5 范围：首字节 0xA1-0xF9，次字节 0x40-0x7E 或 0xA1-0xFE
      if ((b1 >= 0xA1 && b1 <= 0xF9) &&
          ((b2 >= 0x40 && b2 <= 0x7E) || (b2 >= 0xA1 && b2 <= 0xFE))) {
        big5Count++;
        i += 2;
      } else {
        i++;
      }
    }

    return big5Count > 3;
  }

  /// 用检测到的编码解码字节为字符串
  static String decode(List<int> bytes, String encoding) {
    try {
      return _decodeWithEncoding(bytes, encoding);
    } catch (_) {
      // 如果指定编码解码失败，回退到 UTF-8
      try {
        return _decodeWithEncoding(bytes, 'utf-8');
      } catch (_) {
        // 最终回退
        return String.fromCharCodes(bytes);
      }
    }
  }

  /// 使用指定编码解码（简易实现）
  ///
  /// 在 Dart 中，标准支持只有 utf-8/ascii。
  /// GBK/BIG5 等编码需要 charset 包或自行转换。
  /// 这里提供基本实现，生产环境建议引入 chardet / charset_converter 包。
  static String _decodeWithEncoding(List<int> bytes, String encoding) {
    switch (encoding.toLowerCase()) {
      case 'utf-8':
      case 'utf8':
        return String.fromCharCodes(bytes);
      case 'utf-16le':
      case 'utf-16be':
        // 简易：跳过前 2 字节 BOM
        return String.fromCharCodes(bytes.sublist(2));
      case 'ascii':
      case 'iso-8859-1':
        return String.fromCharCodes(bytes);
      default:
        // GBK/BIG5 等：先按 UTF-8 尝试，失败则逐个转码
        // 生产环境建议使用 charset_converter 插件
        return String.fromCharCodes(bytes.map((b) => b & 0xFF));
    }
  }

  /// 从文件头判断是否为纯文本格式
  static bool isTextFormat(List<int> headerBytes) {
    if (headerBytes.length < 4) return true;

    // 检查是否为常见二进制文件头
    final check = headerBytes.sublist(0, 4);
    final knownBinHeaders = [
      [0x25, 0x50, 0x44, 0x46], // %PDF
      [0x50, 0x4B, 0x03, 0x04], // ZIP (EPUB)
      [0x50, 0x4B, 0x05, 0x06], // ZIP empty archive
      [0x50, 0x4B, 0x07, 0x08], // ZIP spanned
    ];

    for (final header in knownBinHeaders) {
      if (check.length >= header.length) {
        bool match = true;
        for (var i = 0; i < header.length; i++) {
          if (check[i] != header[i]) {
            match = false;
            break;
          }
        }
        if (match) return false;
      }
    }

    return true;
  }
}
