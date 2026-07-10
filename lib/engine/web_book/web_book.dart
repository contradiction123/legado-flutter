import 'dart:convert';

import '../../domain/models/book.dart';
import '../../domain/models/book_chapter.dart';
import '../../domain/models/book_source.dart';
import '../../domain/models/search_book.dart';
import '../analyze_rule/analyze_rule.dart';
import '../analyze_rule/analyze_url.dart';

/// 网络书籍引擎
///
/// 对标原：WebBook.kt
/// 实现完整的书源规则执行流程：搜索→详情→目录→正文→发现
class WebBook {
  final AnalyzeRule _rule = AnalyzeRule();
  final AnalyzeUrl _urlBuilder = AnalyzeUrl();

  /// 搜索书籍
  Future<List<SearchBook>> searchBooks(
    BookSource source,
    String keyword,
    int page,
  ) async {
    final searchUrl = source.searchUrl;
    final ruleSearchStr = source.ruleSearch;
    if (searchUrl == null ||
        searchUrl.isEmpty ||
        ruleSearchStr == null ||
        ruleSearchStr.isEmpty)
      return [];

    try {
      // 构建搜索 URL
      final url = _urlBuilder.buildUrl(searchUrl, {
        'key': keyword,
        'page': page.toString(),
        'keyword': keyword,
      });

      // 发送请求
      final html = await _urlBuilder.fetchAsString(url, headers: source.header);
      if (html.isEmpty) return [];

      // 解析搜索结果列表规则
      _rule.setRawData(html);
      final ruleSearch = _parseRuleSearch(ruleSearchStr);
      final bookListItems = _rule.getStrings(
        ruleSearch.bookList ?? ruleSearchStr,
      );

      final books = <SearchBook>[];
      for (final item in bookListItems) {
        final book = _parseSearchItem(item, source);
        if (book != null) books.add(book);
      }
      return books;
    } catch (e) {
      return [];
    }
  }

  /// 获取书籍详情
  Future<Book?> getBookInfo(BookSource source, SearchBook searchResult) async {
    final ruleBookInfoStr = source.ruleBookInfo;
    if (ruleBookInfoStr == null || ruleBookInfoStr.isEmpty) {
      return _searchResultToBook(source, searchResult);
    }

    try {
      final html = await _urlBuilder.fetchAsString(
        searchResult.bookUrl,
        headers: source.header,
      );
      if (html.isEmpty) return null;

      _rule.setRawData(html);
      final rule = _parseBookInfo(ruleBookInfoStr);

      return Book(
        bookUrl: searchResult.bookUrl,
        tocUrl: searchResult.tocUrl,
        origin: source.bookSourceUrl,
        originName: source.bookSourceName,
        name:
            _takeNonEmpty(
              _rule.getString(rule.name ?? ''),
              searchResult.name,
            ) ??
            searchResult.name,
        author:
            _takeNonEmpty(
              _rule.getString(rule.author ?? ''),
              searchResult.author,
            ) ??
            searchResult.author,
        coverUrl: _takeNonEmpty(
          _rule.getString(rule.coverUrl ?? ''),
          searchResult.coverUrl,
        ),
        intro: _takeNonEmpty(
          _rule.getString(rule.intro ?? ''),
          searchResult.intro,
        ),
        kind: _rule.getString(rule.kind ?? ''),
        wordCount: _rule.getString(rule.wordCount ?? ''),
        latestChapterTitle: _takeNonEmpty(
          _rule.getString(rule.lastChapter ?? ''),
          searchResult.latestChapterTitle,
        ),
      );
    } catch (e) {
      return _searchResultToBook(source, searchResult);
    }
  }

  /// 获取章节列表
  Future<List<BookChapter>> getChapterList(BookSource source, Book book) async {
    final ruleTocStr = source.ruleToc;
    if (ruleTocStr == null || ruleTocStr.isEmpty) return [];

    try {
      final tocUrl = book.tocUrl.isNotEmpty ? book.tocUrl : book.bookUrl;
      final html = await _urlBuilder.fetchAsString(
        tocUrl,
        headers: source.header,
      );
      if (html.isEmpty) return [];

      _rule.setRawData(html);
      final rule = _parseToc(ruleTocStr);
      final bookListRule = rule.bookList;
      if (bookListRule == null || bookListRule.isEmpty) return [];

      final chapterItems = _rule.getStrings(bookListRule);
      final chapters = <BookChapter>[];

      for (var i = 0; i < chapterItems.length; i++) {
        _rule.setRawData(chapterItems[i]);
        final title = _rule.getString(rule.name ?? '');
        final url = _rule.getString(rule.bookUrl ?? '');
        if (title == null || title.isEmpty) continue;
        if (url == null || url.isEmpty) continue;

        final resolvedUrl = _urlBuilder.resolveUrl(tocUrl, url);
        chapters.add(
          BookChapter(
            url: resolvedUrl,
            title: title,
            baseUrl: tocUrl,
            bookUrl: book.bookUrl,
            index: i,
            isVolume: false,
            isVip: false,
            isPay: false,
          ),
        );
      }
      return chapters;
    } catch (e) {
      return [];
    }
  }

  /// 获取正文内容
  Future<String> getBookContent(BookSource source, BookChapter chapter) async {
    final ruleContentStr = source.ruleContent;
    if (ruleContentStr == null || ruleContentStr.isEmpty) return '';

    try {
      final html = await _urlBuilder.fetchAsString(
        chapter.url,
        headers: source.header,
      );
      if (html.isEmpty) return '';

      _rule.setRawData(html);
      final rule = _parseContent(ruleContentStr);
      final content = _rule.getString(rule.content ?? ruleContentStr);
      return content ?? '';
    } catch (e) {
      return '';
    }
  }

  /// 发现页浏览
  Future<List<SearchBook>> explore(BookSource source, {String? url}) async {
    final exploreUrl = source.exploreUrl;
    final ruleExploreStr = source.ruleExplore;
    if (exploreUrl == null ||
        exploreUrl.isEmpty ||
        ruleExploreStr == null ||
        ruleExploreStr.isEmpty)
      return [];

    try {
      final targetUrl = url ?? exploreUrl;
      final html = await _urlBuilder.fetchAsString(
        targetUrl,
        headers: source.header,
      );
      if (html.isEmpty) return [];

      _rule.setRawData(html);
      final ruleExplore = _parseRuleSearch(ruleExploreStr);
      final items = _rule.getStrings(ruleExplore.bookList ?? ruleExploreStr);

      final books = <SearchBook>[];
      for (final item in items) {
        final book = _parseSearchItem(item, source);
        if (book != null) books.add(book);
      }
      return books;
    } catch (e) {
      return [];
    }
  }

  /// ──────────────────────────────────────────────────────────────────
  // 私有方法
  // ──────────────────────────────────────────────────────────────────

  /// 从规则结果中解析单个搜索结果
  SearchBook? _parseSearchItem(String item, BookSource source) {
    _rule.setRawData(item);
    final name = _rule.getString('name');
    final bookUrl = _rule.getString('bookUrl');
    if (name == null || name.isEmpty) return null;
    if (bookUrl == null || bookUrl.isEmpty) return null;

    final author = _rule.getString('author');
    final coverUrl = _rule.getString('coverUrl');
    final intro = _rule.getString('intro');
    final tocUrl = _rule.getString('tocUrl');
    final kind = _rule.getString('kind');
    final wordCount = _rule.getString('wordCount');
    final latestChapterTitle = _rule.getString('lastChapter');

    return SearchBook(
      bookUrl: _urlBuilder.resolveUrl(source.bookSourceUrl, bookUrl),
      origin: source.bookSourceUrl,
      originName: source.bookSourceName,
      name: name,
      author: author ?? '',
      coverUrl: coverUrl != null
          ? _urlBuilder.resolveUrl(source.bookSourceUrl, coverUrl)
          : null,
      intro: intro,
      kind: kind,
      wordCount: wordCount,
      latestChapterTitle: latestChapterTitle,
      tocUrl: _urlBuilder.resolveUrl(source.bookSourceUrl, tocUrl ?? bookUrl),
    );
  }

  /// 将搜索结果转为基本 Book 对象
  Book _searchResultToBook(BookSource source, SearchBook searchResult) {
    return Book(
      bookUrl: searchResult.bookUrl,
      tocUrl: searchResult.tocUrl,
      origin: source.bookSourceUrl,
      originName: source.bookSourceName,
      name: searchResult.name,
      author: searchResult.author,
      coverUrl: searchResult.coverUrl,
      intro: searchResult.intro,
      kind: searchResult.kind,
      wordCount: searchResult.wordCount,
      latestChapterTitle: searchResult.latestChapterTitle,
    );
  }

  /// 取两个值中非空的
  String? _takeNonEmpty(String? a, String? b) {
    if (a != null && a.isNotEmpty) return a;
    if (b != null && b.isNotEmpty) return b;
    return null;
  }

  /// 解析搜索规则 JSON
  _RuleSearchParsed _parseRuleSearch(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return _RuleSearchParsed(
        bookList: map['bookList'] as String?,
        name: map['name'] as String?,
        author: map['author'] as String?,
        coverUrl: map['coverUrl'] as String?,
        intro: map['intro'] as String?,
        kind: map['kind'] as String?,
        bookUrl: map['bookUrl'] as String?,
        lastChapter: map['lastChapter'] as String?,
        wordCount: map['wordCount'] as String?,
      );
    } catch (_) {
      return _RuleSearchParsed(bookList: json);
    }
  }

  _BookInfoParsed _parseBookInfo(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return _BookInfoParsed(
        name: map['name'] as String?,
        author: map['author'] as String?,
        coverUrl: map['coverUrl'] as String?,
        intro: map['intro'] as String?,
        kind: map['kind'] as String?,
        lastChapter: map['lastChapter'] as String?,
        wordCount: map['wordCount'] as String?,
      );
    } catch (_) {
      return _BookInfoParsed();
    }
  }

  _TocParsed _parseToc(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return _TocParsed(
        bookList: map['bookList'] as String?,
        name: map['name'] as String?,
        bookUrl: map['bookUrl'] as String?,
      );
    } catch (_) {
      return _TocParsed(bookList: json);
    }
  }

  _ContentParsed _parseContent(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return _ContentParsed(content: map['content'] as String?);
    } catch (_) {
      return _ContentParsed(content: json);
    }
  }
}

/// 搜索规则解析结果
class _RuleSearchParsed {
  final String? bookList;
  final String? name;
  final String? author;
  final String? coverUrl;
  final String? intro;
  final String? kind;
  final String? bookUrl;
  final String? lastChapter;
  final String? wordCount;

  const _RuleSearchParsed({
    this.bookList,
    this.name,
    this.author,
    this.coverUrl,
    this.intro,
    this.kind,
    this.bookUrl,
    this.lastChapter,
    this.wordCount,
  });
}

class _BookInfoParsed {
  final String? name;
  final String? author;
  final String? coverUrl;
  final String? intro;
  final String? kind;
  final String? lastChapter;
  final String? wordCount;

  const _BookInfoParsed({
    this.name,
    this.author,
    this.coverUrl,
    this.intro,
    this.kind,
    this.lastChapter,
    this.wordCount,
  });
}

class _TocParsed {
  final String? bookList;
  final String? name;
  final String? bookUrl;

  const _TocParsed({this.bookList, this.name, this.bookUrl});
}

class _ContentParsed {
  final String? content;

  const _ContentParsed({this.content});
}
