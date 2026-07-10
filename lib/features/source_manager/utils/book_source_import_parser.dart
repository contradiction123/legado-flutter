import 'dart:convert';

import '../../../domain/models/book_source.dart';

class BookSourceImportParser {
  const BookSourceImportParser._();

  static List<BookSource> parseJsonText(String jsonText) {
    final decoded = jsonDecode(jsonText);
    return parseJsonValue(decoded);
  }

  static List<BookSource> parseJsonValue(dynamic decoded) {
    final entries = decoded is List ? decoded : [decoded];
    final sources = <BookSource>[];

    for (final entry in entries) {
      final source = _parseEntry(entry);
      if (source != null) {
        sources.add(source);
      }
    }

    return sources;
  }

  static BookSource? _parseEntry(dynamic entry) {
    if (entry is String) {
      return _parseEntry(jsonDecode(entry));
    }
    if (entry is! Map) {
      return null;
    }

    final map = Map<String, dynamic>.from(entry);
    final bookSourceUrl = _readString(map['bookSourceUrl']);
    final bookSourceName = _readString(map['bookSourceName']);
    if (bookSourceUrl == null || bookSourceUrl.isEmpty) {
      return null;
    }
    if (bookSourceName == null || bookSourceName.isEmpty) {
      return null;
    }

    return BookSource(
      bookSourceUrl: bookSourceUrl,
      bookSourceName: bookSourceName,
      bookSourceGroup: _readNullableString(map['bookSourceGroup']),
      bookSourceType: _readInt(map['bookSourceType'], 0),
      bookUrlPattern: _readNullableString(map['bookUrlPattern']),
      customOrder: _readInt(map['customOrder'], 0),
      enabled: _readBool(map['enabled'], true),
      enabledExplore: _readBool(map['enabledExplore'], true),
      jsLib: _readNullableString(map['jsLib']),
      enabledCookieJar: _readNullableBool(map['enabledCookieJar']),
      concurrentRate: _readNullableString(map['concurrentRate']),
      header: _readHeader(map['header']),
      loginUrl: _readNullableString(map['loginUrl']),
      loginUi: _readNullableString(map['loginUi']),
      loginCheckJs: _readNullableString(map['loginCheckJs']),
      coverDecodeJs: _readNullableString(map['coverDecodeJs']),
      bookSourceComment: _readNullableString(map['bookSourceComment']),
      variableComment: _readNullableString(map['variableComment']),
      lastUpdateTime: _readInt(map['lastUpdateTime'], 0),
      respondTime: _readInt(map['respondTime'], 180000),
      weight: _readInt(map['weight'], 0),
      exploreUrl: _readNullableString(map['exploreUrl']),
      exploreScreen: _readNullableString(map['exploreScreen']),
      ruleExplore: _readNullableRuleString(map['ruleExplore']),
      searchUrl: _readNullableString(map['searchUrl']),
      ruleSearch: _readNullableRuleString(map['ruleSearch']),
      ruleBookInfo: _readNullableRuleString(map['ruleBookInfo']),
      ruleToc: _readNullableRuleString(map['ruleToc']),
      ruleContent: _readNullableRuleString(map['ruleContent']),
      ruleReview: _readNullableRuleString(map['ruleReview']),
      eventListener: _readBool(map['eventListener'], false),
      customButton: _readBool(map['customButton'], false),
      homepageModules: _readNullableString(map['homepageModules']),
    );
  }

  static String? _readString(dynamic value) {
    final text = _readNullableString(value);
    return text == null || text.isEmpty ? null : text;
  }

  static String? _readNullableString(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    if (value is num || value is bool) {
      return value.toString();
    }
    return jsonEncode(value);
  }

  static String? _readNullableRuleString(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return jsonEncode(value);
  }

  static int _readInt(dynamic value, int fallback) {
    if (value == null) return fallback;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? fallback;
    return fallback;
  }

  static bool _readBool(dynamic value, bool fallback) {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      switch (value.trim().toLowerCase()) {
        case 'true':
        case '1':
          return true;
        case 'false':
        case '0':
          return false;
      }
    }
    return fallback;
  }

  static bool? _readNullableBool(dynamic value) {
    if (value == null) return null;
    return _readBool(value, false);
  }

  static Map<String, String>? _readHeader(dynamic value) {
    dynamic source = value;
    if (source is String) {
      final trimmed = source.trim();
      if (trimmed.isEmpty) return null;
      try {
        source = jsonDecode(trimmed);
      } catch (_) {
        return null;
      }
    }
    if (source is! Map) {
      return null;
    }
    return source.map(
      (key, entryValue) => MapEntry(key.toString(), entryValue?.toString() ?? ''),
    );
  }
}
