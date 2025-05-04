// ignore_for_file: must_be_immutable
part of '../entao_hare.dart';

abstract class GridPage<T> extends CollectionPage<T> {
  int? columnCount = 2;
  double preferCrossAxisSize = 80;
  double? mainAxisExtent;
  double mainAxisSpacing = 0.0;
  double crossAxisSpacing = 0.0;
  double childAspectRatio = 1.0;
  EdgeInsetsGeometry padding = xy(0);

  GridPage() : super();

  Widget onItemView(T item);

  @override
  Widget buildWidget(BuildContext context) {
    return XGridView(
      shrinkWrap: true,
      padding: padding,
      crossAxisExtent: preferCrossAxisSize,
      mainAxisExtent: mainAxisExtent,
      crossAxisCount: columnCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      children: itemList.mapList((e) => onItemView(e)),
    ).pullRefresh(() => refreshItems());
  }
}

abstract class GridItemsPage<T> extends CollectionPage<T> {
  int? columnCount;
  double crossAxisExtent = 128;
  double? mainAxisExtent = 64;
  double childAspectRatio = 1.0;
  double mainAxisSpacing = 8;
  double crossAxisSpacing = 8;
  double flexPercent = 0.2;
  EdgeInsetsGeometry padding = xy(8, 8);

  GridItemsPage() : super();

  Widget onItemView(ItemIndexContext<T> iic);

  @override
  List<Widget> aboveWidgets(BuildContext context) {
    return [];
  }

  @override
  List<Widget> belowWidgets(BuildContext context) {
    return [];
    // return ["bottom".text().align(Alignment.bottomCenter)];
  }

  @override
  Widget buildWidget(BuildContext context) {
    return XGridViewItems(
      items: itemList,
      itemView: onItemView,
      shrinkWrap: false,
      padding: padding,
      crossAxisExtent: crossAxisExtent,
      mainAxisExtent: mainAxisExtent,
      crossAxisCount: columnCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      flexPercent: flexPercent,
    );
  }
}

abstract class GridWidgetsPage extends HarePage {
  int? columnCount;
  double crossAxisSize = 128;
  double? mainAxisExtent = 64;
  double childAspectRatio = 1.0;
  double mainAxisSpacing = 8;
  double crossAxisSpacing = 8;
  EdgeInsetsGeometry padding = xy(8, 8);

  GridWidgetsPage() : super();

  List<Widget> onChildrenWidgets(BuildContext context);

  List<Widget> aboveWidgets(BuildContext context) {
    return [];
  }

  List<Widget> belowWidgets(BuildContext context) {
    return ["bottom".text().align(Alignment.bottomCenter)];
  }

  Widget buildWidget(BuildContext context) {
    return XGridView(
      shrinkWrap: false,
      padding: padding,
      crossAxisExtent: crossAxisSize,
      mainAxisExtent: mainAxisExtent,
      crossAxisCount: columnCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      children: onChildrenWidgets(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColumnMaxStretch([...aboveWidgets(context), buildWidget(context).flexible(), ...belowWidgets(context)]);
  }
}
