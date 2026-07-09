import 'package:flutter/material.dart';

/// 无动画翻页（瞬时切换）
class NoAnimPageView extends StatelessWidget {
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final List<Widget> children;

  const NoAnimPageView({
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
      physics: const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) => children[index],
    );
  }
}
