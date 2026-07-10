import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'log_file_info.dart';

class LogFileWriter {
  LogFileWriter({
    required this.maxFileBytes,
  });

  static const _logsDirectoryName = 'logs';
  static const _batchWriteThreshold = 64 * 1024;

  final int maxFileBytes;
  final Queue<String> _pendingEntries = Queue<String>();

  Directory? _logDirectory;
  File? _currentFile;
  String? _currentDateKey;
  int _currentFileIndex = 1;
  int _currentFileBytes = 0;
  bool _drainScheduled = false;
  Future<void> _operationTail = Future<void>.value();

  Future<void> initialize() async {
    await _runExclusive(() async {
      await _ensureLogDirectory();
    });
  }

  void enqueue(String formattedLog) {
    _pendingEntries.add(formattedLog);
    if (_drainScheduled) {
      return;
    }
    _drainScheduled = true;
    unawaited(
      _runExclusive(() async {
        await _drainPendingEntries();
      }),
    );
  }

  Future<void> flush() async {
    await _runExclusive(() async {
      await _drainPendingEntries();
    });
  }

  Future<List<LogFileInfo>> listFiles() async {
    return _runExclusive(() async {
      await _drainPendingEntries();
      final directory = await _ensureLogDirectory();
      final entities = await directory
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.txt'))
          .cast<File>()
          .toList();

      final files = <LogFileInfo>[];
      for (final file in entities) {
        final stat = await file.stat();
        files.add(
          LogFileInfo(
            name: p.basename(file.path),
            path: file.path,
            size: stat.size,
            modifiedAt: stat.modified,
          ),
        );
      }

      files.sort((a, b) => b.name.compareTo(a.name));
      return files;
    });
  }

  Future<String> readFile(String path) async {
    return _runExclusive(() async {
      await _drainPendingEntries();
      final file = File(path);
      if (!await file.exists()) {
        return '';
      }
      return file.readAsString();
    });
  }

  Future<void> deleteFile(String path) async {
    await _runExclusive(() async {
      await _drainPendingEntries();
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      if (_currentFile?.path == file.path) {
        _currentFile = null;
        _currentFileBytes = 0;
      }
    });
  }

  Future<String?> exportFile(String path, String targetPath) async {
    return _runExclusive(() async {
      await _drainPendingEntries();
      final source = File(path);
      if (!await source.exists()) {
        return null;
      }

      final target = File(targetPath);
      await target.parent.create(recursive: true);
      await source.copy(target.path);
      return target.path;
    });
  }

  Future<Directory> _ensureLogDirectory() async {
    if (_logDirectory != null) {
      return _logDirectory!;
    }

    final root = await getApplicationDocumentsDirectory();
    final directory = Directory(p.join(root.path, _logsDirectoryName));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    _logDirectory = directory;
    return directory;
  }

  Future<void> _drainPendingEntries() async {
    while (_pendingEntries.isNotEmpty) {
      final batch = StringBuffer();
      var batchBytes = 0;
      while (_pendingEntries.isNotEmpty &&
          batchBytes < _batchWriteThreshold) {
        final entry = _pendingEntries.removeFirst();
        batch.write(entry);
        batchBytes += utf8.encode(entry).length;
      }

      final chunk = batch.toString();
      if (chunk.isEmpty) {
        continue;
      }
      await _writeChunk(chunk);
    }

    _drainScheduled = false;
    if (_pendingEntries.isNotEmpty) {
      _drainScheduled = true;
      await _drainPendingEntries();
    }
  }

  Future<void> _writeChunk(String chunk) async {
    final chunkBytes = utf8.encode(chunk).length;
    final target = await _resolveWritableFile(chunkBytes);
    await target.writeAsString(chunk, mode: FileMode.append, flush: false);
    _currentFileBytes += chunkBytes;
  }

  Future<File> _resolveWritableFile(int nextChunkBytes) async {
    final now = DateTime.now();
    final dateKey = _formatDate(now);
    if (_currentFile == null || _currentDateKey != dateKey) {
      await _initializeCurrentFile(dateKey);
    }

    if (_currentFileBytes + nextChunkBytes > maxFileBytes) {
      _currentFileIndex += 1;
      _currentFile = await _fileFor(dateKey, _currentFileIndex);
      _currentFileBytes = await _currentFile!.length();
    }

    return _currentFile!;
  }

  Future<void> _initializeCurrentFile(String dateKey) async {
    final directory = await _ensureLogDirectory();
    final regex = RegExp('^${RegExp.escape(dateKey)}-(\\d{2})\\.txt\$');
    var latestIndex = 0;
    var latestSize = 0;

    await for (final entity in directory.list()) {
      if (entity is! File) {
        continue;
      }
      final match = regex.firstMatch(p.basename(entity.path));
      if (match == null) {
        continue;
      }
      final index = int.tryParse(match.group(1) ?? '') ?? 0;
      if (index >= latestIndex) {
        latestIndex = index;
        latestSize = await entity.length();
      }
    }

    _currentDateKey = dateKey;
    _currentFileIndex = latestIndex == 0 ? 1 : latestIndex;
    _currentFile = await _fileFor(dateKey, _currentFileIndex);
    _currentFileBytes = latestIndex == 0 ? 0 : latestSize;
  }

  Future<File> _fileFor(String dateKey, int index) async {
    final directory = await _ensureLogDirectory();
    final file = File(
      p.join(directory.path, '$dateKey-${index.toString().padLeft(2, '0')}.txt'),
    );
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    return file;
  }

  String _formatDate(DateTime time) {
    final year = time.year.toString().padLeft(4, '0');
    final month = time.month.toString().padLeft(2, '0');
    final day = time.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<T> _runExclusive<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _operationTail = _operationTail.catchError((_) {}).then((_) async {
      try {
        completer.complete(await action());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    }).catchError((_) {});
    return completer.future;
  }
}
