import 'dart:async';
import 'package:logs/logs.dart';
import 'package:logs/src/logs_printer.dart';

void main(List<String> args) async {
  await test('Branch A', 100);
}

const text = ["2a97215100f5f8365d8b", "1348ee9c-3144-418f-96eb-1745ad1e5bff"];
Future<void> test(String name, int s) async {
  var logs = Logs(name, printer: LogsPrinter());
  logs.fine(text);
  await delay(s);
  logs.config(text);
  await delay(s);
  logs.info(name);
  await delay(s);
  logs.warning(name);
  await delay(s);
  logs.severeError('$text:Severe Error: $name');
  await delay(s);
  logs.verbose('$text:verbose: $name');
  await delay(s);
  logs.shout('$text:shout: $name');
  await delay(s);
  logs.error('$text:Error: $name');
}

Future<void> delay(int s) async =>
    await Future.delayed(Duration(milliseconds: s));
