part of '../entao_basic.dart';

typedef Edges = EdgeInsets;

EdgeInsets xy(double x, [double y = 0]) {
  return EdgeInsets.symmetric(horizontal: x, vertical: y);
}

EdgeInsets edges({double? left, double? top, double? right, double? bottom, double? hor, double? ver, double? all}) {
  return EdgeInsets.fromLTRB(left ?? hor ?? all ?? 0, top ?? ver ?? all ?? 0, right ?? hor ?? all ?? 0, bottom ?? ver ?? all ?? 0);
}

EdgeInsets insets({double? left, double? top, double? right, double? bottom, double? hor, double? ver, double? all}) {
  return EdgeInsets.fromLTRB(left ?? hor ?? all ?? 0, top ?? ver ?? all ?? 0, right ?? hor ?? all ?? 0, bottom ?? ver ?? all ?? 0);
}

extension ColorOp on Color {
  Color withOpacityX(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return this.withAlpha((255.0 * opacity).round());
  }
}

extension StringSizeExt on String {
  Size sizeDisplay({TextStyle? style, Locale? locale}) {
    if (this.isEmpty) return Size.zero;
    TextPainter p = TextPainter(text: TextSpan(text: this, style: style), maxLines: 1, locale: locale);
    p.layout();
    return p.size;
  }
}
