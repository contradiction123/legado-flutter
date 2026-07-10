class FlexChildStyle {
  const FlexChildStyle({
    this.layoutFlexGrow = 0,
    this.layoutFlexShrink = 1,
    this.layoutAlignSelf = 'auto',
    this.layoutFlexBasisPercent = -1,
    this.layoutWrapBefore = false,
    this.layoutJustifySelf = 'auto',
  });

  final double layoutFlexGrow;
  final double layoutFlexShrink;
  final String layoutAlignSelf;
  final double layoutFlexBasisPercent;
  final bool layoutWrapBefore;
  final String layoutJustifySelf;

  static const FlexChildStyle defaultStyle = FlexChildStyle();

  factory FlexChildStyle.fromJson(Map<String, dynamic> json) {
    return FlexChildStyle(
      layoutFlexGrow: _readDouble(json['layout_flexGrow'], fallback: 0),
      layoutFlexShrink: _readDouble(json['layout_flexShrink'], fallback: 1),
      layoutAlignSelf:
          json['layout_alignSelf']?.toString().trim().isNotEmpty == true
          ? json['layout_alignSelf'].toString()
          : 'auto',
      layoutFlexBasisPercent: _readDouble(
        json['layout_flexBasisPercent'],
        fallback: -1,
      ),
      layoutWrapBefore: _readBool(json['layout_wrapBefore']),
      layoutJustifySelf:
          json['layout_justifySelf']?.toString().trim().isNotEmpty == true
          ? json['layout_justifySelf'].toString()
          : 'auto',
    );
  }
}

class ExploreKind {
  const ExploreKind({
    required this.title,
    this.url,
    this.type = ExploreKindType.url,
    this.action,
    this.chars,
    this.defaultValue,
    this.viewName,
    this.style = FlexChildStyle.defaultStyle,
  });

  final String title;
  final String? url;
  final String type;
  final String? action;
  final List<String>? chars;
  final String? defaultValue;
  final String? viewName;
  final FlexChildStyle style;

  factory ExploreKind.fromJson(Map<String, dynamic> json) {
    return ExploreKind(
      title: json['title']?.toString() ?? '',
      url: _readNullableString(json['url']),
      type: _readNullableString(json['type']) ?? ExploreKindType.url,
      action: _readNullableString(json['action']),
      chars: _readStringList(json['chars']),
      defaultValue: _readNullableString(json['default']),
      viewName: _readNullableString(json['viewName']),
      style: json['style'] is Map<String, dynamic>
          ? FlexChildStyle.fromJson(json['style'] as Map<String, dynamic>)
          : json['style'] is Map
          ? FlexChildStyle.fromJson(
              Map<String, dynamic>.from(json['style'] as Map),
            )
          : FlexChildStyle.defaultStyle,
    );
  }
}

abstract final class ExploreKindType {
  static const String url = 'url';
  static const String text = 'text';
  static const String button = 'button';
  static const String toggle = 'toggle';
  static const String select = 'select';
}

double _readDouble(dynamic value, {required double fallback}) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

bool _readBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }
  return false;
}

String? _readNullableString(dynamic value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

List<String>? _readStringList(dynamic value) {
  if (value is! List) return null;
  final items = value
      .map((item) => item?.toString().trim() ?? '')
      .where((item) => item.isNotEmpty)
      .toList(growable: false);
  return items.isEmpty ? null : items;
}
