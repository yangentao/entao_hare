part of 'table.dart';

typedef DataTableSelectAction = void Function(bool?);

class DataTableSelector<T> {
  late XDataTable<T> table;
  Set<T> selectedSet = {};
  bool enable;

  void Function(Set<T>)? onSelectChange;

  DataTableSelector({this.enable = true});

  void attach(XDataTable<T> table) {
    this.table = table;
  }

  bool get isEmpty => selectedSet.isEmpty;

  void fireSelectChange() {
    onSelectChange?.call(selectedSet);
  }

  void clear() {
    selectedSet.clear();
    table.updateState();
  }

  bool isSelected(T item) {
    return enable ? selectedSet.contains(item) : false;
  }

  DataTableSelectAction? of(T item) {
    return ofList([item]);
  }

  DataTableSelectAction? ofList(List<T> items) {
    return enable ? _ItemSelector(this, items).call : null;
  }
}

class _ItemSelector<T> {
  DataTableSelector<T> selector;
  List<T> items;

  _ItemSelector(this.selector, this.items);

  void call(bool? b) {
    if (b == true) {
      selector.selectedSet.addAll(items);
    } else if (b == false) {
      selector.selectedSet.removeAll(items);
    }
    selector.table.updateState();
    selector.fireSelectChange();
  }
}
