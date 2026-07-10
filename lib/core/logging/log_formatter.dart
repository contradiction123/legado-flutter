import 'dart:convert';

import 'log_event.dart';

class LogFormatter {
  const LogFormatter();

  String format(LogEvent event) {
    final buffer = StringBuffer()
      ..write('[')
      ..write(_formatTime(event.time))
      ..write('][')
      ..write(event.level.label)
      ..write('][')
      ..write(event.tag)
      ..writeln(']')
      ..writeln(event.message);

    final extra = event.extra;
    if (extra != null && extra.isNotEmpty) {
      for (final entry in extra.entries) {
        _writeField(buffer, entry.key, entry.value);
      }
    }

    if (event.error != null) {
      _writeField(buffer, 'Error', event.error);
    }

    if (event.stackTrace != null) {
      _writeField(buffer, 'StackTrace', event.stackTrace.toString().trimRight());
    }

    buffer.writeln();
    return buffer.toString();
  }

  String _formatTime(DateTime time) {
    final year = time.year.toString().padLeft(4, '0');
    final month = time.month.toString().padLeft(2, '0');
    final day = time.day.toString().padLeft(2, '0');
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');
    final millisecond = time.millisecond.toString().padLeft(3, '0');
    return '$year-$month-$day $hour:$minute:$second.$millisecond';
  }

  void _writeField(StringBuffer buffer, String key, Object? value) {
    if (value == null) {
      buffer
        ..write(key)
        ..writeln(': null');
      return;
    }

    if (value is String) {
      _writeStringField(buffer, key, value);
      return;
    }

    if (value is Map || value is Iterable) {
      final encoder = const JsonEncoder.withIndent('  ');
      _writeStringField(buffer, key, encoder.convert(value));
      return;
    }

    _writeStringField(buffer, key, value.toString());
  }

  void _writeStringField(StringBuffer buffer, String key, String value) {
    final normalized = value.replaceAll('\r\n', '\n').trimRight();
    if (normalized.isEmpty) {
      buffer
        ..write(key)
        ..writeln(':');
      return;
    }

    if (!normalized.contains('\n')) {
      buffer
        ..write(key)
        ..write(': ')
        ..writeln(normalized);
      return;
    }

    buffer
      ..write(key)
      ..writeln(':');
    for (final line in normalized.split('\n')) {
      buffer
        ..write('  ')
        ..writeln(line);
    }
  }
}
