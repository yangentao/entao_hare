part of 'widgets.dart';

abstract class PaintWidget extends HareWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: DelegatePainter(this));
  }

  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void paint(ui.Canvas canvas, ui.Size size);
}

class DelegatePainter extends CustomPainter {
  final PaintWidget widget;

  DelegatePainter(this.widget);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    widget.paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return widget.shouldRepaint(oldDelegate);
  }
}
