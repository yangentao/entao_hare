part of '../entao_hare.dart';

typedef OnBuildDialog<T> = Widget Function(DialogBuilderContext<T>);

const EdgeInsets defaultDialogInsets = EdgeInsets.symmetric(horizontal: 36.0, vertical: 24.0);
const EdgeInsets defaultDialogBodyInsets = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

Future<T?> showDialogX<T>(OnBuildDialog<T> callback, {
  EdgeInsets? insetPadding,
  AlignmentGeometry? alignment,
  clipBehavior = Clip.hardEdge,
}) {
  HareBuilder hb = HareBuilder();
  DialogBuilderContext<T> b = DialogBuilderContext(hb);
  hb.builder = (c) {
    b.context = c;
    return callback(b);
  };
  return showDialog<T>(
      context: HareApp.currentContext,
      builder: (c) =>
          Dialog(
            insetPadding: insetPadding ?? defaultDialogInsets,
            alignment: alignment ?? Alignment.center,
            clipBehavior: clipBehavior,
            elevation: 4,
            child: hb,
          ));
}

class DialogBuilderContext<T> {
  static double ACTION_MIN_WIDTH = 80;
  late Color gridSelectedBackground = Colors.blue.withOpacityX(0.2);
  late BuildContext context;
  final HareBuilder _rootWidget;
  Widget? panelTitle;
  Widget? panelActions;
  BoolFunc? okCallback;
  RFunc<DataResult<T>>? onValidator;
  DialogWidth dialogWidth = DialogWidth.middle;
  T? result;
  bool centerActions = true;
  double spaceActions = 12;
  String textCancel = "取消";
  String textOK = "确定";
  PropMap attrMap = {};
  bool _first = true;

  DialogBuilderContext(this._rootWidget);

  void init({VoidCallback? block, T? result}) {
    if (_first) {
      _first = false;
      if (result != null) {
        this.result = result;
      }
      block?.call();
    }
  }

  Widget buildGrid<E>(List<E> items, {
    required Widget Function(ContextIndexItem<E>) builder,
    int columnCount = 0,
    double itemWidth = 80,
    double? itemHeight,
    double aspectRatio = 1.0,
    double verticalSpacing = 0.0,
    double horizontalSpacing = 0.0,
    EdgeInsets? padding,
    String? title,
    bool? ok,
    bool? cancel,
    DialogWidth? dialogWidth,
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
  }) {
    GridView gv = XGridView(
      columnCount: columnCount,
      crossAxisExtent: itemWidth,
      mainAxisExtent: itemHeight,
      childAspectRatio: aspectRatio,
      mainAxisSpacing: verticalSpacing,
      crossAxisSpacing: horizontalSpacing,
      padding: padding,
      shrinkWrap: true,
      children: items.mapIndex((i, e) => builder(ContextIndexItem(context, i, items[i]))),
    );
    return buildScrollable(gv, aboveWidgets: aboveWidgets,
        belowWidgets: belowWidgets,
        title: title,
        ok: ok,
        cancel: cancel,
        dialogWidth: dialogWidth);
  }

  Widget buildList<E>(List<E> items, {
    required Widget Function(ContextIndexItem<E>) builder,
    bool separated = true,
    EdgeInsets? padding,
    String? title,
    bool? ok,
    bool? cancel,
    DialogWidth? dialogWidth,
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
  }) {
    XListView lv = XListView(
      items: items,
      shrinkWrap: true,
      padding: padding,
      separator: separated,
      itemBuilder: (c, i) {
        return builder(ContextIndexItem(c, i, items[i]));
      },
    );
    return buildScrollable(lv, aboveWidgets: aboveWidgets,
        belowWidgets: belowWidgets,
        title: title,
        ok: ok,
        cancel: cancel,
        dialogWidth: dialogWidth);
  }

  Widget buildScrollable(Widget child, {
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
    String? title,
    bool? ok,
    bool? cancel,
    DialogWidth? dialogWidth,
  }) {
    if (title != null) this.title(title.text());
    this.actions(ok: ok, cancel: cancel);
    if (dialogWidth != null) this.dialogWidth = dialogWidth;

    ListWidget ls = [
      if (panelTitle != null) panelTitle!,
      if (aboveWidgets != null) ...aboveWidgets,
      child.flexible(),
      if (belowWidgets != null) ...belowWidgets,
      if (panelActions != null) panelActions!,
    ];
    return _constrainWidth(ls);
  }

  Widget buildColumn(List<Widget> children, {
    String? message,
    TextAlign? messageAlign,
    double? messageMinHeight,
    bool scrollable = false,
    EdgeInsets? padding = defaultDialogBodyInsets,
    String? title,
    bool? ok,
    bool? cancel,
    DialogWidth? dialogWidth,
  }) {
    ListWidget ls;
    if (message != null) {
      ls = [
        messageText(
          message,
          textAlign: messageAlign ?? (children.isEmpty ? TextAlign.center : TextAlign.start),
          minHeight: messageMinHeight ?? (children.isEmpty ? 48 : 32),
        ),
        ...children
      ];
    } else {
      ls = children;
    }
    Widget w = ColumnMinStretch(ls);
    if (padding != null) w = w.padded(padding);
    if (scrollable) w = w.verticalScroll();
    return build(w, flex: true,
        dialogWidth: dialogWidth,
        title: title,
        ok: ok,
        cancel: cancel);
  }

  Widget build(Widget body, {
    bool flex = false,
    String? title,
    bool? ok,
    bool? cancel,
    DialogWidth? dialogWidth,
  }) {
    if (dialogWidth != null) {
      this.dialogWidth = dialogWidth;
    }
    if (title != null) this.title(title.text());
    this.actions(ok: ok, cancel: cancel);
    List<Widget> items = [
      if (panelTitle != null) panelTitle!,
      if (flex) body.flexible(),
      if (!flex) body,
      if (panelActions != null) panelActions!,
    ];
    return _constrainWidth(items);
  }

  Widget _constrainWidth(List<Widget> items) {
    var w = this.dialogWidth;
    if (w.isInstrict) {
      return ColumnMin(items).intrinsicWidth();
    } else if (w.isFixed) {
      return ColumnMinStretch(items).constrainedBox(minHeight: 50, minWidth: 200, maxWidth: w.value.GE(200));
    } else {
      return ColumnMinStretch(items).constrainedBox(minHeight: 50, minWidth: 200);
    }
  }

  Widget messageText(String message, {TextAlign? textAlign, double? minHeight}) {
    return Text(message, style: context.themeData.textTheme.bodyMedium, textAlign: textAlign ?? TextAlign.center).centered().constrainedBox(minHeight: minHeight ?? 56);
  }

  void title(Widget? title, {bool closable = true}) {
    if (title == null) return;
    var w = RowMax(
      [title, if (closable) IconButton(onPressed: clickCancel, icon: Icons.close.icon(size: 16))],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ).padded(edges(left: 16, right: 8, top: 4, bottom: 4)).coloredBox(context.themeData.secondaryHeaderColor);
    panelTitle = DefaultTextStyle(textAlign: TextAlign.left, style: context.themeData.textTheme.titleMedium!, child: w);
  }

  void titleX({Widget? left, Widget? title, Widget? right, bool closable = true}) {
    if (title == null && left == null && right == null) return;
    var w = RowMax(
      [
        if (left != null) left,
        if (title != null) title,
        Spacer(),
        if (right != null) right,
        if (closable) IconButton(onPressed: clickCancel, icon: Icons.close.icon(size: 16))
      ],
    ).padded(edges(left: 16, right: 8, top: 4, bottom: 4)).coloredBox(context.themeData.secondaryHeaderColor);
    panelTitle = DefaultTextStyle(textAlign: TextAlign.left, style: context.themeData.textTheme.titleMedium!, child: w);
  }

  Widget makeAction(String label, VoidCallback onTap) {
    return label.stadiumOutlinedButton(onTap).constrainedBox(minWidth: ACTION_MIN_WIDTH);
  }

  void actions({bool? ok, bool? cancel, List<Widget>? items}) {
    ListWidget list = [...?items];
    if (cancel == true) {
      list << textCancel.stadiumOutlinedButton(clickCancel).constrainedBox(minWidth: ACTION_MIN_WIDTH);
    }
    if (ok == true) {
      list <<
          OutlinedButton(
            onPressed: clickOK,
            child: textOK.text(),
            style: OutlinedButton.styleFrom(shape: StadiumBorder(), backgroundColor: Colors.blueAccent.withOpacityX(0.3)),
          ).constrainedBox(minWidth: ACTION_MIN_WIDTH);
    }
    if (list.isEmpty) return;
    panelActions = RowMax(
      list.gaped(() => space(width: spaceActions)),
      mainAxisAlignment: centerActions ? MainAxisAlignment.center : MainAxisAlignment.end,
    ).padded(xy(10, 8)).shapeDecorated(shape: Border(top: BorderSide(color: context.themeData.dividerColor)));
  }

  void updateState() {
    _rootWidget.updateState();
  }

  void pop([T? result]) {
    Navigator.of(context).pop<T>(result);
  }

  void setResult(T? result) {
    this.result = result;
  }

  void clickCancel() {
    pop();
  }

  void clickOK() {
    if (onValidator != null) {
      DataResult<T> r = onValidator!.call();
      if (!r.success) {
        if (r.message != null) {
          Toast.error(r.message!);
        }
        return;
      }
      result = r.data;
    }
    if (false == okCallback?.call()) return;
    pop(result);
  }

  AnyProp<V> prop<V extends Object >(String name, {V? missValue}) {
    return AnyProp<V>(map: this.attrMap, key: name, missValue: missValue);
  }
}

class ContextIndexItem<T> {
  BuildContext context;
  int index;
  T item;

  ContextIndexItem(this.context, this.index, this.item);
}

class DialogWidth {
  final double value;

  const DialogWidth._(this.value);

  bool get isFill => value < 0;

  bool get isInstrict => value == 0;

  bool get isFixed => value > 0;

  static double W_SMALL = 240;
  static double W_MIDDLE = 360;

  static const DialogWidth instrict = DialogWidth._(0);
  static const DialogWidth fill = DialogWidth._(-1);
  static DialogWidth small = DialogWidth._(W_SMALL);
  static DialogWidth middle = DialogWidth._(W_MIDDLE);

  static DialogWidth fixed(double w) {
    assert(w > 0);
    return DialogWidth._(w);
  }
}
