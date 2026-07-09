import 'package:flutter_test/flutter_test.dart';

import '../../lib/engine/analyze_rule/analyze_by_jsonpath.dart';
import '../data/test_html_samples.dart';

void main() {
  late AnalyzeByJsonPath jsonPath;

  setUp(() {
    jsonPath = AnalyzeByJsonPath();
  });

  group('AnalyzeByJsonPath', () {
    test('getStrings returns matching values', () {
      final results = jsonPath.getStrings(
        TestHtmlSamples.jsonSearchResult,
        r'$.data.list[*].title',
      );
      expect(results, ['凡人修仙传']);
    });

    test('getStrings returns multiple matches', () {
      final results = jsonPath.getStrings(
        TestHtmlSamples.jsonSearchResult,
        r'$.data.list[*].author',
      );
      expect(results, ['忘语']);
    });

    test('getString returns first match', () {
      final result = jsonPath.getString(
        TestHtmlSamples.jsonSearchResult,
        r'$.data.list[*].title',
      );
      expect(result, '凡人修仙传');
    });

    test('getStrings returns empty on no match', () {
      final results = jsonPath.getStrings(
        TestHtmlSamples.jsonSearchResult,
        r'$.data.nonexistent',
      );
      expect(results, isEmpty);
    });

    test('getStrings returns empty on empty input', () {
      expect(jsonPath.getStrings('', r'$'), isEmpty);
      expect(jsonPath.getStrings('{}', ''), isEmpty);
    });

    test('getObjects returns parsed objects', () {
      final objects = jsonPath.getObjects(
        TestHtmlSamples.jsonSearchResult,
        r'$.data.list[*]',
      );
      expect(objects.length, 1);
      expect(objects[0], isA<Map>());
      expect((objects[0] as Map)['title'], '凡人修仙传');
    });

    test('getObject returns first object', () {
      final obj = jsonPath.getObject(
        TestHtmlSamples.jsonSearchResult,
        r'$.data.list[0]',
      );
      expect(obj, isNotNull);
      expect((obj as Map)['bookId'], '12345');
    });

    test('exists returns true when path exists', () {
      expect(
        jsonPath.exists(TestHtmlSamples.jsonSearchResult, r'$.data'),
        isTrue,
      );
    });

    test('exists returns false when path does not exist', () {
      expect(
        jsonPath.exists(TestHtmlSamples.jsonSearchResult, r'$.missing'),
        isFalse,
      );
    });

    test('handles nested path extraction', () {
      final result = jsonPath.getString(
        TestHtmlSamples.jsonSearchResult,
        r'$..latestChapter',
      );
      expect(result, '第一千三百章');
    });
  });
}
