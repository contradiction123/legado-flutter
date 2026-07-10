import 'dart:developer' as developer;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../platform/file_share_channel.dart';
import 'log_event.dart';
import 'log_file_info.dart';
import 'log_file_writer.dart';
import 'log_formatter.dart';
import 'log_level.dart';
import 'log_tag.dart';

class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  static const int _maxFileBytes = 5 * 1024 * 1024;
  static const int _replayChunkSize = 3000;
  static const int _consoleChunkSize = 3000;

  final LogFormatter _formatter = const LogFormatter();
  final LogFileWriter _writer = LogFileWriter(maxFileBytes: _maxFileBytes);
  final FileShareChannel _fileShareChannel = const FileShareChannel();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    await _writer.initialize();
    _initialized = true;
    info(
      LogTag.appLifecycle,
      'Logger initialized',
      extra: {'MaxFileBytes': _maxFileBytes},
    );
  }

  void debug(String tag, String message, {Map<String, Object?>? extra}) {
    _log(
      LogEvent(
        time: DateTime.now(),
        level: LogLevel.debug,
        tag: tag,
        message: message,
        extra: extra,
      ),
    );
  }

  void info(String tag, String message, {Map<String, Object?>? extra}) {
    _log(
      LogEvent(
        time: DateTime.now(),
        level: LogLevel.info,
        tag: tag,
        message: message,
        extra: extra,
      ),
    );
  }

  void warn(String tag, String message, {Map<String, Object?>? extra}) {
    _log(
      LogEvent(
        time: DateTime.now(),
        level: LogLevel.warn,
        tag: tag,
        message: message,
        extra: extra,
      ),
    );
  }

  void error(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? extra,
  }) {
    _log(
      LogEvent(
        time: DateTime.now(),
        level: LogLevel.error,
        tag: tag,
        message: message,
        error: error,
        stackTrace: stackTrace,
        extra: extra,
      ),
    );
  }

  Future<List<LogFileInfo>> listFiles() async {
    await initialize();
    return _writer.listFiles();
  }

  Future<String> readFile(String path) async {
    await initialize();
    return _writer.readFile(path);
  }

  Future<void> deleteFile(String path) async {
    await initialize();
    await _writer.deleteFile(path);
    info(LogTag.appSettings, 'Deleted log file', extra: {'Path': path});
  }

  Future<String?> exportFile(LogFileInfo file) async {
    await initialize();
    final bytes = await File(file.path).readAsBytes();
    final targetPath = await FilePicker.platform.saveFile(
      dialogTitle: '导出日志',
      fileName: file.name,
      bytes: bytes,
    );
    if (targetPath == null || targetPath.isEmpty) {
      return null;
    }

    info(
      LogTag.appSettings,
      'Exported log file',
      extra: {'Path': file.path, 'TargetPath': targetPath},
    );
    return targetPath;
  }

  Future<void> shareFile(LogFileInfo file) async {
    await initialize();
    await _fileShareChannel.shareFile(file.path, file.name);
    info(LogTag.appSettings, 'Shared log file', extra: {'Path': file.path});
  }

  Future<void> replayFileToConsole(LogFileInfo file) async {
    await initialize();
    final content = await _writer.readFile(file.path);
    if (content.isEmpty) {
      _writeToConsole(
        '[${
            LogTag.appSettings
          }][${LogLevel.info.label}] Replay log skipped, file is empty: ${file.path}',
      );
      return;
    }

    for (var start = 0; start < content.length; start += _replayChunkSize) {
      final end = (start + _replayChunkSize < content.length)
          ? start + _replayChunkSize
          : content.length;
      developer.log(
        content.substring(start, end),
        name: LogTag.appSettings,
        level: LogLevel.info.developerLevel,
      );
      _writeToConsole(content.substring(start, end));
    }
  }

  Future<void> flush() async {
    await initialize();
    await _writer.flush();
  }

  void _log(LogEvent event) {
    final formatted = _formatter.format(event);
    if (event.writeToConsole) {
      developer.log(
        formatted,
        name: event.tag,
        level: event.level.developerLevel,
        error: event.error,
        stackTrace: event.stackTrace,
      );
      _writeToConsole(formatted);
    }
    if (event.writeToFile) {
      _writer.enqueue(formatted);
    }
  }

  void _writeToConsole(String message) {
    for (var start = 0; start < message.length; start += _consoleChunkSize) {
      final end = (start + _consoleChunkSize < message.length)
          ? start + _consoleChunkSize
          : message.length;
      debugPrintSynchronously(message.substring(start, end));
    }
  }
}
