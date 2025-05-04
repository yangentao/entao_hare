part of '../entao_hare.dart';

class DataTableSortor<E> {
  late XDataTable<E> table;
  int? col;
  bool asc = true;
  bool enable;
  String? field;

  DataTableSortor({this.enable = true});

  void attach(XDataTable<E> table) {
    this.table = table;
  }

  DataColumnSortAction? ofLocal<C extends Comparable>(C? Function(E e) prop) {
    return enable ? _TableLocalSortor<E, C>(this, prop).call : null;
  }

  DataColumnSortAction? ofRemote(String field) {
    return enable ? _TableRemoteSortor<E>(this, field).call : null;
  }

  OrderByItem? orderByItem() {
    return field == null ? null : OrderByItem(asc: asc, field: field!);
  }

  void updateOrder(String? field, bool asc) {
    this.field = field;
    this.asc = asc;
  }
}

class _TableRemoteSortor<E> {
  DataTableSortor<E> sortor;
  String field;

  _TableRemoteSortor(this.sortor, this.field);

  void call(int col, bool asc) {
    sortor.col = col;
    sortor.asc = asc;
    sortor.field = field;
    sortor.table.onSortRemote(field, asc);
    sortor.table.updateState();
  }
}

class _TableLocalSortor<E, C extends Comparable> {
  DataTableSortor<E> sortor;
  C? Function(E e) propCallback;

  _TableLocalSortor(this.sortor, this.propCallback);

  void call(int col, bool asc) {
    sortor.col = col;
    sortor.asc = asc;
    sortor.table.items.sortProp<C>(propCallback, desc: !asc);
    sortor.table.updateState();
  }
}
