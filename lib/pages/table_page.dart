// ignore_for_file: must_be_immutable
part of 'pages.dart';

abstract class TablePageX<T> extends TablePage<T> with ColumnCellBuilder<T> {
  TablePageX() : super();
}

abstract class TablePage<T> extends CollectionPage<T> with DataTableDelegate<T>, ConditionListMix {
  DataTableSortor<T> tableSorter = DataTableSortor(enable: true);
  DataTableSelector<T> tableSelector = DataTableSelector(enable: true);
  late XPagination pagination = XPagination(pageId: this.runtimeType.toString(), onChange: unbindOne<PaginationInfo>(reloadItems));
  double tableWidth = 640;
  late AnyProp<bool> expandQuery = pageProp("query.expanded", missValue: true);

  TablePage() : super();

  void showRowMenu(T item);

  Future<ListResult<T>?> onRequestListResult(QueryBuilder queryBuilder);

  Set<T> get selectedItems => tableSelector.selectedSet;

  void clearSelection() => tableSelector.selectedSet.clear();

  DataColumnSortAction? sortRemote(String field) {
    return tableSorter.ofRemote(field);
  }

  DataColumnSortAction? sortLocal<P extends Comparable>(P? Function(T) prop) {
    return tableSorter.ofLocal(prop);
  }

  ListWidget onExpandItems() {
    return [WrapRow(conditionList)];
  }

  @override
  List<Widget> aboveWidgets(BuildContext context) {
    ListWidget ls = onExpandItems();
    if (ls.isEmpty) return [];
    return [
      ExpandTile(
        "查询".text(),
        ls,
        initiallyExpanded: expandQuery.value!,
        onExpansionChanged: (b) {
          expandQuery.value = b;
        },
      ),
      separator(),
    ];
  }

  @override
  List<Widget> belowWidgets(BuildContext context) {
    return [separator(), pagination];
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
  Future<void> onSortRemote(String field, bool asc) async {
    reloadItems();
  }

  @override
  void onQueryConditionChanged(String? q) {
    pagination.offset = 0;
    reloadItems();
  }

  @override
  Future<List<T>> onRequestItems() async {
    QueryBuilder qb = queryBuilder();
    ListResult<T>? lr = await onRequestListResult(qb);
    if (lr == null) return items;
    if (!lr.success) {
      lr.showError();
      return items;
    }
    pagination.updateByResult(lr);
    return lr.items;
  }

  @override
  Future<void> afterRequestItems() async {
    clearSelection();
    return await super.afterRequestItems();
  }

  QueryBuilder queryBuilder() {
    PaginationInfo info = pagination.paginationInfo;
    return QueryBuilder(
      offset: info.offset,
      limit: info.pageSize,
      sort: [tableSorter.orderByItem()].nonNullList,
      filter: AND(conditionList.mapList((e) => e.condition()).nonNullList),
    );
  }
}
