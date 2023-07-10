import 'level.dart';

/// A log entry representation used to propagate information from [Logger] to
/// individual handlers.
class LogRecord {
  final Level level;

  final Object? message;

  /// Logger where this record is stored.
  final String loggerName;

  /// Time when this record was created.
  final DateTime time;

  /// Unique sequence number greater than all log records created before it.
  final int sequenceNumber;

  static int _nextNumber = 0;

  /// Associated error (if any) when recording errors messages.
  final Object? error;

  final StackTrace? stackTrace;

  LogRecord(
    this.level,
    this.message,
    this.loggerName, [
    this.error,
    this.stackTrace,
  ])  : time = DateTime.now(),
        sequenceNumber = LogRecord._nextNumber++;

  @override
  String toString() => '[${level.name}] $loggerName: $message';
}
