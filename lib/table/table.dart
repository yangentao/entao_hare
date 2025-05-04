part of '../entao_hare.dart';

class XDataTable<T> extends HareWidget {
  final List<T> items;
  final DataTableDelegate<T>? delegate;
  final DataTableSelector<T>? selector;
  final DataTableSortor<T>? sorter;
  void Function(T)? onRowLongPress;
  void Function(T)? onRowSecondaryTap;
  void Function(T)? onRowDoubleTap;

  XDataTable({
    required this.items,
    this.delegate,
    this.sorter,
    this.selector,
    this.onRowLongPress,
    this.onRowSecondaryTap,
    this.onRowDoubleTap,
  }) : super() {
    this.delegate?.attach(this);
    this.sorter?.attach(this);
    this.selector?.attach(this);
  }

  Set<T> get selectedItems => selector?.selectedSet ?? {};

  void clearSelected() => selector?.clear();

  DataColumnSortAction? sortLocal<C extends Comparable>(C Function(T e) propCallback) {
    return sorter?.ofLocal(propCallback);
  }

  DataColumnSortAction? sortRemote(String field) {
    return sorter?.ofRemote(field);
  }

  void onSortRemote(String field, bool asc) {
    delegate?.onSortRemote(field, asc);
  }

  List<DataRowY> buildFooterRows() {
    return delegate?.buildFooterRows() ?? [];
  }

  List<DataColumnY> buildColumns(BuildContext context) {
    return delegate?.buildColumns(context) ?? error("NO implement: buildColumns");
  }

  List<DataCellY> buildCells(ItemIndexContext<T> c) {
    return delegate?.buildCells(c) ?? error("NO implement: buildCells");
  }

  DataRowY buildRow(ItemIndexContext<T> c) {
    return DataRowY(
      onSelectChanged: selector?.of(c.item),
      selected: selector?.isSelected(c.item) ?? false,
      cells: buildCells(c),
      onSecondaryTap: bindOne(c.item, onRowSecondaryTap),
      onLongPress: bindOne(c.item, onRowLongPress),
      onDoubleTap: bindOne(c.item, onRowDoubleTap),
    );
  }

  List<DataRowY> buildRows(BuildContext context) {
    return items.mapIndex((n, e) => buildRow(ItemIndexContext<T>(context, n, e)));
  }

  Widget buildTable(BuildContext context) {
    delegate?.onBuildTable(context);
    return DataTableY(
      sortColumnIndex: sorter?.col,
      sortAscending: sorter?.asc ?? true,
      showCheckboxColumn: selector?.enable == true,
      onSelectAll: selector?.ofList(items),
      checkboxHorizontalMargin: 16,
      showBottomBorder: true,
      columnSpacing: 16,
      horizontalMargin: 36,
      columns: buildColumns(context),
      rows: buildRows(context),
      footerRows: buildFooterRows(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTable(context);
  }
}

abstract mixin class DataTableDelegate<T> {
  late XDataTable<T> dataTable;

  void attach(XDataTable<T> dataTable) {
    this.dataTable = dataTable;
  }

  void onBuildTable(BuildContext context) {}

  List<DataColumnY> buildColumns(BuildContext context);

  List<DataCellY> buildCells(ItemIndexContext<T> rc);

  List<DataRowY> buildFooterRows();

  void onSortRemote(String field, bool asc) {}
}

mixin ColumnCellBuilder<T> on DataTableDelegate<T> {
  List<DataColumnCell<T>> _dataColumnCells = [];

  List<DataColumnCell<T>> buildColumnCells(BuildContext context);

  @override
  void onBuildTable(BuildContext context) {
    _dataColumnCells = buildColumnCells(context);
  }

  @override
  List<DataColumnY> buildColumns(BuildContext context) {
    return _dataColumnCells.mapList((e) => e.column);
  }

  @override
  List<DataCellY> buildCells(ItemIndexContext<T> rc) {
    return _dataColumnCells.mapList((e) => e.buildCell(rc));
  }

  @override
  List<DataRowY> buildFooterRows() {
    List<DataRowY> footerRows = [];
    List<List<DataCellY>> lsList = _dataColumnCells.mapList((e) => e.buildFooterCell());
    int? rowCount = lsList.map((e) => e.length).maxValue();
    if (rowCount == null || rowCount == 0) return [];
    for (int row = 0; row < rowCount; ++row) {
      List<DataCellY> cells = [];
      for (int c = 0; c < _dataColumnCells.length; c++) {
        DataCellY? cell = lsList[c].getOr(row);
        if (cell != null) {
          cells.add(cell);
        } else {
          cells.add(DataCellY.empty);
        }
      }
      DataRowY tr = DataRowY(cells: cells);
      footerRows.add(tr);
    }
    return footerRows;
  }
}

class DataColumnCell<T> {
  DataColumnY column;
  DataCellY Function(ItemIndexContext<T>) builder;
  List<DataCellY> Function()? footerBuilder;

  DataCellY buildCell(ItemIndexContext<T> c) {
    return builder.call(c);
  }

  List<DataCellY> buildFooterCell() {
    return footerBuilder?.call() ?? [];
  }

  DataColumnCell.of({required this.column, required this.builder});

  DataColumnCell({
    required Widget label,
    String? tooltip,
    bool numeric = false,
    bool instrict = false,
    DataColumnSortAction? onSort,
    TableColumnWidth? width,
    Alignment? alignment,
    DataCellY Function(ItemIndexContext<T>)? cell,
    Widget Function(ItemIndexContext<T>)? cellWidget,
    Object? Function(ItemIndexContext<T>)? cellProp,
    this.footerBuilder,
  })  : column = DataColumnY(label: label, tooltip: tooltip, numeric: numeric, instrict: instrict, onSort: onSort, width: width, alignment: alignment),
        assert(cell != null || cellProp != null || cellWidget != null),
        this.builder = cell ?? _makeCellBuilder(cellWidget, cellProp);

  static DataCellY Function(ItemIndexContext<E>) _makeCellBuilder<E>(Widget Function(ItemIndexContext<E>)? cellWidget, Object? Function(ItemIndexContext<E>)? onProp) {
    if (cellWidget != null) return (c) => DataCellY(cellWidget.call(c));
    if (onProp != null) return (c) => DataCellY(onProp.call(c)?.toString().text() ?? space(width: 8));
    error("NO cell builder given!");
  }
}
