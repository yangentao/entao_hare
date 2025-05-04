part of 'basic.dart';


GridView XGridView({
  required List<Widget> children,
  required bool shrinkWrap,
  int? columnCount,
  int? crossAxisCount,
  double crossAxisExtent = 80,
  double? mainAxisExtent,
  double flexPercent = 0.2,
  double mainAxisSpacing = 8,
  double crossAxisSpacing = 8,
  double childAspectRatio = 1.0,
  EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  Key? key,
  Axis scrollDirection = Axis.vertical,
  bool reverse = false,
  ScrollController? controller,
  bool? primary,
  ScrollPhysics? physics,
  bool addAutomaticKeepAlives = true,
  bool addRepaintBoundaries = true,
  bool addSemanticIndexes = true,
  double? cacheExtent,
  int? semanticChildCount,
  DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  String? restorationId,
  Clip clipBehavior = Clip.hardEdge,
}) {
  GridDelegateX gridDelegate = GridDelegateX(
    columnCount: crossAxisCount ?? columnCount ?? 0,
    crossAxisExtent: crossAxisExtent,
    mainAxisSpacing: mainAxisSpacing,
    crossAxisSpacing: crossAxisSpacing,
    childAspectRatio: childAspectRatio,
    mainAxisExtent: mainAxisExtent,
    flexPercent: flexPercent,
  );
  SliverChildListDelegate childrenDelegate = SliverChildListDelegate(
    children,
    addAutomaticKeepAlives: addAutomaticKeepAlives,
    addRepaintBoundaries: addRepaintBoundaries,
    addSemanticIndexes: addSemanticIndexes,
  );

  return GridView.custom(
    gridDelegate: gridDelegate,
    childrenDelegate: childrenDelegate,
    key: key,
    scrollDirection: scrollDirection,
    reverse: reverse,
    controller: controller,
    primary: primary,
    physics: physics,
    shrinkWrap: shrinkWrap,
    padding: padding,
    cacheExtent: cacheExtent,
    semanticChildCount: semanticChildCount,
    dragStartBehavior: dragStartBehavior,
    keyboardDismissBehavior: keyboardDismissBehavior,
    restorationId: restorationId,
    clipBehavior: clipBehavior,
  );
}
