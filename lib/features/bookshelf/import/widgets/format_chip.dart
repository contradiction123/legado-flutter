import 'package:flutter/material.dart';

import '../../../../engine/local_book/base_parser.dart';

/// 格式标签组件
class FormatChip extends StatelessWidget {
  final BookFormat format;

  const FormatChip({super.key, required this.format});

  @override
  Widget build(BuildContext context) {
    final (label, color) = _formatInfo(format);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  (String, Color) _formatInfo(BookFormat format) {
    switch (format) {
      case BookFormat.txt:
        return ('TXT', Colors.blue);
      case BookFormat.epub:
        return ('EPUB', Colors.green);
      case BookFormat.pdf:
        return ('PDF', Colors.red);
      case BookFormat.mobi:
        return ('MOBI', Colors.orange);
      case BookFormat.umd:
        return ('UMD', Colors.purple);
      case BookFormat.unknown:
        return ('?', Colors.grey);
    }
  }
}
