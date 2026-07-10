import 'dart:io';

import '../../domain/models/book.dart';
import '../../domain/models/book_chapter.dart';
import 'base_parser.dart';
import 'encoding_detector.dart';

/// TXT 文件解析器
///
/// 对标原版：TextFile.kt
/// 支持：编码自动检测 / 目录规则正则匹配 / 大文件分片读取
class TextParser implements BaseLocalBookParser {
  final _bufferSize = 512 * 1024; // 512KB
  final _maxLengthWithNoToc = 10 * 1024; // 无目录时每章最大10KB
  final _maxLengthWithToc = 100 * 1024; // 有目录时每章最大100KB

  String? _encoding;
  String? _tocPatternString;
  String? _fileContent;

  @override
  Future<void> updateBookInfo(Book book) async {
    // TXT 格式不需要额外的元数据更新
  }

  @override
  Future<List<BookChapter>> getChapterList(Book book) async {
    // 读取文件内容
    final content = await _readFileContent(book.bookUrl);

    // 检测编码
    final bytes = await _readFileBytes(book.bookUrl, _bufferSize);
    _encoding = EncodingDetector.detectEncoding(bytes);
    _fileContent = EncodingDetector.decode(bytes, _encoding!);

    if (content.isEmpty) return [];

    // 尝试检测目录规则
    _tocPatternString = _detectTocPattern(content);

    // 根据目录规则分割章节
    if (_tocPatternString != null && _tocPatternString!.isNotEmpty) {
      return _splitByPattern(content, book);
    } else {
      return _splitBySize(content, book);
    }
  }

  @override
  Future<String?> getContent(Book book, BookChapter chapter) async {
    // 如果已缓存内容，直接切片
    if (_fileContent != null && chapter.start != null && chapter.end != null) {
      final start = chapter.start!.clamp(0, _fileContent!.length);
      final end = chapter.end!.clamp(start, _fileContent!.length);
      return _fileContent!.substring(start, end);
    }

    // 否则读取并解码
    final content = await _readFileContent(book.bookUrl);
    if (content.isEmpty) return null;

    if (chapter.start != null && chapter.end != null) {
      final start = chapter.start!.clamp(0, content.length);
      final end = chapter.end!.clamp(start, content.length);
      return content.substring(start, end);
    }

    return content;
  }

  @override
  Future<List<int>?> getResource(Book book, String href) async {
    // TXT 文件不包含资源
    return null;
  }

  /// 读取文件全部内容（按检测到的编码解码）
  Future<String> _readFileContent(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return '';

      final bytes = await file.readAsBytes();

      // 检测编码
      if (_encoding == null) {
        _encoding = EncodingDetector.detectEncoding(bytes);
      }

      // 按 BOM 偏移跳过 BOM
      var contentBytes = bytes;
      if (bytes.length >= 3 &&
          bytes[0] == 0xEF &&
          bytes[1] == 0xBB &&
          bytes[2] == 0xBF) {
        contentBytes = bytes.sublist(3);
      }

      // 解码
      if (_encoding == 'utf-8' || _encoding == 'utf8') {
        return String.fromCharCodes(contentBytes);
      } else {
        return EncodingDetector.decode(contentBytes, _encoding!);
      }
    } catch (e) {
      return '';
    }
  }

  /// 读取文件前 N 字节
  Future<List<int>> _readFileBytes(String filePath, int maxBytes) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return [];

      final raf = await file.open(mode: FileMode.read);
      final bytes = await raf.read(maxBytes);
      await raf.close();
      return bytes;
    } catch (e) {
      return [];
    }
  }

  /// 自动检测 TXT 文件的目录正则
  ///
  /// 对标原版：TxtTocRule.kt 的自动匹配逻辑
  /// 尝试常见目录模式：
  /// - 第XXX章 / 第XXX节
  /// - Chapter XXX
  /// - 普通数字标题
  String? _detectTocPattern(String content) {
    // 优先使用内置的常用目录规则
    final commonPatterns = [
      // 第X章（最常见）
      RegExp(r'第[0-9一二三四五六七八九十百千万零〇\d]+[章章节回]'),
      // 第X节
      RegExp(r'第[0-9一二三四五六七八九十百千万零〇\d]+节'),
      // 第X卷
      RegExp(r'第[0-9一二三四五六七八九十百千万零〇\d]+卷'),
      // Chapter / Chapter #
      RegExp(r'(Chapter|Section)\s*\d+', caseSensitive: false),
      // 卷X
      RegExp(r'(卷|部)[一二三四五六七八九十\d]'),
      // 楔子 / 序章
      RegExp(r'^(楔子|序章|序言|前言|引子|尾声|后记)$', multiLine: true),
      // 纯数字（至少匹配3个以上）
      RegExp(r'^\d+$', multiLine: true),
    ];

    for (final pattern in commonPatterns) {
      final matches = pattern.allMatches(content);
      if (matches.length >= 3) {
        // 统计匹配率，避免误匹配
        final matchCount = matches.length;
        final totalLines = content.split('\n').length;
        if (matchCount <= totalLines * 0.3) {
          return pattern.pattern;
        }
      }
    }

    return null;
  }

  /// 按目录规则分割章节
  List<BookChapter> _splitByPattern(String content, Book book) {
    final chapters = <BookChapter>[];
    final pattern = RegExp(_tocPatternString!, multiLine: true);
    final matches = pattern.allMatches(content).toList();

    if (matches.isEmpty) {
      return _splitBySize(content, book);
    }

    for (var i = 0; i < matches.length; i++) {
      final start = matches[i].start;
      final end = (i + 1 < matches.length)
          ? matches[i + 1].start
          : content.length;

      // 限制单章最大长度
      final actualEnd = (end - start > _maxLengthWithToc)
          ? start + _maxLengthWithToc
          : end;

      // 创建 BookChapter
      final chapterTitle = matches[i].group(0)?.trim() ?? '第${i + 1}章';
      final url = 'txt://${book.originName}/$i';
      final md5Hash = _md5Hex('${book.originName}$i$chapterTitle');

      chapters.add(
        BookChapter(
          url: url,
          title: chapterTitle,
          baseUrl: book.bookUrl,
          bookUrl: book.bookUrl,
          index: i,
          start: start,
          end: actualEnd,
          isVolume: false,
          isVip: false,
          isPay: false,
        ),
      );
    }

    return chapters;
  }

  /// 无目录规则时按固定大小分割
  List<BookChapter> _splitBySize(String content, Book book) {
    final chapters = <BookChapter>[];
    var start = 0;
    var chapterIndex = 0;

    while (start < content.length) {
      var end = start + _maxLengthWithNoToc;
      if (end >= content.length) {
        end = content.length;
      } else {
        // 尽量在段落边界分割
        final searchEnd = end + 200;
        final boundaryEnd = searchEnd.clamp(0, content.length);
        final nextNewline = content.indexOf('\n', end);
        if (nextNewline > 0 && nextNewline < boundaryEnd) {
          end = nextNewline + 1;
        }
      }

      final url = 'txt://${book.originName}/$chapterIndex';
      chapters.add(
        BookChapter(
          url: url,
          title: '第${chapterIndex + 1}节',
          baseUrl: book.bookUrl,
          bookUrl: book.bookUrl,
          index: chapterIndex,
          start: start,
          end: end,
          isVolume: false,
          isVip: false,
          isPay: false,
        ),
      );

      start = end;
      chapterIndex++;
    }

    return chapters;
  }

  /// 简易 MD5 hex 实现（避免引入 crypto 包的 hash 依赖）
  static String _md5Hex(String input) {
    // 使用内置的哈希作为简易指纹
    return input.hashCode.toRadixString(16).padLeft(8, '0');
  }

  /// 获取检测到的编码
  String? get encoding => _encoding;

  /// 设置编码（允许用户手动指定）
  void setEncoding(String encoding) {
    _encoding = encoding;
  }
}
