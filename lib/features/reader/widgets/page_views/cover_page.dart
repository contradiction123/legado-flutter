import 'package:flutter/material.dart';

/// 覆盖翻页 — 下一页从右侧滑入覆盖当前页。
class CoverPageView extends StatefulWidget {
  final PageController controller;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final List<Widget> children;

  const CoverPageView({
    super.key,
    required this.controller,
    required this.currentIndex,
    required this.onPageChanged,
    required this.children,
  });

  @override
  State<CoverPageView> createState() => _CoverPageViewState();
}

class _CoverPageViewState extends State<CoverPageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnim;
  bool _isTransitioning = false;
  int _nextIndex = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );
    _animController.addListener(() {
      if (_animController.isCompleted) {
        _isTransitioning = false;
        widget.onPageChanged(_nextIndex);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _goToNext(int index) {
    if (_isTransitioning || index >= widget.children.length) return;
    _isTransitioning = true;
    _nextIndex = index;
    _animController.reset();
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < 0 &&
              widget.currentIndex < widget.children.length - 1) {
            _goToNext(widget.currentIndex + 1);
          } else if (details.primaryVelocity! > 0 && widget.currentIndex > 0) {
            widget.onPageChanged(widget.currentIndex - 1);
          }
        }
      },
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: widget.children[widget.currentIndex],
          ),
          if (_isTransitioning)
            SlideTransition(
              position: _slideAnim,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: widget.children[_nextIndex],
              ),
            ),
        ],
      ),
    );
  }
}
