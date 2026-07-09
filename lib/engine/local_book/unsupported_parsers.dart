import '../../domain/models/book.dart';
import '../../domain/models/book_chapter.dart';
import 'base_parser.dart';

/// MOBI 格式占位解析器
///
/// 当前 phase 暂未实现 MOBI/AZW3/AZW 格式解析。
/// 用户导入此类文件时将收到明确的提示信息而非崩溃。
/// 对标原版：MOBI 格式通过第三方库读取（本项目计划在后续阶段实现）。
class MobiParser implements BaseLocalBookParser {
  @override
  Future<void> updateBookInfo(Book book) async {
    // MOBI 元数据可从文件名中提取
    final title = book.originName.replaceAll(RegExp(r'\.(mobi|azw3|azw)$', caseSensitive: false), '');
    book = book.copyWith(
      name: book.name.isNotEmpty ? book.name : title,
      intro: 'MOBI 格式暂不支持阅读。请使用 EPUB 或 TXT 格式替代。',
    );
  }

  @override
  Future<List<BookChapter>> getChapterList(Book book) async {
    return [];
  }

  @override
  Future<String?> getContent(Book book, BookChapter chapter) async {
    return 'MOBI 格式暂不支持阅读。请使用 EPUB 或 TXT 格式替代。';
  }

  @override
  Future<List<int>?> getResource(Book book, String href) async {
    return null;
  }
}

/// UMD 格式占位解析器
///
/// 当前 phase 暂未实现 UMD 格式解析。
class UmdParser implements BaseLocalBookParser {
  @override
  Future<void> updateBookInfo(Book book) async {
    final title = book.originName.replaceAll(RegExp(r'\.umd$', caseSensitive: false), '');
    book = book.copyWith(
      name: book.name.isNotEmpty ? book.name : title,
      intro: 'UMD 格式暂不支持阅读。请使用 EPUB 或 TXT 格式替代。',
    );
  }

  @override
  Future<List<BookChapter>> getChapterList(Book book) async {
    return [];
  }

  @override
  Future<String?> getContent(Book book, BookChapter chapter) async {
    return 'UMD 格式暂不支持阅读。请使用 EPUB 或 TXT 格式替代。';
  }

  @override
  Future<List<int>?> getResource(Book book, String href) async {
    return null;
  }
}
