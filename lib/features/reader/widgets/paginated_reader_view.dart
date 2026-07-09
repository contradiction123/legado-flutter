import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_style.dart';
import '../../../domain/models/book.dart';
import '../config/reader_config_provider.dart';
import '../layout/layout_barrel.dart';
import '../providers/reader_provider.dart';
import '../providers/replace_rule_provider.dart';
import '../services/replace_rule_service.dart';

/// 分页阅读视图
///
/// 将 ReaderState 中[指定章节]的原始文本，通过分页排版引擎拆分为多页后展示。
/// 通过 [chapterIndex] 指定渲染哪个章节，配合 [key: ValueKey] 确保在
/// 外层 PageView 切换章节时重建独立 State，避免翻页状态串扰。
///
/// 核心流程：
///   1. 接收到章节内容后，调用 TextPageBuilder 分页
///   2. 结果缓存到 _layoutCache，避免重复排版
///   3. 用 PageViewSelector 进行翻页
///
/// 注意：替换规则（ReplaceRule）已在 ReaderProvider.loadChapter() 中应用，
/// 传入 content 时已处理。此处不再重复应用。
class PaginatedReaderView extends ConsumerStatefulWidget {
  final Book book;
  final int chapterIndex;

  const PaginatedReaderView({
    super.key,
    required this.book,
    required this.chapterIndex,
  });

  @override
  ConsumerState<PaginatedReaderView> createState() =>
      _PaginatedReaderViewState();
}

class _PaginatedReaderViewState extends ConsumerState<PaginatedReaderView> {
  /// 展平的总页列表 [pageIndex]
  final List<_PageRef> _flatPages = [];

  /// 当前展平索引
  int _flatIndex = 0;

  /// 当前正在排版的章节索引
  int _layoutingChapterIndex = -1;

  /// 排版缓存 key=chapterIndex, value=TextPage 列表
  final Map<int, List<TextPage>> _layoutCache = {};

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(readerProvider(widget.book));

    // 监听章节切换，触发排版
    _ensureLayout(state);

    if (state.isLoadingChapters) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: AppStyle.pagePadding,
          child: Text(
            state.error!,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.chapters.isEmpty) {
      return const Center(
        child: Text('暂无章节', style: TextStyle(color: Colors.white70)),
      );
    }

    // 内容已加载但排版未完成
    if (_flatPages.isEmpty && _layoutingChapterIndex >= 0) {
      return const Center(child: CircularProgressIndicator());
    }

    // 内容和排版都就绪，渲染页面
    return _buildReaderContent(state);
  }

  void _ensureLayout(ReaderState state) {
    final ci = widget.chapterIndex;
    if (ci < 0 || ci >= state.chapters.length) return;

    // 已排版过该章且缓存命中 → 无需重建
    if (_layoutingChapterIndex == ci && _flatPages.isNotEmpty) return;

    // 检查是否有缓存可用
    if (_layoutCache.containsKey(ci)) {
      final cached = _layoutCache[ci]!;
      _layoutingChapterIndex = ci;
      _flatPages.clear();
      for (var i = 0; i < cached.length; i++) {
        _flatPages.add(_PageRef(chapterIndex: ci, pageIndex: i));
      }
      _flatIndex = 0;
      return;
    }

    // 触发排版
    _layoutingChapterIndex = ci;
    _flatPages.clear();
    _flatIndex = 0;

    // 检查是否有该章内容
    final content = state.contents[ci];
    if (content == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runLayout(state);
    });
  }

  void _runLayout(ReaderState state) {
    final config = ref.read(readerConfigProvider);
    final textStyle = TextStyle(
      fontSize: config.fontSize,
      color: config.theme.textColor,
      height: config.lineHeight,
    );

    final layoutConfig = LayoutConfig(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: config.margin,
      fontSize: config.fontSize,
      lineHeight: config.lineHeight,
    );

    final builder = TextPageBuilder(
      config: layoutConfig,
      textStyle: textStyle,
    );

    final ci = widget.chapterIndex;
    final content = state.contents[ci] ?? '';

    Future.microtask(() {
      final layout = builder.buildLayout(
        text: content,
        chapterIndex: ci,
        chapterCount: state.chapters.length,
        chapterTitle: state.chapters[ci].title,
      );

      if (!mounted) return;

      // 缓存排版结果
      _layoutCache[ci] = layout.pages;

      setState(() {
        _flatPages.clear();
        for (var i = 0; i < layout.pages.length; i++) {
          _flatPages.add(_PageRef(chapterIndex: ci, pageIndex: i));
        }
        _flatIndex = 0;
      });
    });
  }

  Widget _buildReaderContent(ReaderState state) {
    final config = ref.read(readerConfigProvider);
    final replaceState = ref.watch(replaceRuleProvider);

    final pageRef = _flatPages.isNotEmpty && _flatIndex < _flatPages.length
        ? _flatPages[_flatIndex]
        : null;

    if (pageRef == null) {
      return const Center(child: Text('排版中...'));
    }

    final chapterContent = state.contents[pageRef.chapterIndex];
    if (chapterContent == null) {
      return const Center(child: Text('加载中...'));
    }

    // 从缓存读取已排版文本，不再重建 TextPageBuilder
    final displayText = _getPageTextFromCache(pageRef, chapterContent, config);

    final ch = state.chapters[pageRef.chapterIndex];
    return _buildPageWidget(displayText, ch.title, config, replaceState, state);
  }

  /// 从布局缓存中读取指定页的文本，无需重复排版
  String _getPageTextFromCache(
    _PageRef pageRef,
    String fullContent,
    ReaderConfigState config,
  ) {
    final cachedPages = _layoutCache[pageRef.chapterIndex];
    if (cachedPages != null && pageRef.pageIndex < cachedPages.length) {
      return cachedPages[pageRef.pageIndex].text;
    }

    // 缓存未命中 → 重新排版并缓存
    final textStyle = TextStyle(
      fontSize: config.fontSize,
      color: config.theme.textColor,
      height: config.lineHeight,
    );
    final layoutConfig = LayoutConfig(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: config.margin,
      fontSize: config.fontSize,
      lineHeight: config.lineHeight,
    );

    final builder = TextPageBuilder(config: layoutConfig, textStyle: textStyle);
    final layout = builder.buildLayout(
      text: fullContent,
      chapterIndex: pageRef.chapterIndex,
      chapterCount: 999,
      chapterTitle: '',
    );

    // 缓存本次排版结果
    _layoutCache[pageRef.chapterIndex] = layout.pages;

    if (pageRef.pageIndex < layout.pages.length) {
      return layout.pages[pageRef.pageIndex].text;
    }
    return fullContent;
  }

  Widget _buildPageWidget(
    String content,
    String chapterTitle,
    ReaderConfigState config,
    ReplaceRuleState replaceState,
    ReaderState readerState,
  ) {
    final service = ReplaceRuleService();
    final displayContent = replaceState.replaceEnabled
        ? service.applyRules(
            content: content,
            rules: replaceState.enabledRules,
            chapterTitle: chapterTitle,
          )
        : content;

    return SingleChildScrollView(
      padding: config.margin,
      child: SelectableText(
        displayContent,
        style: TextStyle(
          color: config.theme.textColor,
          fontSize: config.fontSize,
          height: config.lineHeight,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _layoutCache.clear();
    super.dispose();
  }
}

/// 页面引用（章节索引 + 页索引）
class _PageRef {
  final int chapterIndex;
  final int pageIndex;

  const _PageRef({required this.chapterIndex, required this.pageIndex});
}
