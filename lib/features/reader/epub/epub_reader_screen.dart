import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/book.dart';
import '../../../domain/models/book_chapter.dart';
import '../../../engine/local_book/epub/epub_file_parser.dart';
import 'providers/epub_reader_provider.dart';
import 'widgets/epub_chapter_view.dart';

/// EPUB 读者阅读页面
///
/// 使用 WebView 渲染 EPUB 章节 HTML 内容。
/// 对标原版：ReadBookScreen.kt（EPUB 模式）
class EpubReaderScreen extends ConsumerStatefulWidget {
  final Book book;

  const EpubReaderScreen({super.key, required this.book});

  @override
  ConsumerState<EpubReaderScreen> createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends ConsumerState<EpubReaderScreen> {
  bool _isMenuVisible = false;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // 全屏沉浸模式
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(epubReaderProvider(widget.book));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),
      body: Stack(
        children: [
          // 阅读内容
          _buildContent(state),

          // 菜单层
          if (_isMenuVisible) ...[_buildAppBar(state), _buildBottomBar(state)],

          // 点击区域
          _buildTapOverlay(state),
        ],
      ),
    );
  }

  Widget _buildContent(EpubReaderState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            state.error!,
            style: const TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.htmlContents.isEmpty) {
      return const Center(
        child: Text('暂无内容', style: TextStyle(color: Colors.black54)),
      );
    }

    // 使用 PageView 横向翻页（章节级别）
    return PageView.builder(
      controller: _pageController,
      itemCount: state.htmlContents.length,
      onPageChanged: (index) {
        ref.read(epubReaderProvider(widget.book).notifier).goToChapter(index);
      },
      itemBuilder: (context, index) {
        final htmlContent = state.htmlContents[index];
        return EpubChapterView(
          htmlContent: htmlContent,
          themeConfig: const ReaderThemeConfig(
            bgColor: Color(0xFFF5F0E6),
            textColor: Color(0xFF3A3A3A),
          ),
          onContentTapped: () =>
              setState(() => _isMenuVisible = !_isMenuVisible),
        );
      },
    );
  }

  Widget _buildTapOverlay(EpubReaderState state) {
    return Positioned.fill(
      child: Row(
        children: [
          // 左侧：上一章
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (_isMenuVisible) {
                  setState(() => _isMenuVisible = false);
                } else {
                  if (_pageController.hasClients && _pageController.page! > 0) {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  }
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          // 中间：切换菜单
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => setState(() => _isMenuVisible = !_isMenuVisible),
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          // 右侧：下一章
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (_isMenuVisible) {
                  setState(() => _isMenuVisible = false);
                } else if (_pageController.hasClients &&
                    _pageController.page! < state.htmlContents.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(EpubReaderState state) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          color: const Color(0xFFF5F0E6).withValues(alpha: 0.95),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: const Color(0xFF3A3A3A),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(state.bookTitle, style: const TextStyle(fontSize: 16)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.list_alt_outlined),
                tooltip: '目录',
                onPressed: () => _showChapterList(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(EpubReaderState state) {
    final currentChapter = state.currentChapterIndex < state.chapters.length
        ? state.chapters[state.currentChapterIndex]
        : null;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          color: const Color(0xFFF5F0E6).withValues(alpha: 0.95),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentChapter?.title ?? '',
                style: const TextStyle(color: Color(0xFF3A3A3A), fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                state.progressText,
                style: const TextStyle(color: Color(0xFF3A3A3A), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChapterList(EpubReaderState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF5F0E6),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '目录 (${state.chapters.length} 章)',
                style: const TextStyle(color: Color(0xFF3A3A3A), fontSize: 16),
              ),
            ),
            const Divider(color: Color(0xFF3A3A3A), height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.chapters.length,
                itemBuilder: (context, index) {
                  final chapter = state.chapters[index];
                  final isCurrent = index == state.currentChapterIndex;
                  return ListTile(
                    dense: true,
                    selected: isCurrent,
                    selectedTileColor: const Color(
                      0xFF3A3A3A,
                    ).withValues(alpha: 0.1),
                    title: Text(
                      chapter.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF3A3A3A),
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
