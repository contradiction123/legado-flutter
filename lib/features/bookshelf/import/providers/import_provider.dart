import 'package:flutter_riverpod/legacy.dart';

import '../../../../domain/models/book.dart';
import '../../../../engine/local_book/base_parser.dart';
import '../../../../engine/local_book/local_book.dart';

/// 导入状态
class ImportState {
  /// 是否正在导入
  final bool isImporting;

  /// 已成功导入的书籍
  final List<Book> importedBooks;

  /// 导入失败的路径
  final List<String> failedPaths;

  /// 导入进度（当前处理到第几个）
  final int progress;

  /// 总共需要处理的数量
  final int total;

  /// 错误信息
  final String? error;

  const ImportState({
    this.isImporting = false,
    this.importedBooks = const [],
    this.failedPaths = const [],
    this.progress = 0,
    this.total = 0,
    this.error,
  });

  ImportState copyWith({
    bool? isImporting,
    List<Book>? importedBooks,
    List<String>? failedPaths,
    int? progress,
    int? total,
    String? error,
  }) {
    return ImportState(
      isImporting: isImporting ?? this.isImporting,
      importedBooks: importedBooks ?? this.importedBooks,
      failedPaths: failedPaths ?? this.failedPaths,
      progress: progress ?? this.progress,
      total: total ?? this.total,
      error: error,
    );
  }
}

/// 导入状态管理
class ImportProvider extends StateNotifier<ImportState> {
  ImportProvider() : super(const ImportState());

  /// 导入文件列表
  Future<void> importFiles(List<String> filePaths) async {
    if (filePaths.isEmpty) return;

    state = state.copyWith(
      isImporting: true,
      progress: 0,
      total: filePaths.length,
      error: null,
    );

    final importedBooks = <Book>[];
    final failedPaths = <String>[];

    for (var i = 0; i < filePaths.length; i++) {
      final filePath = filePaths[i];
      final fileName = filePath.split('/').last;

      try {
        // 检测格式
        final format = detectFormat(fileName);
        if (format == BookFormat.unknown) {
          failedPaths.add('$fileName (不支持的格式)');
          state = state.copyWith(
            progress: i + 1,
            importedBooks: List.from(importedBooks),
            failedPaths: List.from(failedPaths),
          );
          continue;
        }

        // 导入书籍（创建 Book 对象但不写入数据库）
        final book = await localBookManager.importBook(
          filePath: filePath,
          fileName: fileName,
        );

        importedBooks.add(book);
      } catch (e) {
        failedPaths.add('$fileName ($e)');
      }

      state = state.copyWith(
        progress: i + 1,
        importedBooks: List.from(importedBooks),
        failedPaths: List.from(failedPaths),
      );
    }

    // 等待一帧让 UI 刷新
    await Future.delayed(const Duration(milliseconds: 100));

    state = state.copyWith(isImporting: false);
  }

  /// 获取已导入书籍的章节列表
  Future<void> loadChaptersForBook(Book book) async {
    try {
      final chapters = await localBookManager.getChapterList(book);
      // chapters 结果在外部使用
    } catch (e) {
      // 章节加载失败
    }
  }

  /// 重置状态
  void reset() {
    state = const ImportState();
  }
}

/// 导入状态提供者
final importProvider = StateNotifierProvider<ImportProvider, ImportState>((ref) {
  return ImportProvider();
});
