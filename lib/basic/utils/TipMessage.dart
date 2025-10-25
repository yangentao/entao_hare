part of '../basic.dart';

class TipMessage {
  final TipLevel level;
  final String message;

  const TipMessage({required this.level, required this.message});

  Text toText({BuildContext? context}) {
    return message.text(color: level.textColor(context));
  }

  @override
  String toString() {
    return "$level: $message";
  }
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
