// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:logs/src/log_record.dart';

class LogsDecoration {
  static const topLeftCorner = '┌';
  static const bottomLeftCorner = '└';
  static const middleCorner = '├';
  static const verticalLine = '│';
  static const doubleDivider = '─';
  static const singleDivider = '┄';
}

class LogsPrinter {
  final LogRecord record;
  final int maxLength;
  const LogsPrinter(this.record, {this.maxLength = 120});

  void printf() {
    print(
        '${record.time.hour}hr:${record.time.minute}m:${record.time.second}s:${record.time.microsecond}ms' +
            '\n' +
            record.level.fgColor!.call(_prettyText));
  }

  String get _prettyText {
    String text = record.message?.toString() ?? 'NULL';
    var buffer = StringBuffer();

    for (int i = 0, count = 0; i < text.length; i++) {
      if (count >= maxLength && text[i] == ' ') {
        buffer.write('\n│ ');
        i++;
        count = 0;
      }
      buffer.write(text[i]);
      count++;
    }

    text = _boxWraper(buffer);
    buffer.clear();
    return text;
  }

  String _boxWraper(StringBuffer buffer) {
    return LogsDecoration.topLeftCorner +
        '\n│ ' +
        '$buffer' +
        '\n' +
        LogsDecoration.bottomLeftCorner;
  }
}
