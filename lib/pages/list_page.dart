// ignore_for_file: must_be_immutable
part of 'pages.dart';

abstract class ListPage<T> extends CollectionPage<T> {
  ScrollController scrollController = ScrollController();
  bool separated = true;
  double separatorIndentStart = 0;
  double separatorIndentEnd = 0;
  EdgeInsets? listPadding;
  bool topLoading = true;

  bool bottomLoading = false;

  ListPage() : super();

  Future<void> onLoadMore() async {}

  Widget? onLastItemView(BuildContext context) {
    return null;
  }

  Widget onItemView(ContextIndexItem<T> item);

  @override
  Widget buildWidget(BuildContext context) {
    ListView w = XListView(
      items: itemList,
      itemView: onItemView,
      lastItemView: onLastItemView,
      shrinkWrap: false,
      padding: listPadding,
      separator: separated,
      separatorIndentStart: separatorIndentStart,
      separatorIndentEnd: separatorIndentEnd,
      controller: scrollController,
    );

    if (topLoading || bottomLoading) {
      return w.scrollLoading(onTopStart: topLoading ? refreshItems : null, onBottomStart: bottomLoading ? onLoadMore : null);
    } else {
      return w;
    }
  }
}
