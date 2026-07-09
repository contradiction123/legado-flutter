import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/book.dart';
import 'providers/pdf_reader_provider.dart';

/// PDF 阅读页面
///
/// 对标原版：PdfFile.kt getImage() + openPdfPage()
/// 使用 pdfx 渲染每一页为图片，通过 PageView + InteractiveViewer 展示
class PdfReaderScreen extends ConsumerStatefulWidget {
  final Book book;

  const PdfReaderScreen({super.key, required this.book});

  @override
  ConsumerState<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends ConsumerState<PdfReaderScreen> {
  final PageController _pageController = PageController();
  bool _isMenuVisible = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pdfReaderProvider(widget.book.bookUrl));

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Stack(
        children: [
          // PDF 页面内容
          _buildContent(state),

          // 菜单层
          if (_isMenuVisible) ...[
            _buildTopBar(state),
            _buildBottomBar(state),
          ],

          // 翻页触摸区域
          _buildTapOverlay(state),
        ],
      ),
    );
  }

  Widget _buildContent(PdfReaderState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white70),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            state.error!,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.pageCount == 0) {
      return const Center(
        child: Text('暂无内容', style: TextStyle(color: Colors.white70)),
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: state.pageCount,
      onPageChanged: (page) {
        ref.read(pdfReaderProvider(widget.book.bookUrl).notifier).goToPage(page);
      },
      itemBuilder: (context, index) {
        return _PdfPageView(
          filePath: widget.book.bookUrl,
          pageIndex: index,
          zoomLevel: state.zoomLevel,
          onTap: () => setState(() => _isMenuVisible = !_isMenuVisible),
        );
      },
    );
  }

  Widget _buildTapOverlay(PdfReaderState state) {
    return Positioned.fill(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (_isMenuVisible) {
                  setState(() => _isMenuVisible = false);
                } else if (_pageController.hasClients &&
                    _pageController.page! > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                  );
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => setState(() => _isMenuVisible = !_isMenuVisible),
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (_isMenuVisible) {
                  setState(() => _isMenuVisible = false);
                } else if (_pageController.hasClients &&
                    _pageController.page! < state.pageCount - 1) {
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

  Widget _buildTopBar(PdfReaderState state) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          color: const Color(0xFF1E1E1E).withValues(alpha: 0.95),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.book.name,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white70),
                tooltip: '跳转页码',
                onPressed: () => _showPageJump(state),
              ),
              IconButton(
                icon: const Icon(Icons.zoom_in, color: Colors.white70),
                tooltip: '放大',
                onPressed: () {
                  final notifier =
                      ref.read(pdfReaderProvider(widget.book.bookUrl).notifier);
                  notifier.setZoom(state.zoomLevel + 0.25);
                },
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out, color: Colors.white70),
                tooltip: '缩小',
                onPressed: () {
                  final notifier =
                      ref.read(pdfReaderProvider(widget.book.bookUrl).notifier);
                  notifier.setZoom(state.zoomLevel - 0.25);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(PdfReaderState state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Container(
          color: const Color(0xFF1E1E1E).withValues(alpha: 0.95),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white70),
                onPressed: state.hasPrevious
                    ? () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        )
                    : null,
              ),
              Text(
                state.progressText,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white70),
                onPressed: state.hasNext
                    ? () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPageJump(PdfReaderState state) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('跳转页码'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '1-${state.pageCount}',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final page = int.tryParse(controller.text);
              if (page != null && page >= 1 && page <= state.pageCount) {
                _pageController.animateToPage(
                  page - 1,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              }
              Navigator.pop(ctx);
            },
            child: const Text('跳转'),
          ),
        ],
      ),
    );
  }
}

/// PDF 单页渲染组件
///
/// 使用 InteractiveViewer 支持缩放和平移
class _PdfPageView extends ConsumerStatefulWidget {
  final String filePath;
  final int pageIndex;
  final double zoomLevel;
  final VoidCallback onTap;

  const _PdfPageView({
    required this.filePath,
    required this.pageIndex,
    required this.zoomLevel,
    required this.onTap,
  });

  @override
  ConsumerState<_PdfPageView> createState() => _PdfPageViewState();
}

class _PdfPageViewState extends ConsumerState<_PdfPageView> {
  Uint8List? _imageBytes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  @override
  void didUpdateWidget(_PdfPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageIndex != widget.pageIndex) {
      _isLoading = true;
      _imageBytes = null;
      _loadPage();
    }
  }

  Future<void> _loadPage() async {
    final bytes = await ref
        .read(pdfReaderProvider(widget.filePath).notifier)
        .renderPage(widget.pageIndex);
    if (!mounted) return;
    setState(() {
      _imageBytes = bytes;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white38),
      );
    }

    if (_imageBytes == null) {
      return Center(
        child: Text(
          '加载失败',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5.0,
        child: Center(
          child: Image.memory(
            _imageBytes!,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white24,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
}
