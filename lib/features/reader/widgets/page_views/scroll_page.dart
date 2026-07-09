import 'package:flutter/material.dart';

/// 滚动翻页（连续滚动阅读）— 将所有章节内容拼接为滚动列表。
class ScrollPageView extends StatefulWidget {
  final ScrollController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final List<Widget> children;

  const ScrollPageView({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
    required this.children,
  });

  @override
  State<ScrollPageView> createState() => _ScrollPageViewState();
}

class _ScrollPageViewState extends State<ScrollPageView> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    // 滚动模式无需触发 onPageChanged，所有内容在一个列表中
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.controller,
      padding: EdgeInsets.zero,
      children: widget.children,
    );
  }
}
