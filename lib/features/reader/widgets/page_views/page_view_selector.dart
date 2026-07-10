import 'package:flutter/material.dart';

import '../../config/reader_config_provider.dart';
import 'cover_page.dart';
import 'fade_page.dart';
import 'no_anim_page.dart';
import 'scroll_page.dart';
import 'simulation_page.dart';
import 'slide_page.dart';

/// 统一的翻页视图
///
/// 根据 readerConfigProvider 中的 pageAnimation 设置，
/// 自动选择对应的翻页模式。
class PageViewSelector extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final PageAnimationMode mode;
  final List<Widget> children;

  const PageViewSelector({
    super.key,
    required this.currentIndex,
    required this.onPageChanged,
    required this.mode,
    required this.children,
  });

  @override
  State<PageViewSelector> createState() => _PageViewSelectorState();
}

class _PageViewSelectorState extends State<PageViewSelector> {
  late PageController _pageController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.mode) {
      case PageAnimationMode.slide:
        return SlidePageView(
          controller: _pageController,
          currentIndex: widget.currentIndex,
          onPageChanged: widget.onPageChanged,
          children: widget.children,
        );

      case PageAnimationMode.scroll:
        return ScrollPageView(
          controller: _scrollController,
          currentIndex: widget.currentIndex,
          onPageChanged: widget.onPageChanged,
          children: widget.children,
        );

      case PageAnimationMode.cover:
        return CoverPageView(
          controller: _pageController,
          currentIndex: widget.currentIndex,
          onPageChanged: widget.onPageChanged,
          children: widget.children,
        );

      case PageAnimationMode.none:
        return NoAnimPageView(
          controller: _pageController,
          currentIndex: widget.currentIndex,
          onPageChanged: widget.onPageChanged,
          children: widget.children,
        );

      case PageAnimationMode.fade:
        return FadePageView(
          currentIndex: widget.currentIndex,
          onPageChanged: widget.onPageChanged,
          children: widget.children,
        );

      case PageAnimationMode.simulation:
        return SimulationPageView(
          index: widget.currentIndex,
          itemCount: widget.children.length,
          onPageChanged: widget.onPageChanged,
          child: widget.children.isNotEmpty
              ? widget.children[widget.currentIndex.clamp(
                  0,
                  widget.children.length - 1,
                )]
              : const SizedBox.shrink(),
        );
    }
  }
}
