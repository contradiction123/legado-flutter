/// 书籍类型常量（独立文件，方便导入不产生循环引用）
///
/// 对标原：BookType.kt（常量部分）
class BookTypeConst {
  static const int text = 8;
  static const int audio = 32;
  static const int image = 64;
  static const int video = 4;
  static const int local = 256;
  static const int updateError = 16;
  static const int notShelf = 1024;
}
