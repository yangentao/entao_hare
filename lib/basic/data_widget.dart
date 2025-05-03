part of '../basic.dart';

class DataWidget<T> extends InheritedWidget {
  final T data;

  DataWidget({required super.child, required this.data}) : super(key: UniqueKey());

  @override
  bool updateShouldNotify(DataWidget oldWidget) {
    return data == oldWidget.data;
  }

  static T? dataOf<T>(BuildContext context) {
    DataWidget<T>? w = context.dependOnInheritedWidgetOfExactType<DataWidget<T>>();
    return w?.data;
  }
}
