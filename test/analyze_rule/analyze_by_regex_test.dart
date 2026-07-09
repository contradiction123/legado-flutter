import 'package:flutter_test/flutter_test.dart';

import '../../lib/engine/analyze_rule/analyze_by_regex.dart';

void main() {
  late AnalyzeByRegex regex;

  setUp(() {
    regex = AnalyzeByRegex();
  });

  group('AnalyzeByRegex', () {
    test('getString returns first match', () {
      final result = regex.getString('hello 123 world 456', r'\d+');
      expect(result, '123');
    });

    test('getString returns null on no match', () {
      final result = regex.getString('hello world', r'\d+');
      expect(result, isNull);
    });

    test('getString returns null on empty input', () {
      expect(regex.getString('', r'\d+'), isNull);
      expect(regex.getString('hello', ''), isNull);
    });

    test('getGroup returns captured group', () {
      final result = regex.getGroup('书名:凡人修仙传', r'书名:(.+)');
      expect(result, '凡人修仙传');
    });

    test('getStrings returns all matches', () {
      final results = regex.getStrings('a1 b2 c3 d4 e5', r'[a-z](\d)');
      expect(results, ['a1', 'b2', 'c3', 'd4', 'e5']);
    });

    test('getGroups returns all captured groups', () {
      final results = regex.getGroups(
        '<a href="/book/1.html">第一章</a><a href="/book/2.html">第二章</a>',
        r'href="([^"]+)"',
      );
      expect(results, ['/book/1.html', '/book/2.html']);
    });

    test('replace replaces all matches', () {
      final result = regex.replace('hello 123 world 456', r'\d+', 'X');
      expect(result, 'hello X world X');
    });

    test('test returns correct boolean', () {
      expect(regex.test('hello@example.com', r'@'), isTrue);
      expect(regex.test('hello', r'\d+'), isFalse);
    });

    test('split splits by regex', () {
      final result = regex.split('a,b,c', r',');
      expect(result, ['a', 'b', 'c']);
    });

    test('autoGet returns captured group when available', () {
      final result = regex.autoGet('作者:忘语', r'作者:(.+)');
      expect(result, '忘语');
    });

    test('autoGet returns full match when no capture group', () {
      final result = regex.autoGet('hello 123 world', r'\d+');
      expect(result, '123');
    });

    test('handles complex regex patterns', () {
      final text = '<div class="book-name">凡人修仙传</div>';
      final result = regex.getGroup(text, r'class="([^"]+)"');
      expect(result, 'book-name');
    });
  });
}
