part of 'basic.dart';

Widget StadiumOutlinedButton({required Widget child, VoidCallback? onPressed}) {
  return OutlinedButton(
    onPressed: onPressed,
    child: child,
    style: OutlinedButton.styleFrom(shape: StadiumBorder()),
  );
}

Widget StadiumButton({required Widget child, VoidCallback? onPressed, Color? borderColor, Color? backColor, bool outlined = false}) {
  if (outlined) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        side: borderColor == null ? null : BorderSide(color: borderColor),
        backgroundColor: backColor,
      ),
      child: child,
    );
  }
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(shape: StadiumBorder(), backgroundColor: backColor),
    child: child,
  );
}

/// 高度 比 FilledButton 小
Widget StadiumElevatedButton({required Widget child, VoidCallback? onPressed, Color? fillColor}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: child,
    style: ElevatedButton.styleFrom(shape: StadiumBorder(), backgroundColor: fillColor),
  );
}

extension WidgetButtonsExt on Widget {
  Widget stadiumOutlinedButton(VoidCallback? onPressed) {
    return StadiumOutlinedButton(child: this, onPressed: onPressed);
  }

  Widget stadiumElevatedButton(VoidCallback? onPressed) {
    return StadiumElevatedButton(child: this, onPressed: onPressed);
  }
}

extension StringButtonsExt on String {
  Widget stadiumOutlinedButton(VoidCallback? onPressed, {Color? color}) {
    return StadiumOutlinedButton(
      child: this.text(color: color),
      onPressed: onPressed,
    );
  }

  /// 高度 比 FilledButton 小
  Widget stadiumElevatedButton(VoidCallback? onPressed, {Color? color}) {
    return StadiumElevatedButton(
      child: this.text(color: color),
      onPressed: onPressed,
    );
  }
  Widget actionOnPrimary(VoidCallback? onPressed, {Color? color}) {
    return TextButton(
      onPressed: onPressed,
      child: text(color: color ?? globalTheme.colorScheme.onPrimary),
    );
  }
  Widget button(VoidCallback? onPressed, {Color? color}) {
    return TextButton(
      onPressed: onPressed,
      child: text(color: color),
    );
  }

  Widget textButton(VoidCallback? onPressed, {Color? color}) {
    return TextButton(
      onPressed: onPressed,
      child: text(color: color),
    );
  }

  Widget outlinedButton(VoidCallback? onPressed, {Color? color}) {
    return OutlinedButton(
      onPressed: onPressed,
      child: text(color: color),
    );
  }

  Widget elevatedButton(VoidCallback? onPressed, {Color? color}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: text(color: color),
    );
  }

  Widget filledButton(VoidCallback? onPressed, {Color? color}) {
    return FilledButton(
      onPressed: onPressed,
      child: text(color: color),
    );
  }
}
