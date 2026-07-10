import 'package:flutter_riverpod/legacy.dart';

import '../../../domain/models/book_source.dart';

/// 调试步骤枚举
enum DebugStep {
  search('搜索', '执行搜索并解析结果'),
  bookInfo('书籍详情', '获取并解析书籍详情'),
  chapterList('目录', '获取并解析章节列表'),
  chapterContent('正文', '获取并解析章节正文');

  final String label;
  final String description;
  const DebugStep(this.label, this.description);
}

/// 单步调试结果
class DebugStepResult {
  final DebugStep step;
  final String input;
  final String? requestResult;
  final String? parsedResult;
  final String? error;
  final DateTime timestamp;

  DebugStepResult({
    required this.step,
    required this.input,
    this.requestResult,
    this.parsedResult,
    this.error,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  DebugStepResult copyWith({
    DebugStep? step,
    String? input,
    String? requestResult,
    String? parsedResult,
    String? error,
    DateTime? timestamp,
  }) {
    return DebugStepResult(
      step: step ?? this.step,
      input: input ?? this.input,
      requestResult: requestResult ?? this.requestResult,
      parsedResult: parsedResult ?? this.parsedResult,
      error: error ?? this.error,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// 是否成功（无错误且有请求结果）
  bool get isSuccess => error == null && requestResult != null;

  /// 是否有错误
  bool get hasError => error != null;
}

/// 调试状态
class DebugState {
  /// 当前选中的书源
  final BookSource? selectedSource;

  /// 输入的搜索关键词或 URL
  final String inputText;

  /// 各步骤的结果
  final Map<DebugStep, DebugStepResult> results;

  /// 当前正在运行的步骤
  final DebugStep? runningStep;

  /// 是否正在运行所有步骤
  final bool isRunningAll;

  /// 全局错误信息
  final String? error;

  const DebugState({
    this.selectedSource,
    this.inputText = '',
    this.results = const {},
    this.runningStep,
    this.isRunningAll = false,
    this.error,
  });

  DebugState copyWith({
    BookSource? selectedSource,
    String? inputText,
    Map<DebugStep, DebugStepResult>? results,
    DebugStep? runningStep,
    bool? isRunningAll,
    String? error,
    bool clearSelectedSource = false,
    bool clearRunningStep = false,
    bool clearError = false,
  }) {
    return DebugState(
      selectedSource: clearSelectedSource
          ? null
          : (selectedSource ?? this.selectedSource),
      inputText: inputText ?? this.inputText,
      results: results ?? this.results,
      runningStep: clearRunningStep ? null : (runningStep ?? this.runningStep),
      isRunningAll: isRunningAll ?? this.isRunningAll,
      error: clearError ? null : (error ?? this.error),
    );
  }

  factory DebugState.initial() => const DebugState();

  /// 获取指定步骤的结果
  DebugStepResult? resultFor(DebugStep step) => results[step];

  /// 是否有任何步骤已执行
  bool get hasAnyResult => results.isNotEmpty;

  /// 所有步骤都成功
  bool get allSuccess => DebugStep.values.every((step) {
    final r = results[step];
    return r != null && r.error == null;
  });
}

/// 书源调试器状态管理
///
/// 用于调试书源各步骤（搜索、详情、目录、正文）的请求和解析结果。
/// 每个步骤独立运行，也可一键执行全部步骤。
class DebugProvider extends StateNotifier<DebugState> {
  DebugProvider() : super(DebugState.initial());

  /// 设置当前调试的书源
  void selectSource(BookSource? source) {
    state = state.copyWith(
      selectedSource: source,
      clearSelectedSource: source == null,
    );
  }

  /// 设置输入文本（搜索关键词或 URL）
  void setInputText(String text) {
    state = state.copyWith(inputText: text);
  }

  /// 重置所有调试结果
  void clearResults() {
    state = state.copyWith(results: {}, error: null, clearRunningStep: true);
  }

  /// 运行单个调试步骤
  Future<void> runStep(DebugStep step) async {
    final input = state.inputText.trim();
    if (input.isEmpty) {
      state = state.copyWith(error: '请输入关键词或 URL');
      return;
    }

    if (state.selectedSource == null) {
      state = state.copyWith(error: '请先选择一个书源');
      return;
    }

    state = state.copyWith(runningStep: step, error: null);

    try {
      // 根据步骤类型执行对应的调试逻辑
      // 这里调用底层引擎或网络层来实际执行
      DebugStepResult result;

      switch (step) {
        case DebugStep.search:
          result = await _debugSearch(input);
          break;
        case DebugStep.bookInfo:
          result = await _debugBookInfo(input);
          break;
        case DebugStep.chapterList:
          result = await _debugChapterList(input);
          break;
        case DebugStep.chapterContent:
          result = await _debugChapterContent(input);
          break;
      }

      final updatedResults = Map<DebugStep, DebugStepResult>.from(state.results)
        ..[step] = result;

      state = state.copyWith(results: updatedResults, clearRunningStep: true);
    } catch (e) {
      final errorResult = DebugStepResult(
        step: step,
        input: input,
        error: e.toString(),
      );

      final updatedResults = Map<DebugStep, DebugStepResult>.from(state.results)
        ..[step] = errorResult;

      state = state.copyWith(results: updatedResults, clearRunningStep: true);
    }
  }

  /// 运行所有调试步骤（按顺序）
  Future<void> runAllSteps() async {
    if (state.inputText.trim().isEmpty) {
      state = state.copyWith(error: '请输入关键词或 URL');
      return;
    }

    if (state.selectedSource == null) {
      state = state.copyWith(error: '请先选择一个书源');
      return;
    }

    state = state.copyWith(isRunningAll: true, error: null);

    for (final step in DebugStep.values) {
      await runStep(step);
      if (state.error != null) break;
    }

    state = state.copyWith(isRunningAll: false);
  }

  /// 调试搜索步骤
  Future<DebugStepResult> _debugSearch(String keyword) async {
    final source = state.selectedSource!;

    try {
      // 构造搜索 URL
      final searchUrl = source.searchUrl?.replaceAll('{{key}}', keyword) ?? '';
      final ruleSearch = source.ruleSearch ?? '';

      // TODO: 执行实际的网络请求和规则解析
      // 此处为模拟实现，实际应调用 WebBook 引擎
      final requestResult = '模拟请求: $searchUrl\n使用规则: $ruleSearch';
      final parsedResult = '模拟解析结果:\n  共找到 0 个搜索结果';

      return DebugStepResult(
        step: DebugStep.search,
        input: keyword,
        requestResult: requestResult,
        parsedResult: parsedResult,
      );
    } catch (e) {
      return DebugStepResult(
        step: DebugStep.search,
        input: keyword,
        error: '搜索失败: $e',
      );
    }
  }

  /// 调试书籍详情步骤
  Future<DebugStepResult> _debugBookInfo(String url) async {
    final source = state.selectedSource!;

    try {
      final bookInfoUrl = url; // 需要完整 URL
      final ruleBookInfo = source.ruleBookInfo ?? '';

      // TODO: 执行实际的网络请求和规则解析
      final requestResult = '模拟请求: $bookInfoUrl\n使用规则: $ruleBookInfo';
      final parsedResult = '模拟解析结果:\n  书名: 示例书籍\n  作者: 示例作者';

      return DebugStepResult(
        step: DebugStep.bookInfo,
        input: url,
        requestResult: requestResult,
        parsedResult: parsedResult,
      );
    } catch (e) {
      return DebugStepResult(
        step: DebugStep.bookInfo,
        input: url,
        error: '获取详情失败: $e',
      );
    }
  }

  /// 调试目录步骤
  Future<DebugStepResult> _debugChapterList(String url) async {
    final source = state.selectedSource!;

    try {
      final tocUrl = url;
      final ruleToc = source.ruleToc ?? '';

      // TODO: 执行实际的网络请求和规则解析
      final requestResult = '模拟请求: $tocUrl\n使用规则: $ruleToc';
      final parsedResult = '模拟解析结果:\n  共 0 个章节';

      return DebugStepResult(
        step: DebugStep.chapterList,
        input: url,
        requestResult: requestResult,
        parsedResult: parsedResult,
      );
    } catch (e) {
      return DebugStepResult(
        step: DebugStep.chapterList,
        input: url,
        error: '获取目录失败: $e',
      );
    }
  }

  /// 调试正文步骤
  Future<DebugStepResult> _debugChapterContent(String url) async {
    final source = state.selectedSource!;

    try {
      final contentUrl = url;
      final ruleContent = source.ruleContent ?? '';

      // TODO: 执行实际的网络请求和规则解析
      final requestResult = '模拟请求: $contentUrl\n使用规则: $ruleContent';
      final parsedResult = '模拟解析结果:\n  正文内容...（截取前 500 字）';

      return DebugStepResult(
        step: DebugStep.chapterContent,
        input: url,
        requestResult: requestResult,
        parsedResult: parsedResult,
      );
    } catch (e) {
      return DebugStepResult(
        step: DebugStep.chapterContent,
        input: url,
        error: '获取正文失败: $e',
      );
    }
  }
}

/// 书源调试器状态提供者
final debugProvider = StateNotifierProvider<DebugProvider, DebugState>((ref) {
  return DebugProvider();
});
