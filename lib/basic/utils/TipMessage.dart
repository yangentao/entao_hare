part of '../basic.dart';

class TipMessage {
  TipLevel level;
  String message;

  TipMessage({required this.level, required this.message});

  Text toText({BuildContext? context}) {
    return message.text(color: level.textColor(context));
  }

  Text toTitle({BuildContext? context}) {
    return message.titleMedium(color: level.textColor(context));
  }

  @override
  String toString() {
    return "$level: $message";
  }

  static TipMessage error(String message) => TipMessage(level: TipLevel.error, message: message);

  static TipMessage warning(String message) => TipMessage(level: TipLevel.warning, message: message);

  static TipMessage info(String message) => TipMessage(level: TipLevel.info, message: message);

  static TipMessage tip(String message) => TipMessage(level: TipLevel.tip, message: message);
}

enum TipLevel implements Comparable<TipLevel> {
  error,
  warning,
  info,
  tip;

  const TipLevel();

  static TipLevel from(int n) {
    return switch (n) {
      0 => error,
      1 => warning,
      2 => info,
      3 => tip,
      _ => throw Exception("Bad TipLevel value "),
    };
  }

  int toInt() => this.index;

  Color? textColor([BuildContext? context]) {
    return switch (this) {
      error => Colors.redAccent,
      warning => Colors.orangeAccent,
      info => null,
      tip => context?.themeData.unselectedWidgetColor,
    };
  }

  @override
  int compareTo(TipLevel other) {
    return this.index - other.index;
  }
}
