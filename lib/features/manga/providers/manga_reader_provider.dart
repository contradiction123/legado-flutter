import 'package:flutter_riverpod/legacy.dart';

import '../engine/manga_parser.dart';
import '../models/manga_models.dart';

/// 漫画阅读器状态管理
class MangaReaderProvider extends StateNotifier<MangaReaderState> {
  MangaReaderProvider() : super(const MangaReaderState());

  /// 加载章节列表
  void loadChapters(List<MangaChapter> chapters) {
    state = state.copyWith(
      chapters: chapters,
      currentChapterIndex: 0,
      currentPageIndex: 0,
      isLoading: false,
    );
  }

  /// 跳转到指定章节
  void goToChapter(int index) {
    if (index < 0 || index >= state.chapters.length) return;
    state = state.copyWith(currentChapterIndex: index, currentPageIndex: 0);
  }

  /// 跳转到指定页
  void goToPage(int pageIndex) {
    final ch = state.currentChapter;
    if (ch == null) return;
    final clamped = pageIndex.clamp(0, ch.pages.length - 1);
    state = state.copyWith(currentPageIndex: clamped);
  }

  /// 下一页
  void nextPage() {
    final ch = state.currentChapter;
    if (ch == null) return;

    if (state.currentPageIndex < ch.pages.length - 1) {
      goToPage(state.currentPageIndex + 1);
    } else if (state.hasNextChapter) {
      goToChapter(state.currentChapterIndex + 1);
    }
  }

  /// 上一页
  void prevPage() {
    if (state.currentPageIndex > 0) {
      goToPage(state.currentPageIndex - 1);
    } else if (state.hasPrevChapter) {
      final prevCh = state.chapters[state.currentChapterIndex - 1];
      goToChapter(state.currentChapterIndex - 1);
      goToPage(prevCh.pages.length - 1);
    }
  }

  /// 切换阅读模式
  void setReadMode(MangaReadMode mode) {
    state = state.copyWith(config: state.config.copyWith(readMode: mode));
  }

  /// 切换翻页方向
  void setDirection(MangaDirection dir) {
    state = state.copyWith(config: state.config.copyWith(direction: dir));
  }

  /// 切换双页模式
  void toggleDoublePage() {
    final newMode = state.config.readMode == MangaReadMode.doublePage
        ? MangaReadMode.singlePage
        : MangaReadMode.doublePage;
    setReadMode(newMode);
  }

  /// 切换画廊模式
  void toggleGallery() {
    final newMode = state.config.readMode == MangaReadMode.gallery
        ? MangaReadMode.singlePage
        : MangaReadMode.gallery;
    setReadMode(newMode);
  }

  /// 切换适应屏幕
  void toggleFitToScreen() {
    state = state.copyWith(
      config: state.config.copyWith(fitToScreen: !state.config.fitToScreen),
    );
  }
}

final mangaReaderProvider =
    StateNotifierProvider<MangaReaderProvider, MangaReaderState>(
      (ref) => MangaReaderProvider(),
    );
