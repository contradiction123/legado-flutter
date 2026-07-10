import 'package:flutter/material.dart';

/// 淡入淡出翻页 — 使用 AnimatedSwitcher 实现 FadeTransition。
class FadePageView extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final List<Widget> children;

  const FadePageView({
    super.key,
    required this.currentIndex,
    required this.onPageChanged,
    required this.children,
  });

  @override
  State<FadePageView> createState() => _FadePageViewState();
}

class _FadePageViewState extends State<FadePageView> {
  int _displayedIndex = 0;

  @override
  void initState() {
    super.initState();
    _displayedIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(FadePageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      setState(() {
        _displayedIndex = widget.currentIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < 0 &&
              widget.currentIndex < widget.children.length - 1) {
            widget.onPageChanged(widget.currentIndex + 1);
          } else if (details.primaryVelocity! > 0 && widget.currentIndex > 0) {
            widget.onPageChanged(widget.currentIndex - 1);
          }
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: KeyedSubtree(
          key: ValueKey(_displayedIndex),
          child: widget.children[_displayedIndex],
        ),
      ),
    );
  }
}
