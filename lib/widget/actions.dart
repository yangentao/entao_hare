part of '../fhare.dart';

extension StringActionExt on String {

  @Deprecated("Use actionX instead.")
  XAction actionItem(XActionCallback callback, {bool checked = false}) {
    return XAction(this, callback: callback, checked: checked);
  }

  XAction actionX(XActionCallback callback, {bool checked = false}) {
    return XAction(this, callback: callback, checked: checked);
  }

  XAction action(VoidCallback callback, {bool checked = false}) {
    return XAction(this, action: callback, checked: checked);
  }


}


Widget iconPopActions(IconData icon, List<XAction> Function(BuildContext c) callback) {
  return icon.icon().paddings(hor: 16).popActions(builder: callback);
}

Widget moreActions(List<XAction> Function(BuildContext c) callback) {
  return MORE_ICON.icon().paddings(hor: 16).popActions(builder: callback);
}


typedef XActionCallback = void Function(XAction);
typedef XActionDisplay = Widget Function(XAction);

class XAction {
  bool checked;
  String label;
  Icon? icon;
  IconData? iconData;
  Color? color;
  XActionCallback? callback;
  VoidCallback? action;
  XActionDisplay? display;
  HareWidget? _widget;
  bool enable;

  XAction(this.label, {this.icon, this.iconData, this.checked = false, this.enable = true, this.color, this.display, this.action, this.callback});

  Widget get titleWidget => label.text(color: color);

  Icon? get iconWidget => icon ?? iconData?.icon(color: color);

  bool get hasIcon => icon != null || iconData != null;

  @override
  String toString() {
    return "Action($label)";
  }

  void update() {
    _widget?.updateState();
  }

  void onclick() {
    callback?.call(this);
    action?.call();
  }

  ListTile listTile() {
    return ListTile(title: titleWidget, leading: iconWidget, trailing: checked ? Icons.check.icon() : null, onTap: enable ? onclick : null);
  }

  Widget _displayMenuItem(XAction item) {
    if (item.hasIcon || item.checked) {
      return Row(children: [if (item.hasIcon) item.iconWidget!, if (item.hasIcon) space(width: 12), item.titleWidget, if (item.checked) Spacer(), if (item.checked) Icons.check.icon()]);
    }
    return item.titleWidget;
  }

  PopupMenuItem<XAction> menuitem() {
    return PopupMenuItem(value: this, child: display?.call(this) ?? _displayMenuItem(this));
  }

  HareWidget elevatedButton() {
    return HareBuilder((c) {
      return ElevatedButton(onPressed: enable ? onclick : null, child: display?.call(this) ?? titleWidget);
    }).also((e) => _widget = e);
  }

  HareWidget outlineButton() {
    return HareBuilder((c) {
      return OutlinedButton(onPressed: enable ? onclick : null, child: display?.call(this) ?? titleWidget);
    }).also((e) => _widget = e);
  }

  HareWidget textButton() {
    return HareBuilder((c) {
      return TextButton(onPressed: enable ? onclick : null, child: display?.call(this) ?? titleWidget);
    }).also((e) => _widget = e);
  }

  HareWidget iconButton() {
    return HareBuilder((c) {
      return IconButton(onPressed: enable ? onclick : null, icon: iconWidget ?? Icons.error_outline.icon(), tooltip: label);
    }).also((e) => _widget = e);
  }

  HareWidget button() {
    if (hasIcon) return iconButton();
    return textButton();
  }

  HareWidget chip({bool noIcon = true}) {
    return HareBuilder((c) {
      return ActionChip(
          label: display?.call(this) ?? titleWidget,
          avatar: (!hasIcon || noIcon) ? null : CircleAvatar(backgroundColor: Colors.transparent, foregroundColor: HareApp.textTheme.labelMedium?.color, child: iconWidget),
          onPressed: enable ? onclick : null);
    }).also((e) => _widget = e);
  }
}
