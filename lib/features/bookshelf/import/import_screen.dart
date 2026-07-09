import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/book.dart';
import '../../../domain/models/book_ext.dart';
import '../../../engine/local_book/base_parser.dart';
import '../../../engine/local_book/local_book.dart';
import '../../bookshelf/providers/bookshelf_provider.dart';
import 'providers/import_provider.dart';
import 'widgets/format_chip.dart';
import 'widgets/import_progress.dart';

/// 本地书籍导入页面
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(importProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('导入本地书籍'),
        actions: [
          if (!state.isImporting && state.importedBooks.isNotEmpty)
            TextButton.icon(
              onPressed: _saveAllToShelf,
              icon: const Icon(Icons.library_books_outlined, size: 18),
              label: const Text('加入书架'),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 导入按钮区域
            _buildImportButton(state, theme),
            const SizedBox(height: 16),

            // 进度指示
            if (state.isImporting || state.total > 0) ...[
              ImportProgress(
                progress: state.progress,
                total: state.total,
                successCount: state.importedBooks.length,
                failedCount: state.failedPaths.length,
                isImporting: state.isImporting,
              ),
              const SizedBox(height: 16),
            ],

            // 错误信息
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  state.error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),

            // 导入结果列表
            Expanded(
              child: _buildResultList(state, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportButton(ImportState state, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: state.isImporting
          ? const Center(child: CircularProgressIndicator())
          : OutlinedButton.icon(
              onPressed: _pickFiles,
              icon: const Icon(Icons.file_open_outlined, size: 36),
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('选择文件', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    '支持 TXT、EPUB、PDF 格式',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(120),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildResultList(ImportState state, ThemeData theme) {
    if (state.importedBooks.isEmpty && state.failedPaths.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined,
                size: 48, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(
              '点击上方按钮选择本地书籍文件',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        // 成功导入的书籍
        if (state.importedBooks.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '成功导入 (${state.importedBooks.length})',
              style: theme.textTheme.titleSmall,
            ),
          ),
          ...state.importedBooks.map((book) => _BookResultTile(book: book)),
        ],

        // 导入失败的文件
        if (state.failedPaths.isNotEmpty) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '导入失败 (${state.failedPaths.length})',
              style: theme.textTheme.titleSmall?.copyWith(color: Colors.orange),
            ),
          ),
          ...state.failedPaths.map((path) => ListTile(
                dense: true,
                leading: const Icon(Icons.error_outline, color: Colors.orange, size: 20),
                title: Text(path, style: const TextStyle(fontSize: 13)),
              )),
        ],
      ],
    );
  }

  void _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'epub', 'pdf'],
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final paths = result.files
            .where((f) => f.path != null)
            .map((f) => f.path!)
            .toList();
        if (paths.isNotEmpty) {
          ref.read(importProvider.notifier).importFiles(paths);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('选择文件失败: $e')),
      );
    }
  }

  void _saveAllToShelf() {
    // 保存所有导入的书籍到书架数据库
    final importState = ref.read(importProvider);
    final books = importState.importedBooks;
    if (books.isEmpty) return;

    // 保存到书架
    ref.read(bookshelfProvider.notifier).addBooks(books).then((count) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已添加 $count 本书到书架')),
      );
      ref.read(importProvider.notifier).reset();
      Navigator.pop(context);
    });
  }
}

/// 书籍导入结果卡片
class _BookResultTile extends StatelessWidget {
  final Book book;

  const _BookResultTile({required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final format = detectFormat(book.originName);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: FormatChip(format: format),
        title: Text(
          book.name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: book.author.isNotEmpty
            ? Text(book.author, style: const TextStyle(fontSize: 12))
            : null,
        trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
        onTap: () {
          context.push(book.readerRoute, extra: book);
        },
      ),
    );
  }
}
