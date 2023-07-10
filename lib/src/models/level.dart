// ignore_for_file: constant_identifier_names

import 'ansi_color.dart';

enum Level {
  ALL(0),
  FINE(
    200,
    fgColor: AnsiColors.White,
  ),
  VERBOSE(
    300,
    fgColor: AnsiColors.GRAY,
  ),
  CONFIG(
    400,
    fgColor: AnsiColors.Yellow,
  ),
  INFO(
    500,
    fgColor: AnsiColors.Blue,
  ),
  SHOUT(
    600,
    fgColor: AnsiColors.Cyan,
  ),
  WARNING(
    700,
    fgColor: AnsiColors.Orange,
  ),
  ERROR(
    900,
    fgColor: AnsiColors.Red,
  ),
  SEVERE_ERROR(
    1000,
    fgColor: AnsiColors.Red,
    bgColor: AnsiColors.Red,
  );

  final AnsiColors? _fgColor;
  final AnsiColors? _bgColor;
  final int value;
  const Level(this.value, {AnsiColors? fgColor, AnsiColors? bgColor})
      : _fgColor = fgColor,
        _bgColor = bgColor;

  AnsiColor get fgColor =>
      AnsiColor.fg(_fgColor?.value ?? AnsiColors.White.value);
  AnsiColor get bgColor =>
      AnsiColor.bg(_bgColor?.value ?? AnsiColors.White.value);

  bool operator <(Level other) => value < other.value;

  bool operator <=(Level other) => value <= other.value;

  bool operator >(Level other) => value > other.value;

  bool operator >=(Level other) => value >= other.value;

  int compareTo(Level other) => value - other.value;
  @override
  String toString() => name;
}
