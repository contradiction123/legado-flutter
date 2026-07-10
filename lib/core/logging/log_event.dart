import 'log_level.dart';

class LogEvent {
  LogEvent({
    required this.time,
    required this.level,
    required this.tag,
    required this.message,
    this.error,
    this.stackTrace,
    this.extra,
    this.writeToConsole = true,
    this.writeToFile = true,
  });

  final DateTime time;
  final LogLevel level;
  final String tag;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final Map<String, Object?>? extra;
  final bool writeToConsole;
  final bool writeToFile;
}
