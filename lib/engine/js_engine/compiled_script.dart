import 'dart:collection';

/// 脚本编译缓存（LRU，最多 16 项）
///
/// 对标原：RhinoCompiledScript.kt
/// 用于缓存已编译的 JS 脚本，避免重复编译
class CompiledScript {
  final String source;
  final String sourceUrl;

  const CompiledScript({
    required this.source,
    required this.sourceUrl,
  });
}

/// LRU 脚本缓存
///
/// 对标原：RhinoScriptEngine.scriptCache（最多 16 项）
/// 使用 LinkedHashMap 实现 LRU 淘汰
class ScriptCache {
  final int maxSize;
  final LinkedHashMap<String, CompiledScript> _cache;

  ScriptCache({this.maxSize = 16})
      : _cache = LinkedHashMap<String, CompiledScript>();

  /// 获取缓存的编译脚本
  CompiledScript? get(String key) {
    final script = _cache[key];
    if (script != null) {
      // 移动到末尾（最近使用）
      _cache.remove(key);
      _cache[key] = script;
    }
    return script;
  }

  /// 存入缓存
  void put(String key, CompiledScript script) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    } else if (_cache.length >= maxSize) {
      // 淘汰最久未使用的（第一个）
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = script;
  }

  /// 清空缓存
  void clear() => _cache.clear();

  /// 当前缓存大小
  int get size => _cache.length;

  /// 是否包含指定 key
  bool containsKey(String key) => _cache.containsKey(key);
}
