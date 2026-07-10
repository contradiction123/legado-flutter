import 'dart:async';
import 'dart:convert';

import 'package:flutter_js/flutter_js.dart';

/// JS 执行结果
class JsResult {
  final String stringResult;
  final bool isSuccess;
  final String? error;

  const JsResult({
    required this.stringResult,
    this.isSuccess = true,
    this.error,
  });

  @override
  String toString() => isSuccess ? stringResult : 'JS Error: $error';
}

/// 桥接请求，包含回调 ID 和参数
class BridgeRequest {
  final int callbackId;
  final List<dynamic> args;

  const BridgeRequest({required this.callbackId, required this.args});

  factory BridgeRequest.fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return BridgeRequest(
      callbackId: map['callbackId'] as int,
      args: (map['args'] as List<dynamic>?) ?? [],
    );
  }
}

/// QuickJS 引擎封装（支持 Promise 桥接）
///
/// 对标原：RhinoScriptEngine.kt
/// Android 用 QuickJS，iOS 用 JavaScriptCore（通过 flutter_js 包统一接口）
///
/// JS ↔ Dart 桥接采用 Promise + Callback ID 模式：
/// 1. JS 端 java.xxx() 返回 Promise，通过 sendMessage 发送请求
/// 2. Dart 端 onMessage 接收请求，处理后调用 evaluate() 回传结果
/// 3. JS 端 _resolveCallback() 将结果返回给等待的 Promise
class JsEngine {
  JavascriptRuntime? _runtime;

  /// 初始化 JS 引擎
  void initialize() {
    _runtime ??= getJavascriptRuntime();
    _setupPromiseBridge();
  }

  /// 执行 JS 脚本（同步）
  JsResult evaluate(String script, {String? sourceUrl}) {
    try {
      initialize();
      final result = _runtime!.evaluate(
        script,
        sourceUrl: sourceUrl ?? 'main.js',
      );
      return JsResult(stringResult: result.stringResult);
    } catch (e) {
      return JsResult(stringResult: '', isSuccess: false, error: e.toString());
    }
  }

  /// 执行 JS 脚本并处理 Promise（异步）
  /// 用于需要 await java.xxx() 的场景
  Future<JsResult> evaluateAsync(String script, {String? sourceUrl}) async {
    try {
      initialize();
      final result = _runtime!.evaluate(
        script,
        sourceUrl: sourceUrl ?? 'main.js',
      );
      // 如果结果是 Promise，处理它
      if (result.stringResult == '[object Promise]') {
        final resolved = await _runtime!.handlePromise(
          result,
          timeout: const Duration(seconds: 30),
        );
        return JsResult(stringResult: resolved.stringResult);
      }
      return JsResult(stringResult: result.stringResult);
    } catch (e) {
      return JsResult(stringResult: '', isSuccess: false, error: e.toString());
    }
  }

  /// 执行 JS 脚本，自动处理 Promise（如果返回 Promise，等待其完成）
  /// 这是供 AnalyzeRule 使用的主入口
  JsResult evaluateWithPromise(String script, {String? sourceUrl}) {
    try {
      initialize();
      final result = _runtime!.evaluate(
        script,
        sourceUrl: sourceUrl ?? 'main.js',
      );
      if (result.stringResult == '[object Promise]') {
        // 同步模式下处理 Promise：执行 pending job 直到完成
        _executePendingJobs();
        return JsResult(stringResult: result.stringResult);
      }
      return JsResult(stringResult: result.stringResult);
    } catch (e) {
      return JsResult(stringResult: '', isSuccess: false, error: e.toString());
    }
  }

  /// 执行所有 pending 的 JS 微任务
  void _executePendingJobs() {
    for (var i = 0; i < 100; i++) {
      _runtime!.executePendingJob();
    }
  }

  /// 注册原生函数供 JS 调用（单向通信）
  void onMessage(String channel, void Function(dynamic args) callback) {
    initialize();
    _runtime!.onMessage(channel, callback);
  }

  /// 初始化 Promise 桥接层
  /// 注入 bridge.js 到 JS 运行时
  void _setupPromiseBridge() {
    const bridge = _bridgeScript;
    evaluate(bridge, sourceUrl: 'java_bridge.js');
  }

  /// 将结果回传到 JS 端（解析 Promise）
  void resolveCallback(int callbackId, {String? error, String? result}) {
    if (error != null) {
      _runtime!.evaluate(
        '_resolveCallback($callbackId, ${jsonEncode(error)}, null)',
        sourceUrl: 'bridge_callback.dart',
      );
    } else {
      _runtime!.evaluate(
        '_resolveCallback($callbackId, null, ${result != null ? jsonEncode(result) : 'null'})',
        sourceUrl: 'bridge_callback.dart',
      );
    }
  }

  /// 释放引擎资源
  void dispose() {
    _runtime = null;
  }

  /// 桥接层 JS 脚本
  static const String _bridgeScript = '''
// java.* 扩展函数桥接层（Promise 模式）
// 所有 java.xxx() 返回 Promise，通过 sendMessage + Callback ID 与 Dart 通信
(function() {
  if (typeof java !== 'undefined') return;
  window.java = {};
  
  var _callbacks = {};
  var _callbackId = 0;
  
  // 通用桥接调用函数
  function _callBridge(channel, args) {
    return new Promise(function(resolve, reject) {
      var id = ++_callbackId;
      _callbacks[id] = { resolve: resolve, reject: reject };
      sendMessage(channel, JSON.stringify({callbackId: id, args: args}));
    });
  }
  
  // Dart 端通过 evaluate() 调用此函数来解析 Promise
  function _resolveCallback(callbackId, error, result) {
    var cb = _callbacks[callbackId];
    if (!cb) return;
    delete _callbacks[callbackId];
    if (error) {
      cb.reject(new Error(error));
    } else {
      cb.resolve(result);
    }
  }
  
  // 网络请求
  java.get = function(url, headers) { return _callBridge('java.get', [url, headers]); };
  java.post = function(url, body, headers, contentType) { return _callBridge('java.post', [url, body, headers, contentType]); };
  java.ajax = function(url) { return _callBridge('java.ajax', [url]); };
  java.ajaxAll = function(urls) { return _callBridge('java.ajaxAll', [urls]); };
  java.ajaxTestAll = function(urls) { return _callBridge('java.ajaxTestAll', [urls]); };
  java.connect = function(url, header) { return _callBridge('java.connect', [url, header]); };
  java.getCookie = function(tag, key) { return _callBridge('java.getCookie', [tag, key]); };
  java.getWebViewUA = function() { return _callBridge('java.getWebViewUA'); };
  
  // 文件操作
  java.readTxtFile = function(path) { return _callBridge('java.readTxtFile', [path]); };
  java.deleteFile = function(path) { return _callBridge('java.deleteFile', [path]); };
  java.downloadFile = function(url, path) { return _callBridge('java.downloadFile', [url, path]); };
  java.importScript = function(path) { return _callBridge('java.importScript', [path]); };
  java.cacheFile = function(url, saveTime) { return _callBridge('java.cacheFile', [url, saveTime]); };
  java.unzipFile = function(path) { return _callBridge('java.unzipFile', [path]); };
  java.un7zFile = function(path) { return _callBridge('java.un7zFile', [path]); };
  java.unrarFile = function(path) { return _callBridge('java.unrarFile', [path]); };
  java.unArchiveFile = function(path) { return _callBridge('java.unArchiveFile', [path]); };
  java.getTxtInFolder = function(path) { return _callBridge('java.getTxtInFolder', [path]); };
  java.getZipStringContent = function(url, path) { return _callBridge('java.getZipStringContent', [url, path]); };
  java.getRarStringContent = function(url, path) { return _callBridge('java.getRarStringContent', [url, path]); };
  java.get7zStringContent = function(url, path) { return _callBridge('java.get7zStringContent', [url, path]); };
  java.getZipByteArrayContent = function(url, path) { return _callBridge('java.getZipByteArrayContent', [url, path]); };
  java.getRarByteArrayContent = function(url, path) { return _callBridge('java.getRarByteArrayContent', [url, path]); };
  java.get7zByteArrayContent = function(url, path) { return _callBridge('java.get7zByteArrayContent', [url, path]); };
  
  // 编解码
  java.base64Encode = function(str) { return _callBridge('java.base64Encode', [str]); };
  java.base64Decode = function(str) { return _callBridge('java.base64Decode', [str]); };
  java.hexEncodeToString = function(bytes) { return _callBridge('java.hexEncodeToString', [bytes]); };
  java.hexDecodeToString = function(hex) { return _callBridge('java.hexDecodeToString', [hex]); };
  java.encodeURI = function(str) { return _callBridge('java.encodeURI', [str]); };
  java.strToBytes = function(str) { return _callBridge('java.strToBytes', [str]); };
  java.bytesToStr = function(hex) { return _callBridge('java.bytesToStr', [hex]); };
  
  // 加解密
  java.md5Encode = function(str) { return _callBridge('java.md5Encode', [str]); };
  java.md5Encode16 = function(str) { return _callBridge('java.md5Encode16', [str]); };
  java.digestHex = function(data, algo) { return _callBridge('java.digestHex', [data, algo]); };
  java.digestBase64Str = function(data, algo) { return _callBridge('java.digestBase64Str', [data, algo]); };
  java.HMacHex = function(data, algo, key) { return _callBridge('java.HMacHex', [data, algo, key]); };
  java.HMacBase64 = function(data, algo, key) { return _callBridge('java.HMacBase64', [data, algo, key]); };
  java.createSymmetricCrypto = function(mode, padding, key, iv) { return _callBridge('java.createSymmetricCrypto', [mode, padding, key, iv]); };
  java.createAsymmetricCrypto = function(transformation, key) { return _callBridge('java.createAsymmetricCrypto', [transformation, key]); };
  java.createSign = function(algorithm) { return _callBridge('java.createSign', [algorithm]); };
  
  // 已废弃但兼容
  java.aesDecodeToString = function(key, iv, data) { return _callBridge('java.aesDecodeToString', [key, iv, data]); };
  java.aesEncodeToString = function(key, iv, data) { return _callBridge('java.aesEncodeToString', [key, iv, data]); };
  java.aesEncodeToBase64String = function(key, iv, data) { return _callBridge('java.aesEncodeToBase64String', [key, iv, data]); };
  java.desDecodeToString = function(key, data) { return _callBridge('java.desDecodeToString', [key, data]); };
  java.tripleDESDecodeStr = function(key, data) { return _callBridge('java.tripleDESDecodeStr', [key, data]); };
  
  // 时间
  java.timeFormatUTC = function(time, format, sh) { return _callBridge('java.timeFormatUTC', [time, format, sh]); };
  java.timeFormat = function(time) { return _callBridge('java.timeFormat', [time]); };
  
  // URL
  java.toURL = function(url, baseUrl) { return _callBridge('java.toURL', [url, baseUrl]); };
  
  // 文本处理
  java.htmlFormat = function(str) { return _callBridge('java.htmlFormat', [str]); };
  java.t2s = function(text) { return _callBridge('java.t2s', [text]); };
  java.s2t = function(text) { return _callBridge('java.s2t', [text]); };
  java.toNumChapter = function(s) { return _callBridge('java.toNumChapter', [s]); };
  java.randomUUID = function() { return _callBridge('java.randomUUID'); };
  
  // 工具
  java.log = function(msg) { return _callBridge('java.log', [msg]); };
  java.logType = function(any) { return _callBridge('java.logType', [typeof any]); };
  java.toast = function(msg) { return _callBridge('java.toast', [msg]); };
  java.longToast = function(msg) { return _callBridge('java.longToast', [msg]); };
  java.getReadBookConfig = function() { return _callBridge('java.getReadBookConfig'); };
  java.getThemeMode = function() { return _callBridge('java.getThemeMode'); };
  java.getThemeConfig = function() { return _callBridge('java.getThemeConfig'); };
  java.openUrl = function(url) { return _callBridge('java.openUrl', [url]); };
  java.androidId = function() { return _callBridge('java.androidId'); };
  java.queryTTF = function(data) { return _callBridge('java.queryTTF', [data]); };
  java.replaceFont = function(text) { return _callBridge('java.replaceFont', [text]); };
})();
''';
}
