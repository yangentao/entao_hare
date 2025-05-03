part of '../fhare.dart';

abstract class CollectionPage<T> extends HarePage with RefreshItemsMixin<T> {
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;

  CollectionPage() : super();

  List<T> get itemList => localFilter(items);

  List<T> localFilter(List<T> localItems) => localItems;

  Widget buildWidget(BuildContext context);

  List<Widget> aboveWidgets(BuildContext context) {
    return [];
  }

  List<Widget> belowWidgets(BuildContext context) {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return ColumnMaxStretch([...aboveWidgets(context), buildWidget(context).expanded(), ...belowWidgets(context)], mainAxisAlignment: mainAxisAlignment);
  }
}
