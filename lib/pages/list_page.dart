// ignore_for_file: must_be_immutable
part of 'pages.dart';

abstract class ListPage<T> extends CollectionPage<T> {
  bool separated = true;
  double separatorIndentStart = 0;
  double separatorIndentEnd = 0;
  EdgeInsets? listPadding;
  ScrollController scrollController = ScrollController();

  ListPage() : super();

  FutureOr<void> onLoadMore() async {}

  Widget? onLastItemView(BuildContext context) {
    return null;
  }

  Widget onItemView(T item);

  @override
  Widget buildWidget(BuildContext context) {
    return XListView(
      items: itemList,
      itemView: (c, item) => onItemView(item),
      lastItemView: onLastItemView,
      padding: listPadding,
      separator: separated,
      separatorIndentStart: separatorIndentStart,
      separatorIndentEnd: separatorIndentEnd,
      onRefresh: refreshItems,
      onLoadMore: onLoadMore,
      controller: scrollController,
    );
  }
}
