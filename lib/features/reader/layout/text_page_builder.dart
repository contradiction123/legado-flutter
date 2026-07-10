import 'package:flutter/material.dart';

import 'layout_models.dart';
import 'text_measurer.dart';

/// 分页排版引擎
///
/// 对标原版：TextChapterLayout.kt + TextPageFactory.kt
///
/// ### 核心算法：
/// 1. 按换行符拆分段落
/// 2. 对每个段落用 TextPainter 排版，通过 getPositionForOffset 获取行断点
/// 3. 逐行计算 Y 坐标，当累积高度超过可见高度时切分新页
/// 4. 每完成一页即输出 TextPage 对象
class TextPageBuilder {
  final LayoutConfig config;
  late final TextMeasurer _measurer;
  TextPageBuilderState _state;

  TextPageBuilder({required this.config, required TextStyle textStyle})
    : _state = TextPageBuilderState() {
    _measurer = TextMeasurer(textStyle: textStyle);
  }

  /// 刷新排版配置
  void updateConfig({LayoutConfig? config, TextStyle? textStyle}) {
    if (config != null) {
      this.config.width = config.width;
      this.config.height = config.height;
      this.config.padding = config.padding;
      this.config.fontSize = config.fontSize;
      this.config.lineHeight = config.lineHeight;
      this.config.paragraphSpacing = config.paragraphSpacing;
    }
    if (textStyle != null) {
      _measurer.updateStyle(textStyle);
    }
  }

  /// 对完整文本进行分页排版
  ChapterLayout buildLayout({
    required String text,
    required int chapterIndex,
    required int chapterCount,
    required String chapterTitle,
  }) {
    _state = TextPageBuilderState();
    final pages = <TextPage>[];

    final paragraphs = _splitParagraphs(text);
    var paragraphNum = 0;
    final pageTextBuffer = StringBuffer();

    for (final paragraph in paragraphs) {
      if (paragraph.isEmpty) {
        paragraphNum++;
        continue;
      }

      // 用 TextPainter 排版段落，获取行信息
      final lineInfos = _layoutParagraph(paragraph);
      paragraphNum++;

      for (var li = 0; li < lineInfos.length; li++) {
        final lineInfo = lineInfos[li];
        final lineHeight = lineInfo.height;

        // 检查是否需要切页
        if (_wouldExceedPage(lineHeight)) {
          _finalizePage(
            pages: pages,
            chapterIndex: chapterIndex,
            chapterCount: chapterCount,
            chapterTitle: chapterTitle,
            pageText: pageTextBuffer.toString(),
          );
          pageTextBuffer.clear();
          _state.resetY();
        }

        // 创建 TextLine
        final paddingTop = config.padding.top;
        final lineTop = _state.currentY + paddingTop;
        final lineBottom = lineTop + lineHeight;
        final textLine = TextLine(
          text: lineInfo.text,
          lineTop: lineTop,
          lineBase: lineBottom - lineInfo.descent,
          lineBottom: lineBottom,
          height: lineHeight,
          paragraphNum: paragraphNum,
          isTitle: false,
          isParagraphEnd: li == lineInfos.length - 1,
        );

        _state.addLine(textLine);
        pageTextBuffer.write(lineInfo.text);

        // 累积 Y 坐标（考虑行高倍率）
        _state.currentY += lineHeight * config.lineHeight;

        // 段落末尾增加段间距
        if (li == lineInfos.length - 1) {
          _state.currentY += config.paragraphSpacing;
        }
      }
    }

    // 完成最后一页
    if (_state.lines.isNotEmpty) {
      _finalizePage(
        pages: pages,
        chapterIndex: chapterIndex,
        chapterCount: chapterCount,
        chapterTitle: chapterTitle,
        pageText: pageTextBuffer.toString(),
      );
    }

    // 修正 pageCount
    final correctedPages = pages.map((page) {
      return TextPage(
        index: page.index,
        chapterIndex: page.chapterIndex,
        chapterPageCount: pages.length,
        chapterTitle: page.chapterTitle,
        lines: page.lines,
        text: page.text,
        height: page.height,
      );
    }).toList();

    return ChapterLayout(
      pages: correctedPages,
      pageCount: correctedPages.length,
      totalChars: text.length,
      isCompleted: true,
    );
  }

  /// 用 TextPainter 排版段落，逐行拆分
  List<_LayoutLine> _layoutParagraph(String text) {
    if (text.isEmpty) return [];

    final textStyle = TextStyle(fontSize: config.fontSize, height: 1.0);

    final painter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(text: text, style: textStyle),
    );

    final availableWidth =
        config.width - config.padding.left - config.padding.right;
    painter.layout(maxWidth: availableWidth);

    // 使用 preferredLineHeight 作为行高参考
    final lineHeight = painter.preferredLineHeight;
    final fullHeight = painter.height;
    final lineCount = (fullHeight / lineHeight).ceil();

    final lines = <_LayoutLine>[];
    var charOffset = 0;

    for (var i = 0; i < lineCount; i++) {
      if (charOffset >= text.length) break;

      // 找到当前行的结束位置
      // 用 TextPainter 获取在（availableWidth, 行中线）处的字符位置
      final midY = lineHeight * (i + 0.5);
      final endPos = painter.getPositionForOffset(Offset(availableWidth, midY));
      var endChar = endPos.offset.clamp(charOffset + 1, text.length);

      // 确保结尾不会是空行
      if (endChar <= charOffset) {
        endChar = (charOffset + 100).clamp(0, text.length);
      }

      final lineText = text.substring(charOffset, endChar).trimRight();
      if (lineText.isEmpty) {
        charOffset = endChar;
        continue;
      }

      lines.add(
        _LayoutLine(
          text: lineText,
          height: lineHeight,
          descent: lineHeight * 0.2, // 近似计算 descent
          startIndex: charOffset,
          endIndex: endChar,
        ),
      );

      charOffset = endChar;
    }

    return lines;
  }

  /// 判断是否超出页面高度
  bool _wouldExceedPage(double lineHeight) {
    final availableHeight =
        config.height - config.padding.top - config.padding.bottom;
    return _state.currentY + lineHeight > availableHeight;
  }

  /// 完成一页
  void _finalizePage({
    required List<TextPage> pages,
    required int chapterIndex,
    required int chapterCount,
    required String chapterTitle,
    required String pageText,
  }) {
    final page = TextPage(
      index: pages.length,
      chapterIndex: chapterIndex,
      chapterPageCount: 0,
      chapterTitle: chapterTitle,
      lines: List.from(_state.lines),
      text: pageText,
      height: _state.currentY + config.padding.top + config.padding.bottom,
    );
    pages.add(page);
    _state.clear();
  }

  /// 按换行符拆分段落
  List<String> _splitParagraphs(String text) {
    final normalized = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    return normalized.split('\n');
  }
}

/// 排版配置
class LayoutConfig {
  double width;
  double height;
  EdgeInsets padding;
  double fontSize;
  double lineHeight;
  double paragraphSpacing;

  LayoutConfig({
    this.width = 375,
    this.height = 667,
    EdgeInsets? padding,
    this.fontSize = 18,
    this.lineHeight = 1.8,
    this.paragraphSpacing = 12,
  }) : padding = padding ?? const EdgeInsets.fromLTRB(20, 18, 20, 18);
}

/// 排版过程中的状态
class TextPageBuilderState {
  double currentY = 0;
  final List<TextLine> lines = [];

  void resetY() {
    currentY = 0;
  }

  void addLine(TextLine line) {
    lines.add(line);
  }

  void clear() {
    lines.clear();
  }
}

/// 排版引擎输出的行信息
class _LayoutLine {
  final String text;
  final double height;
  final double descent;
  final int startIndex;
  final int endIndex;

  const _LayoutLine({
    required this.text,
    required this.height,
    required this.descent,
    required this.startIndex,
    required this.endIndex,
  });
}
