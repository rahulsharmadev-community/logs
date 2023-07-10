import 'package:logs/src/log_output/log_output.dart';
import 'package:logs/src/logs_printer.dart';
import 'models/level.dart';
import 'models/log_record.dart';

class Logs {
  final String recordName;
  final Level observe;
  final LogOutput output;
  final LogsPrinter printer;
  Logs(this.recordName,
      {this.observe = Level.ALL,
      this.output = const LogOutput(),
      LogsPrinter? printer})
      : printer = printer ?? LogsPrinter();

  static bool _releaseModeEnable = false;

  static bool get _isReleaseMode =>
      const bool.fromEnvironment('dart.vm.product');

  /// With releaseModeEnable, you can print logs in
  /// release mode yet generating logs is disabled.\
  /// Now: [Debug, Profile, Release]\
  /// Default:[Debug, Profile]
  static void get releaseModeEnable => _releaseModeEnable = true;
  void _push(LogRecord record) {
    if (_releaseModeEnable || !_isReleaseMode) {
      if (output.console) {
        printer.printf(record);
      }
      if (output.output != null) {
        output.output!.output(record);
      }
    }
  }

  void fine(Object? message, [Object? error]) =>
      _push(LogRecord(Level.FINE, message, recordName, error));

  void config(Object? message, [Object? error]) =>
      _push(LogRecord(Level.CONFIG, message, recordName, error));

  void verbose(Object? message, [Object? error]) =>
      _push(LogRecord(Level.VERBOSE, message, recordName, error));

  void info(Object? message, [Object? error]) =>
      _push(LogRecord(Level.INFO, message, recordName, error));

  void warning(Object? message, [Object? error]) => _push(
      LogRecord(Level.WARNING, message, recordName, error, StackTrace.current));

  void severeError(Object? message, [Object? error]) => _push(LogRecord(
      Level.SEVERE_ERROR, message, recordName, error, StackTrace.current));

  void error(
    Object? message, [
    Object? error,
  ]) =>
      _push(LogRecord(
          Level.ERROR, message, recordName, error, StackTrace.current));

  void shout(Object? message, [Object? error]) =>
      _push(LogRecord(Level.SHOUT, message, recordName, error));
}
