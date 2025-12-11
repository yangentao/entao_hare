part of 'widgets.dart';

extension WidgetPopExt on Widget {
  PopMenu<XAction> contextActions({
    required List<XAction> actions,
    VoidCallback? onCanceled,
    bool enable = true,
    bool popOnTap = false,
    bool popOnLongPress = true,
    bool popOnRightClick = true,
    bool useRootNavigator = true,
    Offset offset = Offset.zero,
    Color? hoverColor,
    double? borderRadius = 3,
  }) {
    List<PopupMenuEntry<XAction>> builder(BuildContext context) {
      return actions.mapIndex((n, e) => e.menuitem());
    }

    return PopMenu<XAction>(
      child: this,
      builder: builder,
      onSelected: (a) => a.onclick(),
      onCanceled: onCanceled,
      initialValue: null,
      enable: enable,
      popOnTap: popOnTap,
      popOnLongPress: popOnLongPress,
      popOnRightClick: popOnRightClick,
      useRootNavigator: useRootNavigator,
      offset: offset,
      hoverColor: hoverColor,
      borderRadius: borderRadius,
    );
  }

  PopMenu<T> contextMenu<T>({
    List<LabelValue<T>>? values,
    List<PopupMenuEntry<T>>? items,
    PopupMenuItemBuilder<T>? builder,
    void Function(T)? onSelected,
    VoidCallback? onCanceled,
    T? initialValue,
    bool enable = true,
    bool popOnTap = false,
    bool popOnLongPress = true,
    bool popOnRightClick = true,
    bool useRootNavigator = true,
    Offset offset = Offset.zero,
    Color? hoverColor,
    double? borderRadius = 3,
  }) {
    PopupMenuItemBuilder<T> b;
    if (builder != null) {
      b = builder;
    } else if (items != null) {
      b = (c) => items;
    } else if (values != null) {
      b = (c) => values.mapList((e) => PopupMenuItem<T>(child: e.label.text(), value: e.value));
    } else {
      b = (c) => [];
    }
    return PopMenu(
      child: this,
      builder: b,
      onSelected: onSelected,
      onCanceled: onCanceled,
      initialValue: initialValue,
      enable: enable,
      popOnTap: popOnTap,
      popOnLongPress: popOnLongPress,
      popOnRightClick: popOnRightClick,
      useRootNavigator: useRootNavigator,
      offset: offset,
      hoverColor: hoverColor,
      borderRadius: borderRadius,
    );
  }
}

class PopMenu<T> extends StatefulWidget {
  final Widget child;
  final PopupMenuItemBuilder<T> builder;
  final Offset offset;
  final T? initialValue;
  final bool useRootNavigator;
  final void Function(T)? onSelected;
  final VoidCallback? onCanceled;
  final bool popOnTap;
  final bool popOnRightClick;
  final bool popOnLongPress;
  final bool enable;
  final Color? hoverColor;
  final double? borderRadius;

  const PopMenu({
    required this.child,
    required this.builder,
    this.onSelected,
    this.onCanceled,
    this.initialValue,
    this.enable = true,
    this.popOnTap = false,
    this.popOnLongPress = true,
    this.popOnRightClick = true,
    this.useRootNavigator = true,
    this.offset = Offset.zero,
    this.hoverColor,
    this.borderRadius = 3,
    super.key,
  }) : super();

  @override
  PopMenuState<T> createState() {
    return PopMenuState<T>();
  }
}

class PopMenuState<T> extends State<PopMenu<T>> {
  Offset mouseLocalPosition = Offset.zero;

  PopMenuState();

  void _showContextMenu() {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context, rootNavigator: widget.useRootNavigator).overlay!.context.findRenderObject()! as RenderBox;
    Offset offset = mouseLocalPosition + widget.offset;
    final RelativeRect position;
    position = RelativeRect.fromRect(
      Rect.fromPoints(button.localToGlobal(offset, ancestor: overlay), button.localToGlobal(Offset(100, 60) + offset, ancestor: overlay)),
      Offset.zero & overlay.size,
    );

    final List<PopupMenuEntry<T>> items = widget.builder(context);
    if (items.isEmpty) return;
    showMenu<T?>(context: context, items: items, initialValue: widget.initialValue, position: position, useRootNavigator: widget.useRootNavigator).then<void>((
      T? newValue,
    ) {
      if (!mounted) {
        return null;
      }
      if (newValue == null) {
        widget.onCanceled?.call();
        return null;
      }
      widget.onSelected?.call(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enable) return widget.child;
    InkWell well = InkWell(
      onTap: widget.popOnTap ? _showContextMenu : null,
      onLongPress: widget.popOnLongPress ? _showContextMenu : null,
      onSecondaryTap: widget.popOnRightClick ? _showContextMenu : null,
      canRequestFocus: false,
      enableFeedback: true,
      hoverColor: widget.hoverColor,
      borderRadius: widget.borderRadius == null ? null : BorderRadius.all(Radius.circular(widget.borderRadius!)),
      child: widget.child,
    );
    // return well;
    return Listener(child: well, onPointerDown: _onMouseDown);
  }

  void _onMouseDown(PointerDownEvent evt) {
    mouseLocalPosition = evt.localPosition;
  }
}
