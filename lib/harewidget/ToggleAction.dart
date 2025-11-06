part of 'harewidget.dart';

class ToggleAction extends HareWidget {
  bool value;
  final bool icon;
  final Widget _onWidget;
  final Widget _offWidget;
  ValueChanged<bool> onChanged;

  // ignore: use_key_in_widget_constructors
  ToggleAction({this.value = true, required Widget on, required Widget off, required this.onChanged, this.icon = true}) : _onWidget = on, _offWidget = off;

  void update(bool newValue, {bool fire = false}) {
    this.value = newValue;
    updateState();
    if (fire) {
      onChanged(this.value);
    }
  }

  void _clickButton() {
    value = !value;
    updateState();
    onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    Widget w = value ? _onWidget : _offWidget;
    if (icon) {
      return IconButton(icon: w, onPressed: _clickButton);
    } else {
      return TextButton(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: context.themeData.textTheme.titleSmall!.copyWith(color: context.themeData.colorScheme.onPrimary),
          child: w,
        ),
        onPressed: _clickButton,
      );
    }
  }
}
