import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/manga_models.dart';
import '../providers/manga_reader_provider.dart';
import '../widgets/manga_page_view.dart';

/// 漫画阅读页面
///
/// 对标原版：ReadMangaActivity.kt
/// 支持：单页/双页/画廊模式 / LTR/RTL翻页 / 缩放 / 页码切换
class MangaReaderScreen extends ConsumerStatefulWidget {
  /// 漫画章节列表（预加载的测试数据或传入数据）
  final List<MangaChapter>? chapters;

  const MangaReaderScreen({super.key, this.chapters});

  @override
  ConsumerState<MangaReaderScreen> createState() => _MangaReaderScreenState();
}

class _MangaReaderScreenState extends ConsumerState<MangaReaderScreen> {
  late PageController _pageController;
  final ScrollController _galleryController = ScrollController();
  bool _isMenuVisible = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // 如果有预设章节数据，加载到 Provider
    final provider = ref.read(mangaReaderProvider.notifier);
    if (widget.chapters != null && widget.chapters!.isNotEmpty) {
      provider.loadChapters(widget.chapters!);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _galleryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mangaReaderProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 正文内容
          _buildContent(state),

          // 菜单层
          if (_isMenuVisible) ...[
            _buildTopBar(state, theme),
            _buildBottomBar(state, theme),
          ],

          // 翻页触摸区域（非画廊模式）
          if (state.config.readMode != MangaReadMode.gallery)
            _buildTapOverlay(state),
        ],
      ),
    );
  }

  Widget _buildContent(MangaReaderState state) {
    final ch = state.currentChapter;
    if (ch == null) {
      return const Center(
        child: Text('暂无内容', style: TextStyle(color: Colors.white54)),
      );
    }

    final mode = state.config.readMode;

    switch (mode) {
      case MangaReadMode.gallery:
        return _buildGalleryView(ch);
      case MangaReadMode.doublePage:
        return _buildDoublePageView(ch, state);
      case MangaReadMode.singlePage:
        return _buildSinglePageView(ch, state);
    }
  }

  /// 单页模式
  Widget _buildSinglePageView(MangaChapter ch, MangaReaderState state) {
    final isRtl = state.config.direction == MangaDirection.rtl;
    // RTL时需要翻转 pages
    final pages = isRtl ? ch.pages.reversed.toList() : ch.pages;

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemCount: pages.length,
      onPageChanged: (page) {
        final actualPage = isRtl ? pages.length - 1 - page : page;
        ref.read(mangaReaderProvider.notifier).goToPage(actualPage);
      },
      itemBuilder: (context, index) {
        final page = pages[index];
        return MangaPageView(
          imageUrl: page.imageUrl,
          fitToScreen: state.config.fitToScreen,
          onTap: () => setState(() => _isMenuVisible = !_isMenuVisible),
        );
      },
    );
  }

  /// 双页模式
  Widget _buildDoublePageView(MangaChapter ch, MangaReaderState state) {
    final isRtl = state.config.direction == MangaDirection.rtl;
    final pages = isRtl ? ch.pages.reversed.toList() : ch.pages;
    // 每2页一组
    final groupedPages = <List<MangaPage>>[];
    for (var i = 0; i < pages.length; i += 2) {
      final group = [pages[i]];
      if (i + 1 < pages.length) group.add(pages[i + 1]);
      groupedPages.add(group);
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: groupedPages.length,
      onPageChanged: (page) {
        final actualPage = isRtl ? pages.length - 1 - page * 2 : page * 2;
        ref
            .read(mangaReaderProvider.notifier)
            .goToPage(actualPage.clamp(0, pages.length - 1));
      },
      itemBuilder: (context, index) {
        final group = groupedPages[index];
        return Row(
          children: group.map((page) {
            return Expanded(
              child: MangaPageView(
                imageUrl: page.imageUrl,
                fitToScreen: state.config.fitToScreen,
                onTap: () => setState(() => _isMenuVisible = !_isMenuVisible),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  /// 画廊模式（连续滚动）
  Widget _buildGalleryView(MangaChapter ch) {
    return ListView.builder(
      controller: _galleryController,
      itemCount: ch.pages.length,
      itemBuilder: (context, index) {
        final page = ch.pages[index];
        return GestureDetector(
          onTap: () => setState(() => _isMenuVisible = !_isMenuVisible),
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 5.0,
            child: Image.network(
              page.imageUrl,
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return const SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white38),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => const SizedBox(
                height: 200,
                child: Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white24,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTapOverlay(MangaReaderState state) {
    final isRtl = state.config.direction == MangaDirection.rtl;

    return Positioned.fill(
      child: Row(
        children: [
          // 左侧 ← 上一页/上一章
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (_isMenuVisible) {
                  setState(() => _isMenuVisible = false);
                } else if (isRtl) {
                  ref.read(mangaReaderProvider.notifier).nextPage();
                } else {
                  ref.read(mangaReaderProvider.notifier).prevPage();
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          // 中间 — 切换菜单
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => setState(() => _isMenuVisible = !_isMenuVisible),
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          // 右侧 → 下一页/下一章
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (_isMenuVisible) {
                  setState(() => _isMenuVisible = false);
                } else if (isRtl) {
                  ref.read(mangaReaderProvider.notifier).prevPage();
                } else {
                  ref.read(mangaReaderProvider.notifier).nextPage();
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

  Widget _buildTopBar(MangaReaderState state, ThemeData theme) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          color: Colors.black87,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              state.currentChapter?.title ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.list_alt_outlined,
                  color: Colors.white70,
                ),
                tooltip: '章节',
                onPressed: () => _showChapterList(state),
              ),
              IconButton(
                icon: Icon(
                  state.config.readMode == MangaReadMode.gallery
                      ? Icons.view_carousel
                      : Icons.view_stream,
                  color: Colors.white70,
                ),
                tooltip: '切换模式',
                onPressed: () =>
                    ref.read(mangaReaderProvider.notifier).toggleGallery(),
              ),
              IconButton(
                icon: Icon(
                  state.config.fitToScreen
                      ? Icons.fit_screen
                      : Icons.photo_size_select_actual,
                  color: Colors.white70,
                ),
                tooltip: '适应屏幕',
                onPressed: () =>
                    ref.read(mangaReaderProvider.notifier).toggleFitToScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(MangaReaderState state, ThemeData theme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          color: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 页码进度
              Text(
                state.progressText,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 8),
              // 页码滑动条
              Slider(
                value: state.currentPageIndex.toDouble(),
                min: 0,
                max: (state.currentChapter?.pages.length ?? 1).toDouble().clamp(
                  1,
                  double.infinity,
                ),
                activeColor: theme.colorScheme.primary,
                inactiveColor: Colors.white24,
                onChanged: (v) {
                  ref.read(mangaReaderProvider.notifier).goToPage(v.round());
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: state.hasPrevChapter
                        ? () => ref
                              .read(mangaReaderProvider.notifier)
                              .goToChapter(state.currentChapterIndex - 1)
                        : null,
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Colors.white54,
                      size: 18,
                    ),
                    label: const Text(
                      '上一章',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => ref
                        .read(mangaReaderProvider.notifier)
                        .toggleDoublePage(),
                    icon: Icon(
                      state.config.readMode == MangaReadMode.doublePage
                          ? Icons.filter_none
                          : Icons.crop_square,
                      color: Colors.white54,
                      size: 18,
                    ),
                    label: Text(
                      state.config.readMode == MangaReadMode.doublePage
                          ? '单页'
                          : '双页',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: state.hasNextChapter
                        ? () => ref
                              .read(mangaReaderProvider.notifier)
                              .goToChapter(state.currentChapterIndex + 1)
                        : null,
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.white54,
                      size: 18,
                    ),
                    label: const Text(
                      '下一章',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChapterList(MangaReaderState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '章节列表 (${state.chapters.length})',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.chapters.length,
                itemBuilder: (context, index) {
                  final ch = state.chapters[index];
                  final isCurrent = index == state.currentChapterIndex;
                  return ListTile(
                    dense: true,
                    selected: isCurrent,
                    selectedTileColor: Colors.white12,
                    title: Text(
                      ch.title,
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      '${ch.pages.length} 页',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(mangaReaderProvider.notifier).goToChapter(index);
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
