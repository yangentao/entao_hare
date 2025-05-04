part of 'basic.dart';

extension ListResultToast on BaseResult {
  void showError({String? nullMessage}) {
    if (!this.success) {
      Toast.error(this.message ?? nullMessage ?? "操作失败");
    }
  }

  void showMessage({String? nullMessage}) {
    if (this.success) {
      Toast.success(this.message ?? nullMessage ?? "操作成功");
    } else {
      Toast.error(this.message ?? nullMessage ?? "操作失败");
    }
  }
}

class ToastItem {
  Color color;
  Color fillColor;
  String title;
  IconData? icon;
  int durationMS;
  double width;
  Alignment? alignment;

  ToastItem(this.title, {this.durationMS = 3000, this.color = Colors.white, this.fillColor = Colors.black54, this.icon, this.width = 280, this.alignment});

  ToastItem align(Alignment a) {
    alignment = a;
    return this;
  }

  ToastItem center() {
    alignment = Alignment.center;
    return this;
  }

  ToastItem centerBottom(double y) {
    alignment = Alignment(0, y);
    return this;
  }

  ToastItem success() {
    color = Colors.white;
    fillColor = Colors.green.withOpacityX(0.8);
    if (!Toast.noIcon) icon = Icons.check_circle_outlined;
    return this;
  }

  ToastItem warn() {
    color = Colors.white;
    fillColor = Colors.amber.withOpacityX(0.8);
    if (!Toast.noIcon) icon = Icons.warning_amber_rounded;
    return this;
  }

  ToastItem error() {
    color = Colors.white;
    fillColor = Colors.redAccent.withOpacityX(0.8);
    if (!Toast.noIcon) icon = Icons.error_outline;
    return this;
  }

  ToastItem duration(int ms) {
    durationMS = ms.GE(1000);
    return this;
  }

  ToastItem durationLong() {
    durationMS = 5000;
    return this;
  }

  ToastItem durationShort() {
    durationMS = 3000;
    return this;
  }

  Widget build(OverlayContext context) {
    Widget lt = ListTile(
      title: title.text(color: color),
      leading: icon?.icon(color: color),
      trailing: Icons.clear.icon(size: 12, color: Colors.white).inkWell(onTap: () => context.removeDelay(1)),
      horizontalTitleGap: 0,
    ).constrainedBox(minWidth: 200, minHeight: 48, maxWidth: width.GE(200)).physicalModel(color: fillColor, radius: 3, elevation: 3);
    return lt.align(alignment ?? Toast.defaultAlignment);
  }

  void show() {
    Toast.show(this);
  }
}

class Toast {
  static bool noIcon = false;
  static Alignment defaultAlignment = const Alignment(0, 0.7);
  static final List<ToastItem> _items = [];
  static ToastItem? _current;

  static void info(String title, {int durationMS = 3000, Color? fillColor, Color? color}) {
    show(ToastItem(title, fillColor: fillColor ?? Colors.blueAccent, color: color ?? Colors.white).duration(durationMS));
  }

  static void success(String title, {int durationMS = 2000}) {
    show(ToastItem(title).success().duration(durationMS));
  }

  static void warn(String title, {int durationMS = 4000}) {
    show(ToastItem(title).warn().duration(durationMS));
  }

  static void error(String? title, {int durationMS = 5000, String titleMiss = "操作失败"}) {
    show(ToastItem(title ?? titleMiss).error().duration(durationMS));
  }

  static void show(ToastItem item) {
    _items.add(item);
    _showNext();
  }

  static Future<void> _showNext() async {
    if (_current != null) return;
    if (_items.isEmpty) return;
    ToastItem item = _items.removeAt(0);
    _current = item;
    OverlayX ox = OverlayX((c) => item.build(c));
    ox.show();
    ox.removeDelay(item.durationMS);
    ox.onRemoved(() {
      _current = null;
      _showNext();
    });
  }
}
