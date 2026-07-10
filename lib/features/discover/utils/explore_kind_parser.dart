import 'dart:convert';

import '../../../domain/models/book_source.dart';
import '../models/explore_kind.dart';

List<ExploreKind> parseExploreKinds(BookSource source) {
  final raw = source.exploreUrl?.trim();
  if (raw == null || raw.isEmpty) {
    return const [];
  }

  if (_looksLikeJsonArray(raw)) {
    final jsonKinds = _parseJsonKinds(raw);
    if (jsonKinds.isNotEmpty) {
      return jsonKinds;
    }
  }

  return raw
      .split(RegExp(r'(&&|\n)+'))
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .map(_parseLegacyKind)
      .toList(growable: false);
}

List<List<(ExploreKind, int)>> calculateExploreKindRows(
  List<ExploreKind> kinds,
  int maxSpan,
) {
  final rows = <List<(ExploreKind, int)>>[];
  var currentRow = <(ExploreKind, int)>[];
  var currentSpan = 0;

  void fillCurrentRowTail() {
    if (currentRow.isEmpty) return;
    final remain = maxSpan - currentSpan;
    if (remain <= 0) return;

    final distinctSpans = currentRow.map((item) => item.$2).toSet();
    if (distinctSpans.length == 1 && currentRow.length > 1) {
      final addEach = remain ~/ currentRow.length;
      var extra = remain % currentRow.length;
      for (var i = 0; i < currentRow.length; i++) {
        final (kind, span) = currentRow[i];
        final add = addEach + (extra > 0 ? 1 : 0);
        if (extra > 0) extra--;
        currentRow[i] = (kind, span + add);
      }
    } else {
      final (kind, span) = currentRow.last;
      currentRow[currentRow.length - 1] = (kind, span + remain);
    }
    currentSpan += remain;
  }

  for (final kind in kinds) {
    final span = _resolveSpan(kind, maxSpan);
    final style = kind.style;
    final shouldWrap =
        (style.layoutWrapBefore && currentRow.isNotEmpty) ||
        (currentSpan + span > maxSpan);
    if (shouldWrap) {
      fillCurrentRowTail();
      rows.add(List.unmodifiable(currentRow));
      currentRow = <(ExploreKind, int)>[];
      currentSpan = 0;
    }

    currentRow.add((kind, span));
    currentSpan += span;

    if (currentSpan >= maxSpan) {
      rows.add(List.unmodifiable(currentRow));
      currentRow = <(ExploreKind, int)>[];
      currentSpan = 0;
    }
  }

  if (currentRow.isNotEmpty) {
    fillCurrentRowTail();
    rows.add(List.unmodifiable(currentRow));
  }

  return List.unmodifiable(rows);
}

bool _looksLikeJsonArray(String text) {
  final trimmed = text.trimLeft();
  return trimmed.startsWith('[') && trimmed.endsWith(']');
}

List<ExploreKind> _parseJsonKinds(String raw) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((item) => ExploreKind.fromJson(Map<String, dynamic>.from(item)))
        .where((item) => item.title.trim().isNotEmpty)
        .toList(growable: false);
  } catch (_) {
    return const [];
  }
}

ExploreKind _parseLegacyKind(String raw) {
  final split = raw.split('::');
  final title = split.first.trim();
  final url = split.length > 1 ? split.sublist(1).join('::').trim() : raw;
  return ExploreKind(
    title: title.isEmpty ? raw : title,
    url: url.isEmpty ? null : url,
  );
}

int _resolveSpan(ExploreKind kind, int maxSpan) {
  final style = kind.style;
  if (style.layoutWrapBefore || style.layoutFlexBasisPercent >= 1) {
    return maxSpan;
  }
  if (style.layoutFlexBasisPercent > 0) {
    final value = (maxSpan * style.layoutFlexBasisPercent).round();
    return value.clamp(1, maxSpan);
  }
  if (style.layoutFlexGrow > 0) {
    return 3;
  }
  return 2;
}
