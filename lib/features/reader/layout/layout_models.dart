/// 分页排版数据模型
///
/// 对标原版 Kotlin：TextLine.kt / TextPage.kt / TextParagraph.kt / TextPos.kt
///
/// 核心概念：
///   文本 → 段落(TextParagraph) → 行(TextLine) → 字符列(CharColumn)
///   多个段落/行组合成一页(TextPage)
///   所有页构成一个章节排版结果(ChapterLayout)

/// 章节排版结果（对标 TextChapter 的部分功能）
class ChapterLayout {
  /// 页面列表
  final List<TextPage> pages;

  /// 总页数
  final int pageCount;

  /// 总字数
  final int totalChars;

  /// 排版是否完成
  final bool isCompleted;

  const ChapterLayout({
    this.pages = const [],
    this.pageCount = 0,
    this.totalChars = 0,
    this.isCompleted = false,
  });
}

/// 单页数据（对标 TextPage.kt）
class TextPage {
  /// 页索引（在章节内的第几页）
  final int index;

  /// 所属章节索引
  final int chapterIndex;

  /// 章节总页数
  final int chapterPageCount;

  /// 章节标题
  final String chapterTitle;

  /// 页内行列表
  final List<TextLine> lines;

  /// 页内完整文本
  final String text;

  /// 页高度
  final double height;

  const TextPage({
    this.index = 0,
    this.chapterIndex = 0,
    this.chapterPageCount = 0,
    this.chapterTitle = '',
    this.lines = const [],
    this.text = '',
    this.height = 0,
  });

  int get lineCount => lines.length;

  int get charCount => text.length;

  /// 获取该页的阅读进度百分比的表示字符串
  /// 对标原版 TextPage.readProgress
  String get readProgress {
    if (chapterPageCount <= 1) {
      final progress = (chapterIndex + 1) / chapterPageCount.clamp(1, 999);
      return '${(progress * 100).toStringAsFixed(1)}%';
    }
    final progress =
        chapterIndex / chapterPageCount +
        (1.0 / chapterPageCount) *
            ((index + 1) / chapterPageCount.clamp(1, 999));
    return '${(progress * 100).clamp(0, 100).toStringAsFixed(1)}%';
  }
}

/// 单行数据（对标 TextLine.kt）
class TextLine {
  /// 行文本
  final String text;

  /// 行顶部 Y 坐标（相对页顶）
  final double lineTop;

  /// 行基线 Y 坐标
  final double lineBase;

  /// 行底部 Y 坐标
  final double lineBottom;

  /// 行高度
  final double height;

  /// 段落编号
  final int paragraphNum;

  /// 是否是标题行
  final bool isTitle;

  /// 是否是段落末尾
  final bool isParagraphEnd;

  /// 字符列列表
  final List<CharColumn> columns;

  const TextLine({
    this.text = '',
    this.lineTop = 0,
    this.lineBase = 0,
    this.lineBottom = 0,
    this.height = 0,
    this.paragraphNum = 0,
    this.isTitle = false,
    this.isParagraphEnd = false,
    this.columns = const [],
  });
}

/// 字符列（对标 BaseColumn / TextColumn.kt）
class CharColumn {
  /// 字符文本
  final String char;

  /// 起始 X 坐标
  final double start;

  /// 结束 X 坐标
  final double end;

  /// 字符宽度
  final double width;

  /// 是否是图片占位
  final bool isImage;

  const CharColumn({
    required this.char,
    this.start = 0,
    this.end = 0,
    this.width = 0,
    this.isImage = false,
  });
}

/// 段落数据（对标 TextParagraph.kt）
class TextParagraph {
  /// 段落编号
  final int num;

  /// 段落文本
  final String text;

  /// 段落行列表
  final List<TextLine> lines;

  /// 段落起始字符在章节中的位置
  final int chapterPosition;

  const TextParagraph({
    this.num = 0,
    this.text = '',
    this.lines = const [],
    this.chapterPosition = 0,
  });

  int get length => text.length;
}

/// 文本位置（对标 TextPos.kt）
class TextPosition {
  /// 相对页位置
  final int relativePagePos;

  /// 行索引
  final int lineIndex;

  /// 列（字符）索引
  final int columnIndex;

  const TextPosition({
    this.relativePagePos = 0,
    this.lineIndex = -1,
    this.columnIndex = -1,
  });

  bool get isSelected => lineIndex >= 0 && columnIndex >= 0;

  /// 比较两个位置
  /// 返回负值表示 this < other，正值表示 this > other，0 表示相等
  int compare(TextPosition other) {
    if (relativePagePos != other.relativePagePos) {
      return relativePagePos < other.relativePagePos ? -3 : 3;
    }
    if (lineIndex != other.lineIndex) {
      return lineIndex < other.lineIndex ? -2 : 2;
    }
    if (columnIndex != other.columnIndex) {
      return columnIndex < other.columnIndex ? -1 : 1;
    }
    return 0;
  }
}
