part of '../dash.dart';

class BreadCrumb<T> extends HareWidget {
  List<BreadItem<T>> items = [];
  Color? color;

  BreadCrumb({List<BreadItem<T>>? items, this.color = Colors.lightBlue})
      : this.items = items ?? [],
        super();

  void pushAll(List<BreadItem<T>> item, {bool update = true}) {
    items.addAll(item);
    if (update) postUpdate();
  }

  void push(BreadItem<T> item, {bool update = true}) {
    items.add(item);
    if (update) postUpdate();
  }

  bool contains(T value) {
    return items.any((e) => e.value == value);
  }

  BreadItem<T>? popLast({bool update = true}) {
    if (items.isEmpty) return null;
    var item = items.removeLast();
    if (update) postUpdate();
    return item;
  }

  BreadItem<T>? pop(T value, {bool update = true}) {
    bool b = items.any((e) => e.value == value);
    if (!b) return null;
    while (items.isNotEmpty) {
      var item = items.removeLast();
      if (item.value == value) {
        if (update) postUpdate();
        return item;
      }
    }
    if (update) postUpdate();
    return null;
  }

  void _onClick(BreadItem<T> item) {
    item.onClick();
  }

  Widget _makeItem(BreadItem<T> item) {
    Widget? ic = item.icon;
    bool hasIcon = ic != null;
    if (hasIcon) {
      ic = IconTheme(child: ic, data: IconThemeData(size: 20, color: color));
    }
    bool hasLabel = item.label.isNotEmpty;
    var w = RowMin([
      if (hasIcon && !hasLabel) ic!,
      if (hasIcon && !hasLabel) space(width: 4),
      if (hasLabel) item.label.text(),
      Icons.arrow_right_outlined.icon(size: 16),
    ]).paddings(left: 8, right: 4, ver: 4).inkWell(onTap: bindOne(item, _onClick));
    return DefaultTextStyle(child: w, softWrap: false, overflow: TextOverflow.fade, style: context.themeData.textTheme.titleSmall!.copyWith(color: color));
  }

  @override
  Widget build(BuildContext context) {
    return RowMin(items.mapList((e) => _makeItem(e)));
  }
}

class BreadItem<T> {
  final String label;
  final Icon? icon;
  final T value;
  final VoidCallback? action;
  final OnValue<T>? callback;

  BreadItem({required this.label, this.icon, required this.value, this.action, this.callback});

  void onClick() {
    action?.call();
    callback?.call(this.value);
  }
}
