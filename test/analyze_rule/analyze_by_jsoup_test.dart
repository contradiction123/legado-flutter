import 'package:flutter_test/flutter_test.dart';

import '../../lib/engine/analyze_rule/analyze_by_jsoup.dart';
import '../data/test_html_samples.dart';

void main() {
  late AnalyzeByJSoup jsoup;

  setUp(() {
    jsoup = AnalyzeByJSoup();
  });

  group('AnalyzeByJSoup', () {
    test('elements returns matching elements', () {
      final els = jsoup.elements(TestHtmlSamples.searchResult, '.result-item');
      expect(els.length, 2);
    });

    test('elements returns empty on no match', () {
      final els = jsoup.elements(TestHtmlSamples.searchResult, '.nonexistent');
      expect(els, isEmpty);
    });

    test('elements returns empty on empty input', () {
      expect(jsoup.elements('', '.class'), isEmpty);
      expect(jsoup.elements('<div></div>', ''), isEmpty);
    });

    test('element returns first match', () {
      final el = jsoup.element(TestHtmlSamples.searchResult, '.result-item');
      expect(el, isNotNull);
    });

    test('element returns null on no match', () {
      final el = jsoup.element(TestHtmlSamples.searchResult, '.no-match');
      expect(el, isNull);
    });

    test('getFirst extracts text by @text', () {
      final result = jsoup.getFirst(TestHtmlSamples.searchResult, '.book-name@text');
      expect(result, '凡人修仙传');
    });

    test('getFirst extracts href by @href', () {
      final result = jsoup.getFirst(TestHtmlSamples.searchResult, '.book-name@href');
      expect(result, '/book/12345/');
    });

    test('getFirst extracts html by @html', () {
      final result = jsoup.getFirst(TestHtmlSamples.searchResult, '.result-item@html');
      expect(result, isNotNull);
      expect(result!.contains('凡人修仙传'), isTrue);
    });

    test('getFirst defaults to @text when no attr specified', () {
      final result = jsoup.getFirst(TestHtmlSamples.searchResult, '.book-name');
      expect(result, '凡人修仙传');
    });

    test('getList returns all matching texts', () {
      final results = jsoup.getList(TestHtmlSamples.searchResult, '.book-name@text');
      expect(results.length, 2);
      expect(results[0], '凡人修仙传');
      expect(results[1], '凡人修仙传·仙界篇');
    });

    test('getList returns all hrefs', () {
      final results = jsoup.getList(TestHtmlSamples.searchResult, '.book-name@href');
      expect(results, ['/book/12345/', '/book/67890/']);
    });

    test('getList returns authors', () {
      final results = jsoup.getList(TestHtmlSamples.searchResult, '.author@text');
      expect(results, ['忘语', '忘语']);
    });

    test('getAttr returns text for @text', () {
      final el = jsoup.element(TestHtmlSamples.searchResult, '.book-name');
      final text = AnalyzeByJSoup.getAttr(el!, 'text');
      expect(text, '凡人修仙传');
    });

    test('getAttr returns innerHtml for @html', () {
      final el = jsoup.element(TestHtmlSamples.chapterList, 'ul');
      final html = AnalyzeByJSoup.getAttr(el!, 'html');
      expect(html, contains('第一章 山边小村'));
    });

    test('parseRule extracts selector and attr', () {
      final (selector, attr) = jsoup.parseRule('.book-name@href');
      expect(selector, '.book-name');
      expect(attr, 'href');
    });

    test('parseRule defaults to text when no attr', () {
      final (selector, attr) = jsoup.parseRule('.book-name');
      expect(selector, '.book-name');
      expect(attr, 'text');
    });

    test('getFirst handles book detail page', () {
      final name = jsoup.getFirst(TestHtmlSamples.bookDetail, '.book-name@text');
      expect(name, '凡人修仙传');

      final author = jsoup.getFirst(TestHtmlSamples.bookDetail, '.author@text');
      expect(author, '忘语');

      final intro = jsoup.getFirst(TestHtmlSamples.bookDetail, '.intro@text');
      expect(intro, contains('修仙界'));
    });

    test('getList handles chapter list', () {
      final chapters = jsoup.getList(TestHtmlSamples.chapterList, 'li a@text');
      expect(chapters.length, 5);
      expect(chapters.first, '第一章 山边小村');
      expect(chapters.last, '第五章 大衍诀');
    });

    test('getFirst handles chapter list hrefs', () {
      final urls = jsoup.getList(TestHtmlSamples.chapterList, 'li a@href');
      expect(urls.length, 5);
      expect(urls.first, '/read/1.html');
    });
  });
}
