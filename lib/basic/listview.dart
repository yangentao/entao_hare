part of 'basic.dart';


class XListView<T> extends StatelessWidget {
  final int? itemCount;
  final NullableIndexedWidgetBuilder? itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final ScrollController controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final double? Function(int, SliverLayoutDimensions)? itemExtentBuilder;
  final Widget? prototypeItem;
  final int? Function(Key)? findChildIndexCallback;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final List<T>? items;
  final Widget Function(BuildContext, T)? itemView;
  final Widget? Function(BuildContext)? lastItemView;
  final FutureOr<void> Function()? onLoadMore;
  final Future<void> Function()? onRefresh;

  XListView({
    this.items,
    this.itemView,
    this.lastItemView,
    this.onLoadMore,
    this.onRefresh,
    this.itemBuilder,
    this.itemCount,
    IndexedWidgetBuilder? separatorBuilder,
    bool separator = true,
    double separatorIndentStart = 0,
    double separatorIndentEnd = 0,
    ScrollController? controller,
    this.primary,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.shrinkWrap = true,
    this.padding,
    this.itemExtent,
    this.itemExtentBuilder,
    this.prototypeItem,
    this.findChildIndexCallback,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    super.key,
  })  : this.controller = controller ?? ScrollController(),
        this.separatorBuilder = _makeSepBuilder(separatorBuilder, separator, separatorIndentStart, separatorIndentEnd),
        super() {
    if (onLoadMore != null) {
      this.controller.addListener(_checkScrollBottom);
    }
  }

  Future<void> _callMore() async {
    FutureOr<void> v = onLoadMore?.call();
    if (v is Future<void>) await v;
  }

  Future<void> _checkScrollBottom() async {
    if (_waitingMore) return;
    var pos = controller.position;
    double maxPos = pos.maxScrollExtent;
    double current = pos.pixels;
    if (current == maxPos) {
      int now = DateTime.now().millisecondsSinceEpoch;
      if (now - _preLoadMoreTime > 1000) {
        _preLoadMoreTime = now;
        try {
          _waitingMore = true;
          await _callMore();
        } finally {
          _waitingMore = false;
        }
      }
    }
  }

  Widget? _buildItemViewRawIndex(BuildContext context, int index) {
    if (items != null) {
      if (index >= 0 && index < items!.length) {
        if (itemView != null) return itemView!.call(context, items![index]);
      } else if (index == items!.length) {
        if (lastItemView != null) return lastItemView!(context);
      }
    }
    return itemBuilder?.call(context, index);
  }

  Widget? _buildItemView(BuildContext context, int index) {
    if (separatorBuilder == null) {
      return _buildItemViewRawIndex(context, index);
    }

    int itemIndex = index ~/ 2;
    if (index.isEven) {
      return _buildItemViewRawIndex(context, itemIndex);
    }
    return separatorBuilder!(context, itemIndex);
  }

  @override
  Widget build(BuildContext context) {
    int? itemLen = items?.length;
    if (itemLen != null && lastItemView != null) {
      itemLen = itemLen + 1;
    }
    int? count = itemCount ?? itemLen;

    if (count != null && separatorBuilder != null) {
      count = math.max(0, count * 2 - 1);
    }
    ListView lv = ListView.builder(
      itemBuilder: _buildItemView,
      itemCount: count,
      controller: controller,
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
    );
    if (onRefresh == null) return lv;
    return lv.refreshIndicator(onRefresh: onRefresh!);
  }
}

int _preLoadMoreTime = 0;
bool _waitingMore = false;

IndexedWidgetBuilder? _makeSepBuilder(IndexedWidgetBuilder? separatorBuilder, bool separator, double separatorIndentStart, double separatorIndentEnd) {
  if (separatorBuilder != null) return separatorBuilder;
  if (!separator) return null;
  return (c, i) => Divider(height: 1, thickness: 1, indent: separatorIndentStart, endIndent: separatorIndentEnd);
}
