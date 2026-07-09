/// 漫画页面模型
class MangaPage {
  final int index;
  final String imageUrl;
  final String? chapterId;
  final double? width;
  final double? height;

  const MangaPage({
    required this.index,
    required this.imageUrl,
    this.chapterId,
    this.width,
    this.height,
  });
}

/// 漫画章节
class MangaChapter {
  final String id;
  final String title;
  final List<MangaPage> pages;
  final int index;

  const MangaChapter({
    required this.id,
    required this.title,
    this.pages = const [],
    this.index = 0,
  });
}

/// 漫画阅读模式
enum MangaReadMode {
  /// 单页横向翻页
  singlePage,

  /// 双页并排展示
  doublePage,

  /// 滚动画廊（纵向连续）
  gallery,
}

/// 漫画翻页方向
enum MangaDirection {
  /// 从左到右（默认）
  ltr,

  /// 从右到左（日漫）
  rtl,
}

/// 漫画阅读器配置
class MangaConfig {
  final MangaReadMode readMode;
  final MangaDirection direction;
  final bool fitToScreen;
  final bool showPageNumber;

  const MangaConfig({
    this.readMode = MangaReadMode.singlePage,
    this.direction = MangaDirection.ltr,
    this.fitToScreen = true,
    this.showPageNumber = true,
  });

  MangaConfig copyWith({
    MangaReadMode? readMode,
    MangaDirection? direction,
    bool? fitToScreen,
    bool? showPageNumber,
  }) {
    return MangaConfig(
      readMode: readMode ?? this.readMode,
      direction: direction ?? this.direction,
      fitToScreen: fitToScreen ?? this.fitToScreen,
      showPageNumber: showPageNumber ?? this.showPageNumber,
    );
  }
}

/// 漫画阅读状态
class MangaReaderState {
  final List<MangaChapter> chapters;
  final int currentChapterIndex;
  final int currentPageIndex;
  final MangaConfig config;
  final bool isLoading;
  final String? error;

  const MangaReaderState({
    this.chapters = const [],
    this.currentChapterIndex = 0,
    this.currentPageIndex = 0,
    this.config = const MangaConfig(),
    this.isLoading = false,
    this.error,
  });

  MangaReaderState copyWith({
    List<MangaChapter>? chapters,
    int? currentChapterIndex,
    int? currentPageIndex,
    MangaConfig? config,
    bool? isLoading,
    String? error,
  }) {
    return MangaReaderState(
      chapters: chapters ?? this.chapters,
      currentChapterIndex: currentChapterIndex ?? this.currentChapterIndex,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      config: config ?? this.config,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  MangaChapter? get currentChapter =>
      chapters.isNotEmpty && currentChapterIndex < chapters.length
          ? chapters[currentChapterIndex]
          : null;

  MangaPage? get currentPage {
    final ch = currentChapter;
    if (ch == null || currentPageIndex >= ch.pages.length) return null;
    return ch.pages[currentPageIndex];
  }

  bool get hasNextChapter => currentChapterIndex < chapters.length - 1;
  bool get hasPrevChapter => currentChapterIndex > 0;

  String get progressText {
    final ch = currentChapter;
    if (ch == null) return '';
    return '${currentPageIndex + 1}/${ch.pages.length} ${ch.title}';
  }
}
