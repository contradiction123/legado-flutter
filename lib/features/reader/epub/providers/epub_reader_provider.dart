import 'package:flutter_riverpod/legacy.dart';

import '../../../../domain/models/book.dart';
import '../../../../domain/models/book_chapter.dart';
import '../../../../engine/local_book/epub/epub_file_parser.dart';

/// EPUB 阅读器状态
class EpubReaderState {
  final List<BookChapter> chapters;
  final int currentChapterIndex;
  final List<String> htmlContents;
  final bool isLoading;
  final String? error;
  final String bookTitle;

  const EpubReaderState({
    this.chapters = const [],
    this.currentChapterIndex = 0,
    this.htmlContents = const [],
    this.isLoading = false,
    this.error,
    this.bookTitle = '',
  });

  EpubReaderState copyWith({
    List<BookChapter>? chapters,
    int? currentChapterIndex,
    List<String>? htmlContents,
    bool? isLoading,
    String? error,
    String? bookTitle,
  }) {
    return EpubReaderState(
      chapters: chapters ?? this.chapters,
      currentChapterIndex: currentChapterIndex ?? this.currentChapterIndex,
      htmlContents: htmlContents ?? this.htmlContents,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      bookTitle: bookTitle ?? this.bookTitle,
    );
  }

  bool get hasNext => currentChapterIndex < chapters.length - 1;
  bool get hasPrevious => currentChapterIndex > 0;
  String get progressText => chapters.isEmpty
      ? ''
      : '${currentChapterIndex + 1}/${chapters.length}';
}

/// EPUB 阅读器状态管理
class EpubReaderProvider extends StateNotifier<EpubReaderState> {
  final EpubFileParser _parser;
  final Book _book;

  EpubReaderProvider(this._book)
      : _parser = EpubFileParser(),
        super(const EpubReaderState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, bookTitle: _book.name);

    try {
      final chapters = await _parser.getChapterList(_book);
      final htmlContents = <String>[];

      for (var i = 0; i < chapters.length; i++) {
        final content = await _parser.getContent(_book, chapters[i]);
        htmlContents.add(content ?? '<p>内容加载失败</p>');
      }

      state = state.copyWith(
        chapters: chapters,
        htmlContents: htmlContents,
        isLoading: false,
        currentChapterIndex: _book.durChapterIndex.clamp(0, chapters.length - 1),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '加载失败: $e');
    }
  }

  void goToChapter(int index) {
    if (index < 0 || index >= state.chapters.length) return;
    state = state.copyWith(currentChapterIndex: index);
  }

  void nextChapter() {
    if (state.hasNext) goToChapter(state.currentChapterIndex + 1);
  }

  void previousChapter() {
    if (state.hasPrevious) goToChapter(state.currentChapterIndex - 1);
  }

  Future<List<int>?> getResource(String href) async {
    return _parser.getResource(_book, href);
  }

  EpubFileParser get parser => _parser;
}

final epubReaderProvider =
    StateNotifierProvider.family<EpubReaderProvider, EpubReaderState, Book>(
  (ref, book) => EpubReaderProvider(book),
);
