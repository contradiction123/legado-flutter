enum LogLevel {
  debug('DEBUG', 500),
  info('INFO', 800),
  warn('WARN', 900),
  error('ERROR', 1000);

  const LogLevel(this.label, this.developerLevel);

  final String label;
  final int developerLevel;
}
