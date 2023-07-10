import 'package:logs/src/log_output/file_output.dart';

class LogOutput {
  final bool console;
  final FileOutput? output;

  const LogOutput({this.console = true, this.output});
}
