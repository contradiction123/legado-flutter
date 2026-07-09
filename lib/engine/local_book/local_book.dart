import 'dart:io';

import '../../domain/models/book.dart';
import '../../domain/models/book_chapter.dart';
import 'base_parser.dart';
import 'epub/epub_file_parser.dart';
import 'pdf/pdf_parser.dart';
import 'text_parser.dart';
import 'unsupported_parsers.dart';

/// 本地书籍管理入口
///
/// 对标原版：LocalBook.kt
/// 负责：
/// - 格式自动识别
/// - 选择合适的解析器
/// - 书籍导入、目录获取、正文获取
class LocalBookManager {
  final Map<String, BaseLocalBookParser> _parserCache = {};

  /// 获取书籍对应的解析器
  BaseLocalBookParser _getParser(Book book) {
    final format = detectFormat(book.originName);
    final cacheKey = '${book.bookUrl}:${format.name}';

    if (_parserCache.containsKey(cacheKey)) {
      return _parserCache[cacheKey]!;
    }

    final parser = _createParser(format);
    _parserCache[cacheKey] = parser;
    return parser;
  }

  /// 根据格式创建解析器
  BaseLocalBookParser _createParser(BookFormat format) {
    switch (format) {
      case BookFormat.txt:
        return TextParser();
      case BookFormat.epub:
        return EpubFileParser();
      case BookFormat.pdf:
        return PdfParser();
      case BookFormat.mobi:
        return MobiParser();
      case BookFormat.umd:
        return UmdParser();
      case BookFormat.unknown:
        throw FormatException('Unsupported book format');
    }
  }

  /// 从文件路径导入书籍
  /// 返回创建的 Book 对象
  Future<Book> importBook({
    required String filePath,
    required String fileName,
    int groupId = 0,
  }) async {
    final format = detectFormat(fileName);

    if (format == BookFormat.unknown) {
      throw FormatException('Unsupported file format: $fileName');
    }

    // 从文件名分析元数据
    final (name, author) = analyzeNameFromFileName(fileName);

    // 创建 Book 对象
    final book = Book(
      bookUrl: filePath,
      tocUrl: '',
      origin: 'loc_book',
      originName: fileName,
      name: name,
      author: author,
      type: _formatToType(format),
      group: groupId,
      canUpdate: false,
    );

    return book;
  }

  /// 获取章节列表
  Future<List<BookChapter>> getChapterList(Book book) async {
    final parser = _getParser(book);
    return parser.getChapterList(book);
  }

  /// 获取正文内容
  Future<String?> getContent(Book book, BookChapter chapter) async {
    final parser = _getParser(book);
    return parser.getContent(book, chapter);
  }

  /// 获取书籍元数据
  Future<void> updateBookInfo(Book book) async {
    final parser = _getParser(book);
    return parser.updateBookInfo(book);
  }

  /// 格式转换为 Book.type 值
  int _formatToType(BookFormat format) {
    // 参考 BookTypeConst: text=8, audio=32, image=64
    const local = 256;
    switch (format) {
      case BookFormat.txt:
        return 8 | local;
      case BookFormat.epub:
      case BookFormat.pdf:
      case BookFormat.mobi:
      case BookFormat.umd:
        return 8 | local;
      case BookFormat.unknown:
        return 8 | local;
    }
  }

  /// 清空解析器缓存
  void clearCache() {
    _parserCache.clear();
  }
}

/// 全局本地书籍管理器实例
final localBookManager = LocalBookManager();
