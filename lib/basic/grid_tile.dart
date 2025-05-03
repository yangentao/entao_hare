part of '../basic.dart';

class GridTileX extends StatelessWidget {
  Widget child;
  Widget? bottomLeft;
  Widget? bottomRight;
  Widget? bottomCenter;
  Widget? topRight;
  Widget? topLeft;
  Widget? topCenter;
  Widget? centerLeft;
  Widget? centerRight;
  double? biasY;
  EdgeInsets? padding;
  double fontSize;
  double autoBias;

  GridTileX({
    super.key,
    required this.child,
    this.bottomLeft,
    this.bottomRight,
    this.bottomCenter,
    this.topLeft,
    this.topRight,
    this.topCenter,
    this.centerLeft,
    this.centerRight,
    this.fontSize = 13,
    this.biasY,
    this.autoBias = 0.5,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    double? bY = biasY;
    if (bY == null) {
      bool topNull = topLeft == null && topRight == null && topCenter == null;
      bool bottomNull = bottomLeft == null && bottomRight == null && bottomCenter == null;
      bY = 0;
      if (topNull) bY = bY - autoBias;
      if (bottomNull) bY = bY + autoBias;
    }
    Stack st = Stack(
      children: <Widget?>[
        _ch(context, child).align(Alignment(0, bY)),
        _st(context, topLeft, TextAlign.left)?.align(Alignment.topLeft),
        _st(context, topCenter, TextAlign.center)?.align(Alignment.topCenter),
        _st(context, topRight, TextAlign.right)?.align(Alignment.topRight),
        _st(context, centerLeft, TextAlign.left)?.align(Alignment.centerLeft),
        _st(context, centerRight, TextAlign.right)?.align(Alignment.centerRight),
        _st(context, bottomLeft, TextAlign.left)?.align(Alignment.bottomLeft),
        _st(context, bottomCenter, TextAlign.center)?.align(Alignment.bottomCenter),
        _st(context, bottomRight, TextAlign.right)?.align(Alignment.bottomRight),
      ].nonNullList,
    );
    if (padding == null) return st;
    return st.padded(padding!);
  }

  Widget _ch(BuildContext context, Widget w) {
    // return DefaultTextStyle(child: w, textAlign: TextAlign.center, style: context.themeData.textTheme.titleMedium!);
    return DefaultTextStyle(child: w, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300));
  }

  Widget? _st(BuildContext context, Widget? w, TextAlign textAlign) {
    if (w == null) return null;
    return DefaultTextStyle(child: w, textAlign: textAlign, style: TextStyle(fontSize: fontSize));
  }
}
