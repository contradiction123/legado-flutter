import 'package:flutter/material.dart';

/// 滑动翻页 — 使用 PageView 默认的滑动切换效果。
class SlidePageView extends StatelessWidget {
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final List<Widget> children;

  const SlidePageView({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: children.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) => children[index],
    );
  }
}
