import 'level.dart';

/// A log entry representation used to propagate information from [Logger] to
/// individual handlers.
class LogRecord {
  final Level level;

  final dynamic message;

  /// Logger where this record is stored.
  final String loggerName;

  /// Time when this record was created.
  final DateTime time;

  /// Unique sequence number greater than all log records created before it.
  final int sequenceNumber;

  static int _nextNumber = 0;

  final dynamic label;

  final StackTrace? stackTrace;

  LogRecord(
    this.level,
    this.message,
    this.loggerName, [
    this.label,
    this.stackTrace,
  ])  : time = DateTime.now(),
        sequenceNumber = LogRecord._nextNumber++;

  @override
  String toString() => '[${level.name}] $loggerName: $message';
}
