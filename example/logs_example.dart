import 'dart:async';

import 'package:logs/logs.dart';

void main(List<String> args) async {
  Logs.listen;
  Logs.listen;
  await Future.wait(
      [test('Branch A', 700), test('Branch B', 200), test('Branch C', 600)]);
  Logs.dispose;
}

const text =
    'Level Fine:Level FineLevel FineLevel FineLevel FineLevel FineLevel FineLevel FineLevel Fine Level FineLevel FineLevel FineLevel FineLevel FineLevel FineLevel FineLevel FineLevel FineLevel Fine';
Future<void> test(String name, int s) async {
  var logs = Logs(name);
  logs.fine('$text: $name');
  await delay(s);
  logs.config('$text:Config: $name');
  await delay(s);
  logs.info('$text:Info: $name');
  await delay(s);
  logs.warning('$text:Warning: $name');
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
