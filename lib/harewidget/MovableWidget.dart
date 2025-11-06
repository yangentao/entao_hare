part of 'harewidget.dart';

class MovableWidget extends HareWidget {
  Widget child;
  double dx;
  double dy;
  ValueChanged<Offset>? onMoveStart;
  ValueChanged<Offset>? onMoveEnd;

  HitTestBehavior? behavior;

  // ignore: use_key_in_widget_constructors
  MovableWidget({required this.child, this.behavior = HitTestBehavior.opaque, this.dx = 0, this.dy = 0, this.onMoveStart, this.onMoveEnd});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(dx, dy),
      child: GestureDetector(
        behavior: behavior,
        child: child,
        onPanStart: (d) {
          onMoveStart?.call(Offset(dx, dy));
        },
        onPanUpdate: (d) {
          dx += d.delta.dx;
          dy += d.delta.dy;
          updateState();
        },
        onPanEnd: (d) {
          onMoveEnd?.call(Offset(dx, dy));
        },
      ),
    );
  }
}
