part of '../app.dart';

extension WidgetRouterDataEx on Widget {
  RouterDataWidget get withRouterData => RouterDataWidget(child: this);
}

class RouterDataWidget extends InheritedWidget {
  final PropMap data;

  RouterDataWidget({required super.child, PropMap? data})
      : this.data = data ?? {},
        super(key: UniqueKey());

  @override
  bool updateShouldNotify(RouterDataWidget oldWidget) {
    return data == oldWidget.data;
  }

  static PropMap? of<T>(BuildContext context) {
    RouterDataWidget? w = context.dependOnInheritedWidgetOfExactType();
    return w?.data;
  }
}

extension RouterDataConetxtExt on BuildContext {
  PropMap routerData() {
    RouterDataWidget w = this.dependOnInheritedWidgetOfExactType()!;
    return w.data;
  }

  void setRouterValue(String key, Object? value) {
    PropMap map = routerData();
    if (value == null) {
      map.remove(key);
    } else {
      map[key] = value;
    }
  }

  T? getRouterValue<T>(String key) {
    PropMap map = routerData();
    return map[key];
  }

  AnyProp<T> routerProp<T extends Object>(String name, {T? missValue}) {
    return AnyProp<T>(map: routerData(), key: name, missValue: missValue);
  }
}
