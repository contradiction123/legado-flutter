class LogFileInfo {
  const LogFileInfo({
    required this.name,
    required this.path,
    required this.size,
    required this.modifiedAt,
  });

  final String name;
  final String path;
  final int size;
  final DateTime modifiedAt;
}
