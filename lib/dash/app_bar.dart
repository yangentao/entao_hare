// ignore_for_file: must_be_immutable, non_constant_identifier_names
part of 'dash.dart';

class HareAppBar extends HareWidget implements PreferredSizeWidget {
  Widget? leading;
  bool automaticallyImplyLeading = true;
  Widget? title;
  List<Widget>? actions;
  Widget? flexibleSpace;
  PreferredSizeWidget? bottom;
  double? elevation;
  double? scrolledUnderElevation;
  bool Function(ScrollNotification) notificationPredicate = defaultScrollNotificationPredicate;
  Color? shadowColor;
  Color? surfaceTintColor;
  ShapeBorder? shape;
  Color? backgroundColor;
  Color? foregroundColor;
  IconThemeData? iconTheme;
  IconThemeData? actionsIconTheme;
  bool primary = true;
  bool? centerTitle;
  bool excludeHeaderSemantics = false;
  double? titleSpacing;
  double toolbarOpacity = 1.0;
  double bottomOpacity = 1.0;
  double? toolbarHeight;
  double? leadingWidth;
  TextStyle? toolbarTextStyle;
  TextStyle? titleTextStyle;
  SystemUiOverlayStyle? systemOverlayStyle;
  bool forceMaterialTransparency = false;
  Clip? clipBehavior;

  @override
  Size preferredSize;

  HareAppBar({
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.scrolledUnderElevation,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.forceMaterialTransparency = false,
    this.clipBehavior,
  })  : preferredSize = _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height),
        super();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      notificationPredicate: notificationPredicate,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: shape,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconTheme: iconTheme,
      actionsIconTheme: actionsIconTheme,
      primary: primary,
      centerTitle: centerTitle,
      excludeHeaderSemantics: excludeHeaderSemantics,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      toolbarHeight: toolbarHeight,
      leadingWidth: leadingWidth,
      toolbarTextStyle: toolbarTextStyle,
      titleTextStyle: titleTextStyle,
      systemOverlayStyle: systemOverlayStyle,
      forceMaterialTransparency: forceMaterialTransparency,
      clipBehavior: clipBehavior,
    );
  }
}

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight) : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}
