import 'dart:convert';

import '../../data/models/search_rule.dart';
import '../../domain/models/book.dart';
import '../../domain/models/book_chapter.dart';
import '../../domain/models/book_source.dart';
import '../../domain/models/search_book.dart';
import '../analyze_rule/analyze_rule.dart';
import '../analyze_rule/analyze_url.dart';

/// 网络书籍引擎
class WebBook {
  final AnalyzeRule _rule = AnalyzeRule();
  final AnalyzeUrl _urlBuilder = AnalyzeUrl();

  Future<List<SearchBook>> searchBooks(
    BookSource source,
    String keyword,
    int page,
  ) async {
    final searchUrl = source.searchUrl;
    final ruleSearchStr = source.ruleSearch;
    final ruleSearch = source.parseRuleSearch();
    if (searchUrl == null ||
        searchUrl.isEmpty ||
        ruleSearchStr == null ||
        ruleSearchStr.isEmpty ||
        ruleSearch == null) {
      return [];
    }

    try {
      final url = _urlBuilder.buildUrl(searchUrl, {
        'key': keyword,
        'keyword': keyword,
        'page': page.toString(),
      });
      final response = await _urlBuilder.get(url, headers: source.header);
      final html = response.body ?? '';
      if (html.isEmpty) {
        return [];
      }

      _rule.setRawData(html);
      final responseBaseUrl = response.url.isNotEmpty ? response.url : url;
      final bookListItems = _resolveBookListItems(
        ruleSearch.bookList ?? ruleSearchStr,
      );

      final books = <SearchBook>[];
      for (final item in bookListItems) {
        final book = _parseSearchItem(
          item,
          source,
          ruleSearch,
          responseBaseUrl,
          response.callTime,
        );
        if (book != null) {
          books.add(book);
        }
      }
      return books;
    } catch (_) {
      return [];
    }
  }

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
      if (html.isEmpty) {
        return null;
      }

      _rule.setRawData(html);
      final rule = _parseBookInfo(ruleBookInfoStr);

      return Book(
        bookUrl: searchResult.bookUrl,
        tocUrl: searchResult.tocUrl,
        origin: source.bookSourceUrl,
        originName: source.bookSourceName,
        name:
            _takeNonEmpty(_rule.getString(rule.name ?? ''), searchResult.name) ??
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
    } catch (_) {
      return _searchResultToBook(source, searchResult);
    }
  }

  Future<List<BookChapter>> getChapterList(BookSource source, Book book) async {
    final ruleTocStr = source.ruleToc;
    if (ruleTocStr == null || ruleTocStr.isEmpty) {
      return [];
    }

    try {
      final tocUrl = book.tocUrl.isNotEmpty ? book.tocUrl : book.bookUrl;
      final html = await _urlBuilder.fetchAsString(
        tocUrl,
        headers: source.header,
      );
      if (html.isEmpty) {
        return [];
      }

      _rule.setRawData(html);
      final rule = _parseToc(ruleTocStr);
      final bookListRule = rule.bookList;
      if (bookListRule == null || bookListRule.isEmpty) {
        return [];
      }

      final chapterItems = _rule.getStrings(bookListRule);
      final chapters = <BookChapter>[];

      for (var i = 0; i < chapterItems.length; i++) {
        _rule.setRawData(chapterItems[i]);
        final title = _rule.getString(rule.name ?? '');
        final url = _rule.getString(rule.bookUrl ?? '');
        if (title == null || title.isEmpty) {
          continue;
        }
        if (url == null || url.isEmpty) {
          continue;
        }

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
    } catch (_) {
      return [];
    }
  }

  Future<String> getBookContent(BookSource source, BookChapter chapter) async {
    final ruleContentStr = source.ruleContent;
    if (ruleContentStr == null || ruleContentStr.isEmpty) {
      return '';
    }

    try {
      final html = await _urlBuilder.fetchAsString(
        chapter.url,
        headers: source.header,
      );
      if (html.isEmpty) {
        return '';
      }

      _rule.setRawData(html);
      final rule = _parseContent(ruleContentStr);
      final content = _rule.getString(rule.content ?? ruleContentStr);
      return content ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<List<SearchBook>> explore(BookSource source, {String? url}) async {
    final exploreUrl = source.exploreUrl;
    final ruleExploreStr = source.ruleExplore;
    if (exploreUrl == null ||
        exploreUrl.isEmpty ||
        ruleExploreStr == null ||
        ruleExploreStr.isEmpty) {
      return [];
    }

    try {
      final targetUrl = _urlBuilder.buildUrl(url ?? exploreUrl, {
        'page': '1',
      });
      final response = await _urlBuilder.get(targetUrl, headers: source.header);
      final html = response.body ?? '';
      if (html.isEmpty) {
        return [];
      }

      final responseUrl = response.url.isNotEmpty ? response.url : targetUrl;
      _rule.setRawData(html);
      final ruleExplore = _parseExploreRule(ruleExploreStr);
      final items = _resolveBookListItems(
        ruleExplore.bookList ?? ruleExploreStr,
      );

      final books = <SearchBook>[];
      for (final item in items) {
        final book = _parseExploreItem(item, source, ruleExplore, responseUrl);
        if (book != null) {
          books.add(book);
        }
      }
      return books;
    } catch (_) {
      return [];
    }
  }

  SearchBook? _parseSearchItem(
    String item,
    BookSource source,
    SearchRule ruleSearch,
    String responseBaseUrl,
    int respondTime,
  ) {
    _rule.setRawData(item);
    final name = _normalizeText(_rule.getString(ruleSearch.name ?? ''));
    final bookUrl = _normalizeText(_rule.getString(ruleSearch.bookUrl ?? ''));
    if (name == null || name.isEmpty) {
      return null;
    }

    final resolvedBookUrl = _resolvePrimaryBookUrl(responseBaseUrl, bookUrl);
    if (resolvedBookUrl == null || resolvedBookUrl.isEmpty) {
      return null;
    }

    final author =
        _normalizeText(_rule.getString(ruleSearch.author ?? '')) ?? '';
    final coverUrl = _resolveOptionalUrl(
      responseBaseUrl,
      _normalizeText(_rule.getString(ruleSearch.coverUrl ?? '')),
    );
    final intro = _normalizeText(_rule.getString(ruleSearch.intro ?? ''));
    final kind = _normalizeText(_rule.getString(ruleSearch.kind ?? ''));
    final wordCount = _normalizeText(_rule.getString(ruleSearch.wordCount ?? ''));
    final latestChapterTitle = _normalizeText(
      _rule.getString(ruleSearch.lastChapter ?? ''),
    );

    return SearchBook(
      bookUrl: resolvedBookUrl,
      origin: source.bookSourceUrl,
      originName: source.bookSourceName,
      name: name,
      author: author,
      coverUrl: coverUrl,
      intro: intro,
      kind: kind,
      wordCount: wordCount,
      latestChapterTitle: latestChapterTitle,
      tocUrl: resolvedBookUrl,
      originOrder: source.customOrder,
      respondTime: respondTime,
    );
  }

  SearchBook? _parseExploreItem(
    String item,
    BookSource source,
    _RuleSearchParsed ruleExplore,
    String responseBaseUrl,
  ) {
    _rule.setRawData(item);
    final name = _normalizeText(_rule.getString(ruleExplore.name ?? ''));
    final bookUrl = _normalizeText(_rule.getString(ruleExplore.bookUrl ?? ''));
    if (name == null || name.isEmpty) {
      return null;
    }
    if (bookUrl == null || bookUrl.isEmpty) {
      return null;
    }

    final author = _normalizeText(_rule.getString(ruleExplore.author ?? ''));
    final coverUrl = _normalizeText(_rule.getString(ruleExplore.coverUrl ?? ''));
    final intro = _normalizeText(_rule.getString(ruleExplore.intro ?? ''));
    final kind = _normalizeText(_rule.getString(ruleExplore.kind ?? ''));
    final wordCount = _normalizeText(_rule.getString(ruleExplore.wordCount ?? ''));
    final latestChapterTitle = _normalizeText(
      _rule.getString(ruleExplore.lastChapter ?? ''),
    );
    final resolvedBookUrl = _urlBuilder.resolveUrl(responseBaseUrl, bookUrl);

    return SearchBook(
      bookUrl: resolvedBookUrl,
      origin: source.bookSourceUrl,
      originName: source.bookSourceName,
      name: name,
      author: author ?? '',
      coverUrl: _resolveOptionalUrl(responseBaseUrl, coverUrl),
      intro: intro,
      kind: kind,
      wordCount: wordCount,
      latestChapterTitle: latestChapterTitle,
      tocUrl: resolvedBookUrl,
      originOrder: source.customOrder,
    );
  }

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

  String? _takeNonEmpty(String? a, String? b) {
    if (a != null && a.isNotEmpty) {
      return a;
    }
    if (b != null && b.isNotEmpty) {
      return b;
    }
    return null;
  }

  List<String> _resolveBookListItems(String rule) {
    if (rule.isEmpty) {
      return const [];
    }

    var normalizedRule = rule;
    var reverse = false;
    if (normalizedRule.startsWith('-')) {
      reverse = true;
      normalizedRule = normalizedRule.substring(1);
    }
    if (normalizedRule.startsWith('+')) {
      normalizedRule = normalizedRule.substring(1);
    }

    final items = _rule.getStrings(normalizedRule);
    if (!reverse || items.length <= 1) {
      return items;
    }
    return items.reversed.toList(growable: false);
  }

  String? _resolvePrimaryBookUrl(String baseUrl, String? bookUrl) {
    if (bookUrl == null || bookUrl.isEmpty) {
      return baseUrl;
    }
    return _urlBuilder.resolveUrl(baseUrl, bookUrl);
  }

  String? _normalizeText(String? value) {
    if (value == null) {
      return null;
    }
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }

  _RuleSearchParsed _parseExploreRule(String json) {
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

  String? _resolveOptionalUrl(String baseUrl, String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return _urlBuilder.resolveUrl(baseUrl, value);
  }
}

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
