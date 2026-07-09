import 'dart:io';

import 'package:flutter/material.dart';

/// 漫画单页渲染组件
///
/// 支持：InteractiveViewer 缩放 / 适应屏幕 / 网络+本地图片
class MangaPageView extends StatefulWidget {
  final String imageUrl;
  final bool fitToScreen;
  final VoidCallback? onTap;

  const MangaPageView({
    super.key,
    required this.imageUrl,
    this.fitToScreen = true,
    this.onTap,
  });

  @override
  State<MangaPageView> createState() => _MangaPageViewState();
}

class _MangaPageViewState extends State<MangaPageView> {
  late bool _isNetwork;

  @override
  void initState() {
    super.initState();
    _isNetwork = widget.imageUrl.startsWith('http://') ||
        widget.imageUrl.startsWith('https://');
  }

  @override
  void didUpdateWidget(MangaPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _isNetwork = widget.imageUrl.startsWith('http://') ||
          widget.imageUrl.startsWith('https://');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5.0,
        constrained: false,
        child: Center(
          child: _isNetwork ? _buildNetworkImage() : _buildLocalImage(),
        ),
      ),
    );
  }

  Widget _buildLocalImage() {
    final filePath = widget.imageUrl.startsWith('file://')
        ? widget.imageUrl.substring(7)
        : widget.imageUrl;

    return Image.file(
      File(filePath),
      fit: widget.fitToScreen ? BoxFit.contain : BoxFit.scaleDown,
      errorBuilder: (_, __, ___) => _buildErrorWidget(),
    );
  }

  Widget _buildNetworkImage() {
    return Image.network(
      widget.imageUrl,
      fit: widget.fitToScreen ? BoxFit.contain : BoxFit.scaleDown,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: progress.expectedTotalBytes != null
                ? progress.cumulativeBytesLoaded /
                    progress.expectedTotalBytes!
                : null,
            color: Colors.white38,
          ),
        );
      },
      errorBuilder: (_, __, ___) => _buildErrorWidget(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.broken_image_outlined, size: 48, color: Colors.white38),
          const SizedBox(height: 8),
          const Text('加载失败', style: TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }
}
