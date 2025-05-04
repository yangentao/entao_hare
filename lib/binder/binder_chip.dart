// ignore_for_file: must_be_immutable, non_constant_identifier_names
part of 'binder.dart';

Wrap ChipCheckGroupB<T>(Binder<Set<T>> binder,
    {required Iterable<T> items,
    required OnWidget<T> onLabel,
    bool allowEmpty = true,
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 8,
    WrapAlignment runAlignment = WrapAlignment.start,
    double runSpacing = 8,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    Clip clipBehavior = Clip.none,
    Widget? avatar,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? labelPadding,
    double? pressElevation,
    Color? selectedColor = Colors.blueAccent,
    Color? disabledColor,
    String? tooltip,
    BorderSide? side,
    OutlinedBorder? shape,
    FocusNode? focusNode,
    bool autofocus = false,
    WidgetStateProperty<Color?>? color,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    VisualDensity? visualDensity}) {
  if (!allowEmpty && binder.value.isEmpty) {
    if (items.isNotEmpty) {
      binder.value.add(items.first);
    }
  }
  List<ChoiceChip> chips = items.mapList((T e) => ChoiceChip(
      label: onLabel(e),
      selected: binder.value.contains(e),
      elevation: 3,
      onSelected: (b) {
        Set<T> ls = binder.value;
        if (b) {
          if (!ls.contains(e)) {
            ls.add(e);
            binder.value = ls;
            binder.fireUpdateUI();
            binder.fireChanged();
          }
        } else {
          if (allowEmpty || binder.value.length > 1) {
            if (ls.contains(e)) {
              ls.remove(e);
              binder.value = ls;
              binder.fireUpdateUI();
              binder.fireChanged();
            }
          }
        }
      },
      avatar: avatar,
      labelStyle: labelStyle,
      labelPadding: labelPadding,
      pressElevation: pressElevation,
      selectedColor: selectedColor,
      disabledColor: disabledColor,
      tooltip: tooltip,
      side: side,
      shape: shape,
      focusNode: focusNode,
      autofocus: autofocus,
      color: color,
      backgroundColor: backgroundColor,
      padding: padding,
      visualDensity: visualDensity,
      clipBehavior: clipBehavior));
  return Wrap(
      children: chips,
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior);
}

Wrap ChipRadioGroupB<T>(Binder<T?> binder,
    {required Iterable<T> items,
    required OnWidget<T> onLabel,
    bool allowEmpty = true,
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 8,
    WrapAlignment runAlignment = WrapAlignment.start,
    double runSpacing = 8,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    Clip clipBehavior = Clip.none,
    Widget? avatar,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? labelPadding,
    double? pressElevation,
    Color? selectedColor = Colors.blueAccent,
    Color? disabledColor,
    String? tooltip,
    BorderSide? side,
    OutlinedBorder? shape,
    FocusNode? focusNode,
    bool autofocus = false,
    WidgetStateProperty<Color?>? color,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    VisualDensity? visualDensity}) {
  if (!allowEmpty && binder.value == null) {
    binder.value = items.firstOrNull;
  }
  List<ChoiceChip> chips = items.mapList((T e) => ChoiceChip(
      label: onLabel(e),
      selected: binder.value == e,
      elevation: 3,
      onSelected: (b) {
        if (b) {
          binder.value = e;
          binder.fireUpdateUI();
          binder.fireChanged();
        } else {
          if (binder.value == e) {
            if (allowEmpty) {
              binder.value = null;
              binder.fireUpdateUI();
              binder.fireChanged();
            }
          }
        }
      },
      avatar: avatar,
      labelStyle: labelStyle,
      labelPadding: labelPadding,
      pressElevation: pressElevation,
      selectedColor: selectedColor,
      disabledColor: disabledColor,
      tooltip: tooltip,
      side: side,
      shape: shape,
      focusNode: focusNode,
      autofocus: autofocus,
      color: color,
      backgroundColor: backgroundColor,
      padding: padding,
      visualDensity: visualDensity,
      clipBehavior: clipBehavior));
  return Wrap(
      children: chips,
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior);
}
