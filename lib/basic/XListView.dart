part of 'basic.dart';

ListView XListView<T>({
  Key? key,
  List<T>? items,
  Widget Function(ContextIndexItem<T>)? itemView,
  Widget? Function(BuildContext)? lastItemView,
  NullableIndexedWidgetBuilder? itemBuilder,
  int? itemCount,
  IndexedWidgetBuilder? separatorBuilder,
  bool reverse = false,
  Axis scrollDirection = Axis.vertical,
  bool separator = false,
  double separatorIndentStart = 0,
  double separatorIndentEnd = 0,
  ScrollController? controller,
  bool? primary,
  ScrollPhysics? physics,
  bool shrinkWrap = false,
  EdgeInsetsGeometry? padding,
  double? itemExtent,
  double? Function(int, SliverLayoutDimensions)? itemExtentBuilder,
  Widget? prototypeItem,
  int? Function(Key)? findChildIndexCallback,
  bool addAutomaticKeepAlives = true,
  bool addRepaintBoundaries = true,
  bool addSemanticIndexes = true,
  double? cacheExtent,
  int? semanticChildCount,
  DragStartBehavior dragStartBehavior = DragStartBehavior.start,
  ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  String? restorationId,
  Clip clipBehavior = Clip.hardEdge,
  HitTestBehavior hitTestBehavior = HitTestBehavior.opaque,
}) {
  IndexedWidgetBuilder? sepBuilder =
      separatorBuilder ?? (separator ? (c, i) => Divider(height: 1, thickness: 1, indent: separatorIndentStart, endIndent: separatorIndentEnd) : null);
  Widget? buildItemViewRawIndex(BuildContext context, int index) {
    if (items != null) {
      if (index >= 0 && index < items.length) {
        if (itemView != null) return itemView.call(ContextIndexItem(context, index, items[index]));
      } else if (index == items.length) {
        if (lastItemView != null) return lastItemView(context);
      }
    }
    return itemBuilder?.call(context, index);
  }

  Widget? buildItemView(BuildContext context, int index) {
    if (sepBuilder == null) {
      return buildItemViewRawIndex(context, index);
    }
    int itemIndex = index ~/ 2;
    if (index.isEven) {
      return buildItemViewRawIndex(context, itemIndex);
    }
    return sepBuilder(context, itemIndex);
  }

  int? itemLen = items?.length;
  if (itemLen != null && lastItemView != null) {
    itemLen += 1;
  }
  int? count = itemCount ?? itemLen;

  if (count != null && sepBuilder != null) {
    count = math.max(0, count * 2 - 1);
  }
  return ListView.builder(
    itemBuilder: buildItemView,
    itemCount: count,
    controller: controller,
    reverse: reverse,
    scrollDirection: scrollDirection,
    primary: primary,
    physics: physics,
    shrinkWrap: shrinkWrap,
    padding: padding,
    itemExtent: itemExtent,
    itemExtentBuilder: itemExtentBuilder,
    prototypeItem: prototypeItem,
    findChildIndexCallback: findChildIndexCallback,
    addAutomaticKeepAlives: addAutomaticKeepAlives,
    addRepaintBoundaries: addRepaintBoundaries,
    addSemanticIndexes: addSemanticIndexes,
    cacheExtent: cacheExtent,
    semanticChildCount: semanticChildCount,
    dragStartBehavior: dragStartBehavior,
    keyboardDismissBehavior: keyboardDismissBehavior,
    restorationId: restorationId,
    clipBehavior: clipBehavior,
    hitTestBehavior: hitTestBehavior,
  );
}
