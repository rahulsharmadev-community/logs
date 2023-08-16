// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:logs/src/models/ansi_color.dart';
import 'package:logs/src/models/log_record.dart';
import 'package:stack_trace/stack_trace.dart';

import 'models/level.dart';

const _topLeftCorner = '┌';
const _bottomLeftCorner = '└';
const _middleCorner = '├';
const _verticalLine = '│';
const _doubleDivider = '─';
const _singleDivider = '┄';

class LogsPrinter {
  final String recordName;
  final int maxLength;
  final bool time;
  final bool trace;
  LogsPrinter({
    required this.recordName,
    required this.time,
    required this.trace,
    this.maxLength = 100,
  }) {
    for (var i = 0; i < maxLength - 1; i++) {
      doubleDividerLine += _doubleDivider;
      singleDividerLine += _singleDivider;
    }
  }
  var doubleDividerLine = '';
  var singleDividerLine = '';

  List<String> _formatAndDecorate({
    required Level level,
    required String message,
    required String? timeStamp,
    required String? label,
    required StackTrace? stackTrace,
  }) {
    List<String> buffer = [];
    var color = level.fgColor.call;
    buffer.add(color('$_topLeftCorner$doubleDividerLine'));
    if (label != null) {
      for (var line in label.split('\n')) {
        buffer.add(color('$_verticalLine$line'));
      }
    }
    for (var line in message.split('\n')) {
      buffer.add(color('$_verticalLine$line'));
    }
    var topLine = _middleCorner + doubleDividerLine;
    var bottomLine = _bottomLeftCorner + doubleDividerLine;

    if (time || trace) {
      buffer.add(color(topLine));
      buffer.add(
          _bottomMsg(color: color, time: timeStamp, stackTrace: stackTrace));
    }
    buffer.add(color(bottomLine));
    return buffer;
  }

  String _bottomMsg(
      {StackTrace? stackTrace,
      required String Function(String) color,
      String? time}) {
    var trace = [];

    if (this.trace && stackTrace != null) {
      var frames = Trace.from(stackTrace).frames;
      for (var frame in frames) {
        if (frame.package != 'logs') {
          trace.add(
              '$_verticalLine Method: ${frame.member}, File: ${frame.location},');
        }
      }
    }

    var timeString = time != null && this.time
        ? color('$_verticalLine Time: ') +
            AnsiColor.fg(AnsiColors.GRAY.value).call(time)
        : '';

    var traceString = (this.trace && trace.isNotEmpty)
        ? color(trace.join('\n') + '\n$_middleCorner$doubleDividerLine\n')
        : '';

    return traceString + timeString;
  }

  void printf(LogRecord record) => _prettyText(record).forEach(print);

  List<String> _prettyText(LogRecord record) {
    var messageString = _stringifyMessage(record.message);
    var label = record.label?.toString();

    String? timeStamp;
    if (time) {
      timeStamp = _getTime(record.timestamp);
    }
    return _formatAndDecorate(
        level: record.level,
        message: messageString,
        timeStamp: timeStamp,
        label: label,
        stackTrace: record.stackTrace);
  }

  String _stringifyMessage(dynamic message) {
    var finalMessage = message is Function ? message() : message;

    if (finalMessage is Map<String, dynamic> ||
        finalMessage is List<Map<String, dynamic>>) {
      var encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(finalMessage);
    } else {
      var buffer = StringBuffer();
      finalMessage = (finalMessage is List ||
              finalMessage is Iterable ||
              finalMessage is Set)
          ? finalMessage.join(',\n')
          : finalMessage.toString();
      for (int i = 0, count = 0; i < finalMessage.length; i++) {
        if (count >= maxLength && finalMessage[i] == ' ') {
          i++;
          buffer.write('\n');
          count = 0;
        }
        buffer.write(finalMessage[i]);
        count++;
      }
      finalMessage = '$buffer';
      buffer.clear();
      return '$finalMessage';
    }
  }

  String _getTime(DateTime t) {
    pad(int n, [int s = 2]) => '$n'.padLeft(s, '0');
    final now = DateTime.now();
    var msSince = now.microsecond - t.millisecond;
    var secSice = now.second - t.second;
    var sign = secSice.isNegative ? '-' : '+';
    return '${pad(t.minute)}m:${pad(t.second)}s:${pad(t.millisecond)}ms'
        ' ($sign ${pad(secSice)}s:${pad(msSince.abs(), 4)}ms)';
  }
}
