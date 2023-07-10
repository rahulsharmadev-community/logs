// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:logs/src/models/ansi_color.dart';
import 'package:logs/src/models/log_record.dart';

import 'models/level.dart';

const _topLeftCorner = '┌';
const _bottomLeftCorner = '└';
const _middleCorner = '├';
const _middleTopLine = '┰';
const _middleBottomLine = '┴';
const _verticalLine = '│';
const _doubleDivider = '─';
const _singleDivider = '┄';

class LogsPrinter {
  final int maxLength;
  final bool printTime;
  LogsPrinter({
    this.maxLength = 100,
    this.printTime = true,
  }) {
    for (var i = 0; i < maxLength - 1; i++) {
      doubleDividerLine += _doubleDivider;
      singleDividerLine += _singleDivider;
    }
  }
  var doubleDividerLine = '';
  var singleDividerLine = '';

  List<String> _formatAndDecorate(
    Level level,
    String message,
    String? time,
    String? error,
    String? stackTrace,
  ) {
    List<String> buffer = [];
    var color = level.fgColor.call;
    buffer.add(color('$_topLeftCorner$doubleDividerLine'));
    if (error != null) {
      for (var line in error.split('\n')) {
        buffer.add(color('$_verticalLine$line'));
      }
    }
    for (var line in message.split('\n')) {
      buffer.add(color('$_verticalLine$line'));
    }
    buffer.addAll(
        _bottomMsg(color: color, time: time, msg: stackTrace ?? level.name));
    return buffer;
  }

  _bottomMsg(
      {required String msg,
      required String Function(String) color,
      String? time}) {
    var topLine = _middleCorner +
        (time == null
            ? doubleDividerLine
            : doubleDividerLine.replaceRange(69, 70, _middleTopLine));
    var bottomLine = _bottomLeftCorner +
        (time == null
            ? doubleDividerLine
            : doubleDividerLine.replaceRange(69, 70, _middleBottomLine));
    return [
      color(topLine),
      (time == null)
          ? color('$_verticalLine $msg')
          : color('$_verticalLine '
                  '${msg.replaceAll('\n', '\n$_verticalLine ').padRight(68, ' ')}'
                  '$_verticalLine ') +
              AnsiColor.fg(AnsiColors.GRAY.value).call(time),
      color(bottomLine)
    ];
  }

  void printf(LogRecord record) => _prettyText(record).forEach(print);

  List<String> _prettyText(LogRecord record) {
    var messageStr = _stringifyMessage(record.message);

    var errorStr = record.error?.toString();

    String? timeStr;
    if (printTime) {
      timeStr = _getTime(record.time);
    }
    var stackTrace = record.stackTrace?.toString().split('\n');
    if (stackTrace != null) {
      stackTrace.removeAt(0);
      for (int i = 0; i < stackTrace.length; i++) {
        if (i / 2 != 0) stackTrace.removeAt(i);
        if (stackTrace[i].isNotEmpty) {
          stackTrace[i] = stackTrace[i].replaceAll(RegExp(r'\s+'), ' ');
        }
      }
    }
    return _formatAndDecorate(
        record.level, messageStr, timeStr, errorStr, stackTrace?.join('\n'));
  }

  String _stringifyMessage(dynamic message) {
    var finalMessage = message is Function ? message() : message;
    if (finalMessage is Map ||
        finalMessage is Iterable ||
        finalMessage is List) {
      var encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(finalMessage);
    } else {
      var buffer = StringBuffer();
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
