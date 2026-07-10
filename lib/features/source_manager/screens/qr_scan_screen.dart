import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen>
    with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    autoStart: true,
  );

  bool _isProcessing = false;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        _controller.start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _controller.stop();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleScanResult(String? value) async {
    if (value == null || value.isEmpty || _isProcessing) return;

    setState(() => _isProcessing = true);
    HapticFeedback.mediumImpact();
    await _controller.stop();

    if (mounted) {
      context.pop(value);
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result == null || result.files.isEmpty) return;

      final path = result.files.first.path;
      if (path == null) return;

      setState(() => _isProcessing = true);

      final barcodeCapture = await _controller.analyzeImage(path);
      final barcodes = barcodeCapture?.barcodes ?? [];
      if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
        await _handleScanResult(barcodes.first.rawValue);
        return;
      }

      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('未能从图片中识别到二维码')),
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('解析图片失败: $e')),
        );
      }
    }
  }

  Future<void> _toggleFlash() async {
    await _controller.toggleTorch();
    setState(() => _flashOn = !_flashOn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                _handleScanResult(barcodes.first.rawValue);
              }
            },
            errorBuilder: (context, error, child) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white54,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '相机启动失败: ${error.errorCode.name}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            },
          ),
          _buildScanOverlay(),
          _buildTopBar(),
          _buildBottomBar(),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      '正在处理...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScanOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final scanAreaSize = size.width * 0.75;
        final left = (size.width - scanAreaSize) / 2;
        final top = (size.height - scanAreaSize) / 2.5;

        return Stack(
          children: [
            CustomPaint(
              size: size,
              painter: _ScanOverlayPainter(
                scanRect: Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize),
              ),
            ),
            Positioned(
              left: left,
              top: top,
              width: scanAreaSize,
              height: scanAreaSize,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.greenAccent.withValues(alpha: 0.8),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Positioned(
              left: left - 2,
              top: top - 2,
              child: _buildCornerMarker(true, true),
            ),
            Positioned(
              right: left - 2,
              top: top - 2,
              child: _buildCornerMarker(false, true),
            ),
            Positioned(
              left: left - 2,
              bottom: size.height - top - scanAreaSize - 2,
              child: _buildCornerMarker(true, false),
            ),
            Positioned(
              right: left - 2,
              bottom: size.height - top - scanAreaSize - 2,
              child: _buildCornerMarker(false, false),
            ),
            Positioned(
              top: top + scanAreaSize + 24,
              left: 0,
              right: 0,
              child: const Text(
                '将二维码放入框内，即可自动扫描',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCornerMarker(bool left, bool top) {
    const length = 20.0;
    const thickness = 4.0;
    return SizedBox(
      width: length,
      height: length,
      child: Stack(
        children: [
          if (left && top) ...[
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: length,
                height: thickness,
                color: Colors.greenAccent,
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: thickness,
                height: length,
                color: Colors.greenAccent,
              ),
            ),
          ],
          if (!left && top) ...[
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: length,
                height: thickness,
                color: Colors.greenAccent,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: thickness,
                height: length,
                color: Colors.greenAccent,
              ),
            ),
          ],
          if (left && !top) ...[
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: length,
                height: thickness,
                color: Colors.greenAccent,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: thickness,
                height: length,
                color: Colors.greenAccent,
              ),
            ),
          ],
          if (!left && !top) ...[
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: length,
                height: thickness,
                color: Colors.greenAccent,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: thickness,
                height: length,
                color: Colors.greenAccent,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: '关闭',
            ),
            const Expanded(
              child: Text(
                '扫描二维码',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              onPressed: _toggleFlash,
              icon: Icon(
                _flashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
              ),
              tooltip: '闪光灯',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: IconButton(
                      onPressed: _isProcessing ? null : _pickImageFromGallery,
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 28,
                      ),
                      tooltip: '从相册选择',
                      iconSize: 28,
                      padding: const EdgeInsets.all(14),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '相册',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  final Rect scanRect;

  const _ScanOverlayPainter({required this.scanRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withValues(alpha: 0.6);
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, scanRect.top), paint);
    canvas.drawRect(
      Rect.fromLTRB(0, scanRect.bottom, size.width, size.height),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTRB(0, scanRect.top, scanRect.left, scanRect.bottom),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTRB(scanRect.right, scanRect.top, size.width, scanRect.bottom),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
