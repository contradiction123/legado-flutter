import 'package:flutter_test/flutter_test.dart';

import '../../lib/engine/analyze_rule/analyze_by_xpath.dart';
import '../data/test_html_samples.dart';

void main() {
  late AnalyzeByXPath xpath;

  setUp(() {
    xpath = AnalyzeByXPath();
  });

  group('AnalyzeByXPath', () {
    test('getStrings returns matching nodes', () {
      final results = xpath.getStrings(
        TestHtmlSamples.searchResult,
        '//a[@class="book-name"]',
      );
      expect(results.length, 2);
    });

    test('getStrings returns empty on no match', () {
      final results = xpath.getStrings(
        TestHtmlSamples.searchResult,
        '//nonexistent',
      );
      expect(results, isEmpty);
    });

    test('getStrings returns empty on empty input', () {
      expect(xpath.getStrings('', '//div'), isEmpty);
      expect(xpath.getStrings('<div></div>', ''), isEmpty);
    });

    test('getString returns first match', () {
      final result = xpath.getString(
        TestHtmlSamples.searchResult,
        '//span[@class="author"]',
      );
      expect(result, '忘语');
    });

    test('getStrings with attribute query', () {
      final results = xpath.getStrings(
        TestHtmlSamples.searchResult,
        '//a[@class="book-name"]/@href',
      );
      expect(results.length, 2);
      expect(results[0], '/book/12345/');
    });

    test('getTexts returns filtered texts', () {
      final results = xpath.getTexts(
        TestHtmlSamples.searchResult,
        '//span[@class="author"]',
      );
      // There are 2 author spans with "忘语"
      expect(results.length, 2);
      expect(results, contains('忘语'));
    });

    test('exists returns true when match found', () {
      final result = xpath.exists(
        TestHtmlSamples.searchResult,
        '//div[@class="result-list"]',
      );
      expect(result, isTrue);
    });

    test('exists returns false when no match', () {
      final result = xpath.exists(
        TestHtmlSamples.searchResult,
        '//div[@class="no-such-class"]',
      );
      expect(result, isFalse);
    });

    test('handles book detail page with XPath', () {
      final name = xpath.getString(
        TestHtmlSamples.bookDetail,
        '//h1[@class="book-name"]',
      );
      expect(name, '凡人修仙传');
    });

    test('handles chapter list with XPath', () {
      final chapters = xpath.getStrings(
        TestHtmlSamples.chapterList,
        '//li/a',
      );
      expect(chapters.length, 5);
    });

    test('handles content extraction', () {
      final content = xpath.getString(
        TestHtmlSamples.bookContent,
        '//div[@id="content"]',
      );
      expect(content, contains('韩立盘膝坐在洞府之中'));
    });

    test('uses position predicate [1]', () {
      final first = xpath.getString(
        TestHtmlSamples.searchResult,
        '//div[@class="result-item"][1]//a',
      );
      expect(first, '凡人修仙传');
    });

    test('uses position predicate [2] for second item', () {
      final second = xpath.getString(
        TestHtmlSamples.searchResult,
        '//div[@class="result-item"][2]//a',
      );
      expect(second, '凡人修仙传·仙界篇');
    });
  });
}
