import 'dart:async';
import 'package:logs/src/logs_printer.dart';

import 'levels.dart';
import 'log_record.dart';

abstract class _Logs {
  static bool isCreated = false;
  static late final StreamController<LogRecord> controller;

  static void add(LogRecord record) {
    controller.sink.add(record);
  }

  static void listen() {
    controller.stream.listen((record) {
      LogsPrinter(record).printf();
    });
  }

  static void createAndListen() {
    if (!isCreated) {
      controller = StreamController<LogRecord>();
      isCreated = true;
      listen();
    }
  }

  static void dispose() {
    controller.close();
  }
}

class Logs {
  static void get listen => _Logs.createAndListen();
  static void get dispose => _Logs.dispose();

  final String recordName;
  Logs(this.recordName);

  void fine(Object? message, [Object? error]) =>
      _Logs.add(LogRecord(Level.FINE, message, recordName, error));

  void config(
    Object? message, [
    Object? error,
  ]) {
    _Logs.add(LogRecord(Level.CONFIG, message, recordName, error));
  }

  void verbose(
    Object? message, [
    Object? error,
  ]) {
    _Logs.add(LogRecord(Level.VERBOSE, message, recordName, error));
  }

  void info(
    Object? message, [
    Object? error,
  ]) {
    _Logs.add(LogRecord(Level.INFO, message, recordName, error));
  }

  void warning(
    Object? message, [
    Object? error,
  ]) {
    _Logs.add(LogRecord(Level.WARNING, message, recordName, error));
  }

  void severeError(
    Object? message, [
    Object? error,
  ]) {
    _Logs.add(LogRecord(Level.SEVERE_ERROR, message, recordName, error));
  }
  void error(
    Object? message, [
    Object? error,
  ]) {
    _Logs.add(LogRecord(Level.ERROR, message, recordName, error));
  }

  void shout(
    Object? message, [
    Object? error,
  ]) {
    _Logs.add(LogRecord(Level.SHOUT, message, recordName, error));
  }
}
