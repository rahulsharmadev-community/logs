import 'package:logs/src/log_output/log_output.dart';
import 'package:logs/src/logs_printer.dart';
import 'models/level.dart';
import 'models/log_record.dart';

class Logs {
  final String recordName;
  final Level observe;
  final LogOutput output;
  final LogsPrinter defaultPrinter;
  Logs(this.recordName,
      {this.observe = Level.ALL,
      this.output = const LogOutput(),
      LogsPrinter? printer})
      : defaultPrinter = printer ??
            LogsPrinter(
              recordName: recordName,
              time: true,
              trace: true,
            );

  static bool _releaseModeEnable = false;

  static bool get _isReleaseMode =>
      const bool.fromEnvironment('dart.vm.product');

  /// With releaseModeEnable, you can print logs in
  /// release mode yet generating logs is disabled.\
  /// Now: [Debug, Profile, Release]\
  /// Default:[Debug, Profile]
  static void get releaseModeEnable => _releaseModeEnable = true;
  void _push(LogRecord record, [LogsPrinter? logsPrinter]) {
    if (_releaseModeEnable || !_isReleaseMode) {
      if (output.console) {
        (logsPrinter ?? defaultPrinter).printf(record);
      }
      if (output.output != null) {
        output.output!.output(record);
      }
    }
  }

  void fine(dynamic message, [dynamic label]) => _push(
      LogRecord(Level.FINE, message, recordName, label),
      LogsPrinter(recordName: recordName, time: false, trace: false));

  void config(dynamic message, [dynamic label]) => _push(
      LogRecord(Level.CONFIG, message, recordName, label, StackTrace.current));

  void verbose(dynamic message, [dynamic label]) => _push(
      LogRecord(Level.VERBOSE, message, recordName, label),
      LogsPrinter(recordName: recordName, time: true, trace: false));

  void info(dynamic message, [dynamic label]) => _push(
      LogRecord(Level.INFO, message, recordName, label),
      LogsPrinter(recordName: recordName, time: true, trace: false));

  void warning(dynamic message, [dynamic label]) => _push(
      LogRecord(Level.WARNING, message, recordName, label, StackTrace.current));

  void severeError(dynamic message, [dynamic label]) => _push(LogRecord(
      Level.SEVERE_ERROR, message, recordName, label, StackTrace.current));

  void error(dynamic message, [dynamic label]) => _push(
      LogRecord(Level.ERROR, message, recordName, label, StackTrace.current));

  void shout(dynamic message, [dynamic label]) => _push(
      LogRecord(Level.SHOUT, message, recordName, label, StackTrace.current));
}
