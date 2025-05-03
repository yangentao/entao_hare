part of '../basic.dart';

extension StringText on String {
  ActionChip actionChip(VoidCallback? onPressed, {Color? color, double paddingX = 8, double elevation = 3}) {
    return ActionChip(label: text(color: color).paddings(hor: paddingX), elevation: elevation, onPressed: onPressed);
  }

  SelectableText textSelectable({TextAlign? align, TextStyle? style, int? maxLines, VoidCallback? onTap}) {
    return SelectableText(this, textAlign: align, style: style, maxLines: maxLines, onTap: onTap);
  }

  Text text(
      {Key? key,
      TextAlign? align,
      TextStyle? style,
      bool? mono,
      double? fontSize,
      Color? color,
      FontWeight? weight,
      int? maxLines,
      bool? softWrap,
      TextOverflow? overflow = TextOverflow.clip,
      Locale? locale}) {
    TextStyle? st;
    if (style == null && (fontSize != null || color != null || weight != null || mono == true)) {
      st = TextStyle(fontFeatures: mono == true ? [FontFeature.tabularFigures()] : null, fontSize: fontSize, color: color, fontWeight: weight);
    }
    return Text(this, key: key, style: style ?? st, textAlign: align, overflow: overflow, softWrap: softWrap, maxLines: maxLines, locale: locale);
  }

  Text bodyLarge(
      {Key? key,
      BuildContext? context,
      TextAlign? align,
      double? fontSize,
      Color? color,
      FontWeight? fontWeight,
      int? maxLines,
      bool? softWrap,
      TextOverflow? overflow = TextOverflow.clip,
      Locale? locale}) {
    BuildContext c = context ?? globalContext;
    TextStyle style = c.themeData.textTheme.bodyLarge!.copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight);
    return Text(this, key: key, style: style, textAlign: align, overflow: overflow, softWrap: softWrap, maxLines: maxLines, locale: locale);
  }

  Text bodyMedium(
      {Key? key,
      BuildContext? context,
      TextAlign? align,
      double? fontSize,
      Color? color,
      FontWeight? fontWeight,
      int? maxLines,
      bool? softWrap,
      TextOverflow? overflow = TextOverflow.clip,
      Locale? locale}) {
    BuildContext c = context ?? globalContext;
    TextStyle style = c.themeData.textTheme.bodyMedium!.copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight);
    return Text(this, key: key, style: style, textAlign: align, overflow: overflow, softWrap: softWrap, maxLines: maxLines, locale: locale);
  }

  Text bodySmall(
      {Key? key,
      BuildContext? context,
      TextAlign? align,
      double? fontSize,
      Color? color,
      FontWeight? fontWeight,
      int? maxLines,
      bool? softWrap,
      TextOverflow? overflow = TextOverflow.clip,
      Locale? locale}) {
    BuildContext c = context ?? globalContext;
    TextStyle style = c.themeData.textTheme.bodySmall!.copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight);
    return Text(this, key: key, style: style, textAlign: align, overflow: overflow, softWrap: softWrap, maxLines: maxLines, locale: locale);
  }

  Text titleSmall(
      {Key? key,
      BuildContext? context,
      TextAlign? align,
      double? fontSize,
      Color? color,
      FontWeight? fontWeight,
      int? maxLines,
      bool? softWrap,
      TextOverflow? overflow = TextOverflow.clip,
      Locale? locale}) {
    BuildContext c = context ?? globalContext;
    TextStyle style = c.themeData.textTheme.titleSmall!.copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight);
    return Text(this, key: key, style: style, textAlign: align, overflow: overflow, softWrap: softWrap, maxLines: maxLines, locale: locale);
  }

  Text titleMedium(
      {Key? key,
      BuildContext? context,
      TextAlign? align,
      double? fontSize,
      Color? color,
      FontWeight? fontWeight,
      int? maxLines,
      bool? softWrap,
      TextOverflow? overflow = TextOverflow.clip,
      Locale? locale}) {
    BuildContext c = context ?? globalContext;
    TextStyle style = c.themeData.textTheme.titleMedium!.copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight);
    return Text(this, key: key, style: style, textAlign: align, overflow: overflow, softWrap: softWrap, maxLines: maxLines, locale: locale);
  }

  Text titleLarge(
      {Key? key,
      BuildContext? context,
      TextAlign? align,
      double? fontSize,
      Color? color,
      FontWeight? fontWeight,
      int? maxLines,
      bool? softWrap,
      TextOverflow? overflow = TextOverflow.clip,
      Locale? locale}) {
    BuildContext c = context ?? globalContext;
    TextStyle style = c.themeData.textTheme.titleLarge!.copyWith(color: color, fontSize: fontSize, fontWeight: fontWeight);
    return Text(this, key: key, style: style, textAlign: align, overflow: overflow, softWrap: softWrap, maxLines: maxLines, locale: locale);
  }

  RawChip rawChip({
    ChipThemeData? defaultProperties,
    Widget? avatar,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? labelPadding,
    Widget? deleteIcon,
    void Function()? onDeleted,
    Color? deleteIconColor,
    String? deleteButtonTooltipMessage,
    void Function()? onPressed,
    void Function(bool)? onSelected,
    double? pressElevation,
    bool tapEnabled = true,
    bool selected = false,
    bool isEnabled = true,
    Color? disabledColor,
    Color? selectedColor,
    String? tooltip,
    BorderSide? side,
    OutlinedBorder? shape,
    Clip clipBehavior = Clip.none,
    FocusNode? focusNode,
    bool autofocus = false,
    WidgetStateProperty<Color?>? color,
    Color? backgroundColor,
    MaterialTapTargetSize? materialTapTargetSize,
    double? elevation = 3,
    Color? shadowColor,
    Color? surfaceTintColor,
    IconThemeData? iconTheme,
    Color? selectedShadowColor,
    bool? showCheckmark,
    Color? checkmarkColor,
    ShapeBorder avatarBorder = const CircleBorder(),
    BoxConstraints? avatarBoxConstraints,
    BoxConstraints? deleteIconBoxConstraints,
    ChipAnimationStyle? chipAnimationStyle,
  }) {
    return RawChip(
        label: this.text(),
        padding: padding,
        defaultProperties: defaultProperties,
        avatar: avatar,
        labelStyle: labelStyle,
        visualDensity: visualDensity,
        labelPadding: labelPadding,
        deleteIcon: deleteIcon,
        onDeleted: onDeleted,
        deleteIconColor: deleteIconColor,
        deleteButtonTooltipMessage: deleteButtonTooltipMessage,
        onPressed: onPressed,
        onSelected: onSelected,
        pressElevation: pressElevation,
        tapEnabled: tapEnabled,
        selected: selected,
        isEnabled: isEnabled,
        disabledColor: disabledColor,
        selectedColor: selectedColor,
        tooltip: tooltip,
        side: side,
        shape: shape,
        clipBehavior: clipBehavior,
        focusNode: focusNode,
        autofocus: autofocus,
        color: color,
        backgroundColor: backgroundColor,
        materialTapTargetSize: materialTapTargetSize,
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        iconTheme: iconTheme,
        selectedShadowColor: selectedShadowColor,
        showCheckmark: showCheckmark,
        checkmarkColor: checkmarkColor,
        avatarBorder: avatarBorder,
        avatarBoxConstraints: avatarBoxConstraints,
        deleteIconBoxConstraints: deleteIconBoxConstraints,
        chipAnimationStyle: chipAnimationStyle);
  }
}
