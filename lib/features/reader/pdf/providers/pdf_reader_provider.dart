import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../engine/local_book/pdf/pdf_parser.dart';

/// PDF 阅读器状态
class PdfReaderState {
  final int pageCount;
  final int currentPage;
  final double zoomLevel;
  final bool isLoading;
  final String? error;

  const PdfReaderState({
    this.pageCount = 0,
    this.currentPage = 0,
    this.zoomLevel = 1.0,
    this.isLoading = false,
    this.error,
  });

  PdfReaderState copyWith({
    int? pageCount,
    int? currentPage,
    double? zoomLevel,
    bool? isLoading,
    String? error,
  }) {
    return PdfReaderState(
      pageCount: pageCount ?? this.pageCount,
      currentPage: currentPage ?? this.currentPage,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  String get progressText =>
      pageCount > 0 ? '${currentPage + 1}/$pageCount' : '';
  bool get hasNext => currentPage < pageCount - 1;
  bool get hasPrevious => currentPage > 0;
}

/// PDF 阅读器状态管理
class PdfReaderProvider extends StateNotifier<PdfReaderState> {
  final PdfParser _parser;
  final String _filePath;

  PdfReaderProvider(this._filePath)
      : _parser = PdfParser(),
        super(const PdfReaderState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    try {
      await _parser.openFile(_filePath);
      state = state.copyWith(
        pageCount: _parser.pageCount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '加载PDF失败: $e');
    }
  }

  /// 渲染指定页面为图片
  Future<Uint8List?> renderPage(int pageIndex) async {
    final bytes = await _parser.renderPage(pageIndex);
    if (bytes == null) return null;
    return Uint8List.fromList(bytes);
  }

  void goToPage(int page) {
    final clamped = page.clamp(0, state.pageCount - 1);
    state = state.copyWith(currentPage: clamped);
  }

  void nextPage() {
    if (state.hasNext) goToPage(state.currentPage + 1);
  }

  void previousPage() {
    if (state.hasPrevious) goToPage(state.currentPage - 1);
  }

  void setZoom(double zoom) {
    state = state.copyWith(zoomLevel: zoom.clamp(0.5, 5.0));
  }

  @override
  void dispose() {
    _parser.close();
    super.dispose();
  }
}

final pdfReaderProvider =
    StateNotifierProvider.family<PdfReaderProvider, PdfReaderState, String>(
  (ref, filePath) => PdfReaderProvider(filePath),
);
