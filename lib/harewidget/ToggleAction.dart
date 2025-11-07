part of 'harewidget.dart';

class ToggleIcon extends HareWidget {
  bool value;
  final Widget _onWidget;
  final Widget _offWidget;
  ValueChanged<bool> onChanged;
  double? iconSize;
  Color? colorOn;
  Color? colorOff;

  // ignore: use_key_in_widget_constructors
  ToggleIcon({this.value = false, required Widget on, required Widget off, required this.onChanged, this.colorOn, this.colorOff, this.iconSize})
    : _onWidget = on,
      _offWidget = off;

  // ignore: use_key_in_widget_constructors
  ToggleIcon.icon({required IconData iconData, this.value = false, this.iconSize, this.colorOn, this.colorOff, required this.onChanged})
    : _onWidget = iconData.icon(),
      _offWidget = iconData.icon();

  void update(bool newValue, {bool fire = false}) {
    this.value = newValue;
    updateState();
    if (fire) {
      onChanged(this.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (value) {
      return IconButton(icon: _onWidget, color: colorOn, iconSize: iconSize, onPressed: () => update(!value, fire: true));
    } else {
      return IconButton(icon: _offWidget, color: colorOff, iconSize: iconSize, onPressed: () => update(!value, fire: true));
    }
  }
}

class ToggleText extends HareWidget {
  bool value;
  final Widget _onWidget;
  final Widget _offWidget;
  ValueChanged<bool> onChanged;
  final bool onPrimary;
  Color? colorOn;
  Color? colorOff;
  double? fontSize;

  // ignore: use_key_in_widget_constructors
  ToggleText({this.value = false, required Widget on, required Widget off, required this.onChanged, this.fontSize, this.colorOn, this.colorOff, this.onPrimary = false})
    : _onWidget = on,
      _offWidget = off;

  // ignore: use_key_in_widget_constructors
  ToggleText.text({required String title, this.value = false, this.colorOn, this.colorOff, required this.onChanged, this.fontSize, this.onPrimary = false})
    : _onWidget = title.text(),
      _offWidget = title.text();

  void update(bool newValue, {bool fire = false}) {
    this.value = newValue;
    updateState();
    if (fire) {
      onChanged(this.value);
    }
  }

  Widget get _widget => value ? _onWidget : _offWidget;

  @override
  Widget build(BuildContext context) {
    Color? co;
    if (value) {
      co = colorOn ?? (onPrimary ? context.themeData.colorScheme.onPrimary : context.themeData.colorScheme.primary);
    } else {
      co = colorOff ?? (onPrimary ? context.themeData.colorScheme.onPrimary : context.themeData.unselectedWidgetColor);
    }
    return TextButton(
      child: DefaultTextStyle(
        textAlign: TextAlign.center,
        style: context.themeData.textTheme.titleSmall!.copyWith(fontSize: fontSize, color: co),
        child: _widget,
      ),
      onPressed: () => update(!value, fire: true),
    );
  }
}
