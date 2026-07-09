import '../../engine/local_book/base_parser.dart';
import '../models/book.dart';

/// 书籍格式检测工具扩展
extension BookFormatX on Book {
  /// 是否为本地书籍
  bool get isLocalBook => origin == 'loc_book';

  /// 检测书籍格式
  BookFormat get bookFormat {
    // 优先使用 type 字段判断
    if (type & 256 != 0) {
      // local bit set — 根据 originName 扩展名判断
      return detectFormat(originName);
    }

    // 尝试从 origin 判断
    if (isLocalBook) {
      return detectFormat(originName);
    }

    return BookFormat.unknown;
  }

  /// 获取阅读器路由路径
  String get readerRoute {
    switch (bookFormat) {
      case BookFormat.epub:
        return '/epub-reader';
      case BookFormat.pdf:
        return '/pdf-reader';
      case BookFormat.txt:
      case BookFormat.mobi:
      case BookFormat.umd:
      case BookFormat.unknown:
        return '/reader';
    }
  }
}
