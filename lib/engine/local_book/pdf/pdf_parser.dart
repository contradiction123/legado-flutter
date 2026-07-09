import 'dart:io';

import 'package:pdfx/pdfx.dart';

import '../../../domain/models/book.dart';
import '../../../domain/models/book_chapter.dart';
import '../base_parser.dart';

/// PDF 文件解析器
///
/// 对标原版：PdfFile.kt
/// 使用 pdfx 包（底层封装 Android PdfRenderer / iOS PDFKit）
///
/// ### 章节映射策略
/// 原版将每 10 个 PDF 页合并为一个"章节"（PAGE_SIZE=10）。
/// 我们采用相同的策略，每页对应一个"章节"，用 pageIndex 引用。
class PdfParser implements BaseLocalBookParser {
  static const int pageSize = 10;

  /// 缓存的 PdfDocument 实例，避免重复打开文件
  PdfDocument? _document;
  int _pageCount = 0;
  String? _cachedBookUrl;

  /// 直接打开文件路径（无需 Book 对象）
  Future<void> openFile(String filePath) async {
    await _ensureDocument(filePath);
  }

  @override
  Future<void> updateBookInfo(Book book) async {
    await openFile(book.bookUrl);
  }

  @override
  Future<List<BookChapter>> getChapterList(Book book) async {
    await openFile(book.bookUrl);
    if (_pageCount <= 0) return [];

    final chapters = <BookChapter>[];
    final chapterCount = (_pageCount / pageSize).ceil();

    for (var i = 0; i < chapterCount; i++) {
      final startPage = i * pageSize;
      final endPage = ((i + 1) * pageSize).clamp(0, _pageCount);

      chapters.add(BookChapter(
        url: 'pdf_$i',
        title: '第 ${startPage + 1}-${endPage} 页',
        baseUrl: book.bookUrl,
        bookUrl: book.bookUrl,
        index: i,
        start: startPage,
        end: endPage - 1,
        isVolume: false,
        isVip: false,
        isPay: false,
      ));
    }

    return chapters;
  }

  @override
  Future<String?> getContent(Book book, BookChapter chapter) async {
    await openFile(book.bookUrl);
    final start = chapter.start ?? (chapter.index * pageSize);
    final end = ((chapter.index + 1) * pageSize).clamp(0, _pageCount);

    final sb = StringBuffer();
    for (var i = start; i < end; i++) {
      sb.writeln('<img src="$i" />');
    }
    return sb.toString();
  }

  @override
  Future<List<int>?> getResource(Book book, String href) async {
    return null;
  }

  /// 渲染指定 PDF 页面为图片字节
  Future<List<int>?> renderPage(int pageIndex, {double width = 1080}) async {
    if (_document == null) return null;
    if (pageIndex < 0 || pageIndex >= _pageCount) return null;

    try {
      final page = await _document!.getPage(pageIndex);
      final pageWidth = page.width;
      final pageHeight = page.height;
      final renderWidth = width;
      final renderHeight = pageHeight * (renderWidth / pageWidth);

      final image = await page.render(
        width: renderWidth,
        height: renderHeight,
        format: PdfPageImageFormat.jpeg,
        quality: 85,
      );
      await page.close();

      if (image == null) return null;
      return image.bytes;
    } catch (e) {
      return null;
    }
  }

  /// 获取总页数
  int get pageCount => _pageCount;

  /// 确保 Document 已打开
  Future<void> _ensureDocument(String bookUrl) async {
    if (_document != null && _cachedBookUrl == bookUrl) return;

    await _document?.close();
    _document = null;
    _pageCount = 0;

    final file = File(bookUrl);
    if (!await file.exists()) {
      throw FileSystemException('PDF file not found', bookUrl);
    }

    _document = await PdfDocument.openFile(bookUrl);
    _pageCount = _document!.pagesCount;
    _cachedBookUrl = bookUrl;
  }

  /// 释放资源
  Future<void> close() async {
    await _document?.close();
    _document = null;
    _pageCount = 0;
    _cachedBookUrl = null;
  }
}
