// ignore_for_file: must_be_immutable
part of 'pages.dart';

abstract class GridPage<T> extends CollectionPage<T> {
  int? columnCount = 2;
  double crossAxisExtent = 80;
  double? mainAxisExtent;
  double mainAxisSpacing = 0.0;
  double crossAxisSpacing = 0.0;
  double childAspectRatio = 1.0;
  double flexPercent = 0.2;
  EdgeInsetsGeometry padding = xy(8, 8);

  GridPage() : super();

  Widget onItemView(ContextIndexItem<T> cii);

  @override
  Widget buildWidget(BuildContext context) {
    return XGridView(
      shrinkWrap: true,
      padding: padding,
      crossAxisExtent: crossAxisExtent,
      mainAxisExtent: mainAxisExtent,
      crossAxisCount: columnCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      flexPercent: flexPercent,
      items: itemList,
      itemView: onItemView,
    ).pullRefresh(refreshItems);
  }
}
