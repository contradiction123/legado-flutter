/// 应用级常量定义
///
/// 对标原：AppConst.kt
class AppConstants {
  static const String appName = 'Legado';
  static const String databaseName = 'legado.db';
  static const String defaultCharset = 'UTF-8';
  static const String defaultUserAgent =
      'Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';
  static const String localTag = 'loc_book';
  static const String webDavTag = 'webDav::';
}

/// 书籍类型常量
///
/// 对标原：BookType.kt
class BookType {
  static const int video = 4;
  static const int text = 8;
  static const int updateError = 16;
  static const int audio = 32;
  static const int image = 64;
  static const int webFile = 128;
  static const int local = 256;
  static const int archive = 512;
  static const int notShelf = 1024;

  static const int allBookType = text | image | audio | webFile;
  static const int allBookTypeLocal = text | image | audio | webFile | local;
}
