import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'layout_models.dart';
import 'text_page_builder.dart';

/// 分页排版状态
class PageLayoutState {
  /// 当前章节的排版结果（所有页）
  final ChapterLayout? layout;

  /// 是否正在排版中
  final bool isLayouting;

  /// 当前章节索引
  final int chapterIndex;

  /// 当前页索引（在当章内）
  final int pageIndex;

  /// 错误信息
  final String? error;

  const PageLayoutState({
    this.layout,
    this.isLayouting = false,
    this.chapterIndex = 0,
    this.pageIndex = 0,
    this.error,
  });

  PageLayoutState copyWith({
    ChapterLayout? layout,
    bool? isLayouting,
    int? chapterIndex,
    int? pageIndex,
    String? error,
  }) {
    return PageLayoutState(
      layout: layout ?? this.layout,
      isLayouting: isLayouting ?? this.isLayouting,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      pageIndex: pageIndex ?? this.pageIndex,
      error: error,
    );
  }

  /// 当前页
  TextPage? get currentPage {
    if (layout == null || layout!.pages.isEmpty) return null;
    if (pageIndex < 0 || pageIndex >= layout!.pages.length) return null;
    return layout!.pages[pageIndex];
  }

  /// 是否有上一页
  bool get hasPreviousPage => pageIndex > 0;

  /// 是否有下一页
  bool get hasNextPage =>
      layout != null && pageIndex < layout!.pages.length - 1;

  /// 阅读进度字符串
  String get progressText {
    if (layout == null || layout!.pageCount == 0) return '';
    return '${pageIndex + 1}/${layout!.pageCount}';
  }
}

/// 分页排版状态管理器
///
/// 接收原始文本和生产配置，输出分页结果
class PageLayoutProvider extends StateNotifier<PageLayoutState> {
  LayoutConfig _config;
  TextStyle _textStyle;

  // 缓存已排版的章节结果，key = "chapterIndex_textHash"
  final Map<String, ChapterLayout> _layoutCache = {};

  PageLayoutProvider({
    required LayoutConfig config,
    required TextStyle textStyle,
  })  : _config = config,
        _textStyle = textStyle,
        super(const PageLayoutState());

  /// 更新排版配置（字号/行高/边距变化时调用）
  void updateConfig({
    LayoutConfig? config,
    TextStyle? textStyle,
  }) {
    if (config != null) _config = config;
    if (textStyle != null) _textStyle = textStyle;
    // 配置变化，清空缓存并请求重排
    _layoutCache.clear();
  }

  /// 排版并加载章节
  Future<void> layoutChapter({
    required String text,
    required int chapterIndex,
    required int chapterCount,
    required String chapterTitle,
    int targetPageIndex = 0,
  }) async {
    state = state.copyWith(
      isLayouting: true,
      chapterIndex: chapterIndex,
      pageIndex: targetPageIndex,
      error: null,
    );

    try {
      // 检查缓存
      final cacheKey = '$chapterIndex:${text.length}';
      ChapterLayout? layout = _layoutCache[cacheKey];

      if (layout == null) {
        // 异步排版
        layout = await _buildLayoutAsync(
          text: text,
          chapterIndex: chapterIndex,
          chapterCount: chapterCount,
          chapterTitle: chapterTitle,
        );
        _layoutCache[cacheKey] = layout;
      }

      final pageIndex = targetPageIndex.clamp(0, layout.pageCount - 1);

      state = state.copyWith(
        layout: layout,
        isLayouting: false,
        pageIndex: pageIndex,
      );
    } catch (e) {
      state = state.copyWith(
        isLayouting: false,
        error: '排版失败: $e',
      );
    }
  }

  /// 跳转到指定页
  void goToPage(int pageIndex) {
    if (state.layout == null) return;
    final clamped = pageIndex.clamp(0, state.layout!.pageCount - 1);
    state = state.copyWith(pageIndex: clamped);
  }

  /// 上一页
  void previousPage() {
    if (state.hasPreviousPage) {
      goToPage(state.pageIndex - 1);
    }
  }

  /// 下一页
  void nextPage() {
    if (state.hasNextPage) {
      goToPage(state.pageIndex + 1);
    }
  }

  /// 在后台线程中执行排版（避免阻塞 UI）
  Future<ChapterLayout> _buildLayoutAsync({
    required String text,
    required int chapterIndex,
    required int chapterCount,
    required String chapterTitle,
  }) async {
    // 如果文本为空，返回空排版结果
    if (text.isEmpty) {
      return ChapterLayout(isCompleted: true);
    }

    // 创建排版器
    final builder = TextPageBuilder(
      config: _config,
      textStyle: _textStyle,
    );

    // 执行排版
    final layout = builder.buildLayout(
      text: text,
      chapterIndex: chapterIndex,
      chapterCount: chapterCount,
      chapterTitle: chapterTitle,
    );

    // 修正 pageCount（构建时不知道总页数）
    final pages = layout.pages.map((page) {
      return TextPage(
        index: page.index,
        chapterIndex: page.chapterIndex,
        chapterPageCount: layout.pageCount,
        chapterTitle: page.chapterTitle,
        lines: page.lines,
        text: page.text,
        height: page.height,
      );
    }).toList();

    return ChapterLayout(
      pages: pages,
      pageCount: pages.length,
      totalChars: layout.totalChars,
      isCompleted: true,
    );
  }

  /// 清空缓存
  void clearCache() {
    _layoutCache.clear();
  }
}

/// 分页排版状态提供者
///
/// 注意：请使用 [pageLayoutProvider.family] 传入 config 和 textStyle。
/// 裸调用会返回一个空的 fallback 状态，不会崩溃。
final pageLayoutProvider =
    StateNotifierProvider<PageLayoutProvider, PageLayoutState>((ref) {
  // 提供一个安全的 fallback 实例，避免在生产环境下意外创建时崩溃
  final safeConfig = LayoutConfig(
    width: 360,
    height: 640,
    padding: EdgeInsets.zero,
    fontSize: 16,
    lineHeight: 1.5,
  );
  return PageLayoutProvider(config: safeConfig, textStyle: const TextStyle());
});
