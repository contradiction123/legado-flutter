import 'compiled_script.dart';
import 'js_engine_wrapper.dart';

/// 书源 JS 共享作用域
///
/// 对标原：NativeBaseSource.kt 中的 SharedJsScope 机制
/// 用于管理书源 JS 库（jsLib）的共享执行环境
///
/// 一个书源可以定义 jsLib 字段（JS 库代码），
/// 该 JS 库在书源首次使用时被编译并缓存到共享作用域中，
/// 书源的搜索/详情/目录/正文规则都可以引用其中定义的函数。
class SharedJsScope {
  final JsEngine _engine;
  final ScriptCache _cache;
  final Map<String, bool> _initializedSources = {};

  SharedJsScope(this._engine) : _cache = ScriptCache(maxSize: 16);

  /// 初始化书源的 JS 库环境
  ///
  /// [sourceKey] 书源唯一标识（bookSourceUrl）
  /// [jsLib] 书源的 JS 库代码
  void initializeSource(String sourceKey, String jsLib) {
    if (_initializedSources[sourceKey] == true) return;
    if (jsLib.isEmpty) return;

    // 缓存编译后的脚本
    _cache.put(sourceKey, CompiledScript(
      source: jsLib,
      sourceUrl: 'jsLib:$sourceKey',
    ));

    // 注入 JS 库到 QuickJS 运行时
    _engine.evaluate(jsLib, sourceUrl: 'jsLib:$sourceKey');
    _initializedSources[sourceKey] = true;
  }

  /// 执行书源规则脚本（在 JS 库已加载的环境中）
  ///
  /// [sourceKey] 书源唯一标识
  /// [script] 规则 JS 代码
  /// 返回执行结果字符串
  String evaluateInScope(String sourceKey, String script) {
    return _engine.evaluate(script, sourceUrl: 'rule:$sourceKey').stringResult;
  }

  /// 释放书源作用域
  void disposeSource(String sourceKey) {
    _initializedSources.remove(sourceKey);
    // 注意：flutter_js 不支持单独移除某个注入的脚本，
    // 释放仅清除缓存和标记，下次用时会重新注入
  }

  /// 清空所有作用域
  void clear() {
    _initializedSources.clear();
    _cache.clear();
  }
}
