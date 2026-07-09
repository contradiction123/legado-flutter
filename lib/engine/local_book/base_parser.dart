import 'package:path/path.dart' as p;

import '../../domain/models/book.dart';
import '../../domain/models/book_chapter.dart';

/// 本地书籍解析器接口
///
/// 对标原版：BaseLocalBookParse.kt
abstract class BaseLocalBookParser {
  /// 更新书籍元数据（从文件中提取书名/作者/封面等）
  Future<void> updateBookInfo(Book book);

  /// 获取章节列表
  Future<List<BookChapter>> getChapterList(Book book);

  /// 获取指定章节的正文内容
  Future<String?> getContent(Book book, BookChapter chapter);

  /// 获取书籍中的资源（如图片）
  Future<List<int>?> getResource(Book book, String href);
}

/// 书籍格式枚举
enum BookFormat {
  txt,
  epub,
  pdf,
  mobi,
  umd,
  unknown;

  String get displayName {
    switch (this) {
      case BookFormat.txt:
        return 'TXT';
      case BookFormat.epub:
        return 'EPUB';
      case BookFormat.pdf:
        return 'PDF';
      case BookFormat.mobi:
        return 'MOBI';
      case BookFormat.umd:
        return 'UMD';
      case BookFormat.unknown:
        return '未知';
    }
  }
}

/// 根据文件名检测书籍格式
BookFormat detectFormat(String fileName) {
  final ext = p.extension(fileName).toLowerCase();
  switch (ext) {
    case '.txt':
      return BookFormat.txt;
    case '.epub':
      return BookFormat.epub;
    case '.pdf':
      return BookFormat.pdf;
    case '.mobi':
    case '.azw3':
    case '.azw':
      return BookFormat.mobi;
    case '.umd':
      return BookFormat.umd;
    default:
      return BookFormat.unknown;
  }
}

/// 支持的书籍格式扩展名
const Set<String> supportedExtensions = {
  '.txt', '.epub', '.pdf', '.mobi', '.azw3', '.azw', '.umd',
};

/// 从文件名分析书名和作者
/// 对标原版 LocalBook.analyzeNameAuthor()
(String name, String author) analyzeNameFromFileName(String fileName) {
  final nameWithoutExt = p.basenameWithoutExtension(fileName);
  var name = nameWithoutExt;
  var author = '';

  // 尝试常见模式："《书名》作者：xxx" / "书名 by 作者"
  final patterns = [
    RegExp(r'《([^》]+)》.*?作者[：:](\S+)'),
    RegExp(r'《([^》]+)》'),
    RegExp(r'^(.+)作者[：:](\S+)$'),
    RegExp(r'^(.+)\s+by\s+(.+)$', caseSensitive: false),
  ];

  for (final pattern in patterns) {
    final match = pattern.firstMatch(nameWithoutExt);
    if (match != null) {
      name = match.group(1) ?? nameWithoutExt;
      author = match.group(2)?.trim() ?? '';
      if (author.isNotEmpty) break;
    }
  }

  return (name.trim(), author.trim());
}
