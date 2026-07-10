import '../models/manga_models.dart';

/// 漫画解析器
///
/// 负责从各种来源提取漫画页面列表：
/// - 本地图片文件夹（.jpg/.png 文件）
/// - ZIP/CBR 压缩包中的图片
/// - 网络漫画源（通过 JS 分析提取图片 URL）
class MangaParser {
  /// 从文件名数组创建漫画章节
  /// 每个文件名对应一个图片路径
  static MangaChapter createChapterFromFiles({
    required String chapterId,
    required String title,
    required List<String> imageFiles,
    int index = 0,
  }) {
    final pages = imageFiles.asMap().entries.map((entry) {
      return MangaPage(
        index: entry.key,
        imageUrl: entry.value,
        chapterId: chapterId,
      );
    }).toList();

    return MangaChapter(
      id: chapterId,
      title: title,
      pages: pages,
      index: index,
    );
  }

  /// 从 ZIP/CBR 文件中的图片列表创建章节
  /// entries: zip 内的文件路径列表（已筛选为图片）
  static MangaChapter createChapterFromArchive({
    required String chapterId,
    required String title,
    required String archivePath,
    required List<String> entries,
    int index = 0,
  }) {
    final pages = entries.asMap().entries.map((entry) {
      final imageUrl = 'archive://$archivePath?file=${entry.value}';
      return MangaPage(
        index: entry.key,
        imageUrl: imageUrl,
        chapterId: chapterId,
      );
    }).toList();

    return MangaChapter(
      id: chapterId,
      title: title,
      pages: pages,
      index: index,
    );
  }

  /// 从网络 URL 列表创建章节
  static MangaChapter createChapterFromUrls({
    required String chapterId,
    required String title,
    required List<String> imageUrls,
    int index = 0,
  }) {
    final pages = imageUrls.asMap().entries.map((entry) {
      return MangaPage(
        index: entry.key,
        imageUrl: entry.value,
        chapterId: chapterId,
      );
    }).toList();

    return MangaChapter(
      id: chapterId,
      title: title,
      pages: pages,
      index: index,
    );
  }

  /// 支持的图片扩展名
  static const Set<String> imageExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
    '.bmp',
  };

  /// 判断文件名是否为图片
  static bool isImageFile(String fileName) {
    final ext = fileName.substring(fileName.lastIndexOf('.')).toLowerCase();
    return imageExtensions.contains(ext);
  }

  /// 从文件列表过滤出图片文件并按数字排序
  static List<String> filterAndSortImages(List<String> files) {
    final images = files.where(isImageFile).toList();
    images.sort(_naturalCompare);
    return images;
  }

  /// 自然排序（1.jpg, 2.jpg, ..., 10.jpg）
  static int _naturalCompare(String a, String b) {
    final aNum = _extractNumber(a);
    final bNum = _extractNumber(b);
    if (aNum != null && bNum != null) return aNum.compareTo(bNum);
    return a.compareTo(b);
  }

  static int? _extractNumber(String name) {
    final match = RegExp(r'(\d+)').firstMatch(name);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }
}
