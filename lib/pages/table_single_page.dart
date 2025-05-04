// ignore_for_file: must_be_immutable
part of 'pages.dart';

abstract class TableSinglePage<T> extends CollectionPage<T> with DataTableDelegate<T> {
  DataTableSortor<T> tableSorter = DataTableSortor(enable: true);
  DataTableSelector<T> tableSelector = DataTableSelector(enable: true);
  double tableWidth = 640;
  late AnyProp<bool> expandQuery = pageProp("query.expanded", missValue: true);

  TableSinglePage() : super();

  void showRowMenu(T item);

  ListWidget onQueryWidgets();

  Set<T> get selectedItems => tableSelector.selectedSet;

  void clearSelection() => tableSelector.selectedSet.clear();

  DataColumnSortAction? sortLocal<P extends Comparable>(P? Function(T) prop) {
    return tableSorter.ofLocal(prop);
  }

  @override
  List<Widget> aboveWidgets(BuildContext context) {
    ListWidget ls = onQueryWidgets();
    if (ls.isEmpty) return [];
    return [
      ExpandTile(
        "查询".text(),
        [WrapRow(ls)],
        initiallyExpanded: expandQuery.value!,
        onExpansionChanged: (b) {
          expandQuery.value = b;
        },
      ),
      separator(),
    ];
  }

  void onDoubleTapRow(T item) {}

  void onLongPressRow(T item) {
    showRowMenu(item);
  }

  void onSecondaryTapRow(T item) {
    showRowMenu(item);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return XDataTable<T>(
      items: itemList,
      delegate: this,
      sorter: tableSorter,
      selector: tableSelector,
      onRowLongPress: onLongPressRow,
      onRowSecondaryTap: onSecondaryTapRow,
      onRowDoubleTap: onDoubleTapRow,
    ).carded().fillOrScrollX(width: tableWidth).verScrollBar();
  }

  @override
  Future<void> afterRequestItems() async {
    clearSelection();
    return await super.afterRequestItems();
  }
}
