part of 'basic.dart';

GridView XGridView<T>({
  List<T>? items,
  Widget Function(ContextIndexItem<T>)? itemView,
  NullableIndexedWidgetBuilder? itemBuilder,
  bool shrinkWrap = false,
  int? itemCount,
  Key? key,
  Axis scrollDirection = Axis.vertical,
  bool reverse = false,
  ScrollController? controller,
  bool? primary,
  ScrollPhysics? physics,
  EdgeInsetsGeometry? padding,
  int? columnCount,
  int? crossAxisCount,
  double crossAxisExtent = 80,
  double flexPercent = 0.15,
  double mainAxisSpacing = 0.0,
  double crossAxisSpacing = 0.0,
  double childAspectRatio = 1.0,
  double? mainAxisExtent,
  bool addAutomaticKeepAlives = true,
  bool addRepaintBoundaries = true,
  bool addSemanticIndexes = true,
  double? cacheExtent,
  ChildIndexGetter? findChildIndexCallback,
  int? semanticChildCount,
  DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  String? restorationId,
  Clip clipBehavior = Clip.hardEdge,
}) {
  XGridDelegate gridDelegate = XGridDelegate(
    columnCount: crossAxisCount ?? columnCount ?? 0,
    crossAxisExtent: crossAxisExtent,
    mainAxisSpacing: mainAxisSpacing,
    crossAxisSpacing: crossAxisSpacing,
    childAspectRatio: childAspectRatio,
    mainAxisExtent: mainAxisExtent,
    flexPercent: flexPercent,
  );

  SliverChildDelegate childrenDelegate = SliverChildBuilderDelegate(
    (c, i) {
      if (items != null && itemView != null && i < items.length) {
        return itemView(ContextIndexItem(c, i, items[i])).container(key: ObjectKey(items[i]));
      }
      return itemBuilder?.call(c, i);
    },
    findChildIndexCallback: findChildIndexCallback,
    childCount: itemCount ?? items?.length,
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
