part of '../basic.dart';


extension WidgetScrollExt on Widget {
  SingleChildScrollView verticalScroll({ScrollController? controller, ScrollPhysics? physics}) {
    return SingleChildScrollView(controller: controller, scrollDirection: Axis.vertical, physics: physics, child: this);
  }

  SingleChildScrollView horizontalScroll({ScrollController? controller, ScrollPhysics? physics}) {
    return SingleChildScrollView(controller: controller, scrollDirection: Axis.horizontal, physics: physics, child: this);
  }

  SingleChildScrollView scrollView({Axis direction = Axis.vertical, EdgeInsets? padding, ScrollController? controller, ScrollPhysics? physics}) {
    return SingleChildScrollView(scrollDirection: direction, padding: padding, controller: controller, physics: physics, child: this);
  }

  Widget scrollBarView({required Axis axis, ScrollController? controller, int depth = 0, ScrollPhysics? physics}) {
    ScrollController c = controller ?? ScrollController();
    return Scrollbar(
      controller: c,
      thumbVisibility: true,
      trackVisibility: true,
      notificationPredicate: (notif) => notif.depth == depth,
      child: SingleChildScrollView(
        controller: c,
        scrollDirection: axis,
        physics: physics,
        child: this,
      ),
    );
  }

  Widget horScrollBar({ScrollController? controller, int depth = 0, ScrollPhysics? physics}) {
    return scrollBarView(axis: Axis.horizontal, controller: controller, depth: depth, physics: physics);
  }

  Widget verScrollBar({ScrollController? controller, int depth = 0, ScrollPhysics? physics}) {
    return scrollBarView(axis: Axis.vertical, controller: controller, depth: depth, physics: physics);
  }

  Widget bothScrollBar({ScrollController? hor, ScrollController? ver, int horDepth = 0, int verDepth = 0, ScrollPhysics? physics}) {
    return this.horScrollBar(controller: hor, depth: horDepth, physics: physics).verScrollBar(controller: ver, depth: verDepth, physics: physics);
  }

  Widget fillOrScrollX({required double width, ScrollController? controller}) {
    return FillOrScrollX(child: this, width: width, controller: controller);
  }
}

Widget FillOrScrollX({required Widget child, required double width, ScrollController? controller}) {
  return LayoutBuilder(builder: (c, n) {
    if (n.maxWidth < width) {
      return child.sizedBox(width: width).horScrollBar(controller: controller);
    } else {
      return child.sizedBox(width: n.maxWidth);
    }
  });
}
