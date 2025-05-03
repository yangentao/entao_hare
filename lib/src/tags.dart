part of '../entao_basic.dart';

const EdgeInsets tagPadding = EdgeInsets.symmetric(horizontal: 4, vertical: 2);

Widget TagText(String title,
    {Color? color = Colors.pinkAccent, Color? textColor = Colors.white, double fontSize = 11, double radius = 2, EdgeInsets? padding = tagPadding}) {
  return title.bodySmall(fontSize: fontSize, color: textColor).padded(padding).roundRect(radius: radius, fillColor: color);
}

extension TagTextExt on String {
  Widget tagIndigo() => TagText(this, color: Colors.indigo[400]!);

  Widget tagRed() => TagText(this, color: Colors.red[600]!);

  Widget tagPink() => TagText(this, color: Colors.pink[600]!);

  Widget tagOrange() => TagText(this, color: Colors.orange[500]!);

  Widget tagAmber() => TagText(this, color: Colors.amber[800]!);

  Widget tagTeal() => TagText(this, color: Colors.teal[600]!);

  Widget tagGren() => TagText(this, color: Colors.green[600]!);

  Widget tagCyan() => TagText(this, color: Colors.cyan[600]!);

  Widget tagBrown() => TagText(this, color: Colors.brown[400]!);

  Widget tagGray() => TagText(this, color: Colors.grey.withOpacityX(0.7));

  Widget tagColor({Color? color, Color? textColor}) => TagText(this, color: color, textColor: textColor);
}

class TagColor {
  static final Color indigo = Colors.indigo[400]!;
  static final Color pink = Colors.pink[600]!;
  static final Color orange = Colors.orange[500]!;
  static final Color amber = Colors.amber[800]!;
  static final Color teal = Colors.teal[600]!;
  static final Color cyan = Colors.cyan[600]!;
  static final Color brown = Colors.brown[400]!;
}
