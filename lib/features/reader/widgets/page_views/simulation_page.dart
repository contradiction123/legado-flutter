import 'package:flutter/material.dart';

/// 仿真翻页效果（页面卷曲翻页）
///
/// 使用 CustomPainter + 贝塞尔曲线模拟纸张卷曲效果。
/// 用户从页面右侧/右下角拖拽触发翻页。
///
/// 参考原 Legado: SimulationPageDelegate.kt
class SimulationPageView extends StatefulWidget {
  final Widget child;
  final PageController? pageController;
  final int index;
  final int itemCount;
  final ValueChanged<int> onPageChanged;

  const SimulationPageView({
    super.key,
    required this.child,
    this.pageController,
    required this.index,
    required this.itemCount,
    required this.onPageChanged,
  });

  @override
  State<SimulationPageView> createState() => _SimulationPageViewState();
}

class _SimulationPageViewState extends State<SimulationPageView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  Animation<double>? _anim;

  // 翻页状态
  double _dragX = 0;
  double _dragY = 0;
  bool _isDragging = false;
  bool _isAnimating = false;
  bool _isFlippingForward = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animController.addListener(() {
      if (!_isAnimating) return;
      setState(() {
        _dragX = _anim!.value;
      });
      // 动画完成时触发页面切换
      if (_animController.isCompleted) {
        _isAnimating = false;
        _isDragging = false;
        _dragX = 0;
        _dragY = 0;
        if (_isFlippingForward && widget.index < widget.itemCount - 1) {
          widget.onPageChanged(widget.index + 1);
        } else if (!_isFlippingForward && widget.index > 0) {
          widget.onPageChanged(widget.index - 1);
        }
      }
      if (_animController.isDismissed) {
        _isAnimating = false;
        _isDragging = false;
        _dragX = 0;
        _dragY = 0;
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _isDragging = true;
    _dragX = 0;
    _dragY = 0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isAnimating) return;
    setState(() {
      _dragX += details.delta.dx;
      _dragY += details.delta.dy;
      _dragX = _dragX.clamp(0.0, context.size?.width ?? 360);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragX <= 0) {
      _isDragging = false;
      return;
    }

    _isAnimating = true;
    final w = context.size?.width ?? 360;
    final progress = (_dragX / w).clamp(0.0, 1.0);
    _isFlippingForward = progress > 0.3 && widget.index < widget.itemCount - 1;

    if (_isFlippingForward) {
      // 翻到下一页
      _anim = Tween<double>(begin: _dragX, end: w).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
      );
    } else {
      // 回弹
      _anim = Tween<double>(begin: _dragX, end: 0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut),
      );
    }

    _animController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = context.size ?? const Size(360, 600);

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        painter: _SimulationPagePainter(
          curlX: _dragX,
          curlY: _dragY,
          size: size,
          child: widget.child,
          isAnimating: _isAnimating || _isDragging,
        ),
        size: size,
      ),
    );
  }
}

/// 仿真翻页绘制器
///
/// 使用贝塞尔曲线绘制页面卷曲效果。卷曲部分显示为
/// 页面背面的镜像内容，并添加阴影增强立体感。
class _SimulationPagePainter extends CustomPainter {
  final double curlX;
  final double curlY;
  final Size size;
  final Widget child;
  final bool isAnimating;

  _SimulationPagePainter({
    required this.curlX,
    required this.curlY,
    required this.size,
    required this.child,
    required this.isAnimating,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (curlX <= 0 && !isAnimating) {
      // 正常状态：无需卷曲
      return;
    }

    final w = size.width;
    final h = size.height;

    // 卷曲区域的三个关键点
    // A: 卷曲顶点（右上角向内的点）
    // B: 卷曲底边上的点
    // C: 卷曲起始点（右侧边上的点）

    final aX = w - curlX;
    final aY = curlY.clamp(0.0, h * 0.3);
    final cX = w;
    final cY = (curlY + h * 0.5).clamp(h * 0.3, h);
    final bX = w - curlX * 0.6;
    final bY = h;

    // 绘制阴影
    if (curlX > 4) {
      final shadowPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            Colors.black.withValues(alpha: (curlX / w * 0.3).clamp(0.0, 0.3)),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(0, 0, w, h));
      canvas.drawRect(Rect.fromLTWH(w - curlX, 0, curlX, h), shadowPaint);
    }

    // 绘制卷曲部分的背面效果
    if (curlX > 2) {
      final curlPath = Path()
        ..moveTo(aX, aY)
        ..quadraticBezierTo((aX + cX) / 2, (aY + cY) / 2, cX, cY)
        ..lineTo(bX, bY)
        ..quadraticBezierTo((aX + bX) / 2, (aY + bY) / 2, aX, aY)
        ..close();

      final curlPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.white.withValues(alpha: 0.85),
            Colors.grey.shade200.withValues(alpha: 0.6),
            Colors.grey.shade300.withValues(alpha: 0.4),
          ],
        ).createShader(Rect.fromLTWH(aX, 0, w - aX, h));

      canvas.drawPath(curlPath, curlPaint);
    }

    // 绘制卷曲的边缘高光
    if (curlX > 4) {
      final edgePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      final edgePath = Path()
        ..moveTo(aX, aY)
        ..quadraticBezierTo((aX + cX) / 2, (aY + cY) / 2, cX, cY);

      canvas.drawPath(edgePath, edgePaint);
    }
  }

  @override
  bool shouldRepaint(_SimulationPagePainter oldDelegate) {
    return oldDelegate.curlX != curlX ||
        oldDelegate.curlY != curlY ||
        oldDelegate.size != size ||
        oldDelegate.isAnimating != isAnimating;
  }
}
