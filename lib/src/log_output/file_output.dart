import 'package:logs/src/log_output/log_output.dart';
import 'package:logs/src/models/log_record.dart';

import 'dart:convert';
import 'dart:io';

/// Writes the log output to a file.
class FileOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  IOSink? _sink;

  FileOutput({
    required this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
  }) {
    _init();
  }

  void _init() {
    _sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  void output(LogRecord record) {
    _sink?.write(record.message);
    _sink?.writeln();
  }

  void destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }
}
