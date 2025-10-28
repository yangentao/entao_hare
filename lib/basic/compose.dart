part of 'basic.dart';

ButtonStyle SegStyle = SegmentedButton.styleFrom(
  selectedBackgroundColor: Colors.lightBlue,
  selectedForegroundColor: Colors.white,
  side: BorderSide(color: globalTheme.dividerColor),
);

Widget CirclePoint({required double size, required Color color, String? text, Color? textColor, double? fontSize}) {
  return Container(
    width: size,
    height: size,
    child: text?.text(color: textColor, fontSize: fontSize, mono: true).centered(),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(size / 2)),
  );
}

DecoratedBox RoundRectBox({Widget? child, Color? color, BorderRadius? borderRadius, double radius = 8, BoxShadow? shadow}) {
  return DecoratedBox(
    decoration: BoxDecoration(color: color, borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(radius)), boxShadow: shadow == null ? null : [shadow]),
    child: child,
  );
}

Widget TitleBar(BuildContext context, {required Widget title, List<Widget>? actions, double padX = 16}) {
  return RowMax([
    if (padX > 0) space(width: padX),
    DefaultTextStyle(style: context.themeData.textTheme.titleMedium!, child: title),
    const Spacer(),
    if (actions != null) ...actions,
    if (padX > 0) space(width: padX),
  ]).constrainedBox(minHeight: 56).coloredBox(context.themeData.cardColor);
}

Widget TitleValueView(
  BuildContext context, {
  required List<Widget> left,
  List<Widget>? right,
  double itemSpace = 8,
  double minHeight = 48,
  double padX = 16,
  VoidCallback? onTap,
  VoidCallback? onDoubleTap,
}) {
  late Widget leftWidget;
  if (left.isEmpty) {
    leftWidget = "".text();
  } else if (left.length == 1) {
    leftWidget = left.first;
  } else {
    if (itemSpace > 0) {
      leftWidget = RowMin(left.gaped(() => space(width: itemSpace)));
    } else {
      leftWidget = RowMin(left);
    }
  }
  Widget w = RowMax([
    space(width: padX),
    DefaultTextStyle(style: context.themeData.textTheme.titleMedium!, child: leftWidget),
    const Spacer(),
    if (right != null) ...right.gaped(() => space(width: itemSpace)),
    space(width: padX),
  ], crossAxisAlignment: CrossAxisAlignment.center);
  if (onTap == null && onDoubleTap == null) return w.constrainedBox(minHeight: minHeight);
  return w.inkWell(onTap: onTap, onDoubleTap: onDoubleTap).constrainedBox(minHeight: minHeight);
}

ListView ListViewByItems<T>(List<T> items, Widget Function(T) itemBuilder, {bool seprator = false}) {
  if (seprator) {
    return ListView.separated(shrinkWrap: true, itemBuilder: (c, i) => itemBuilder(items[i]), separatorBuilder: separatorBuilder, itemCount: items.length);
  }
  return ListView.builder(shrinkWrap: true, itemBuilder: (c, i) => itemBuilder(items[i]), itemCount: items.length);
}

ListView ListViewByWidgets(List<Widget> items, {bool seprator = false, EdgeInsetsGeometry? padding}) {
  if (seprator) {
    return ListView.separated(shrinkWrap: true, itemBuilder: (c, i) => items[i], itemCount: items.length, separatorBuilder: separatorBuilder, padding: padding);
  }
  return ListView.builder(shrinkWrap: true, itemBuilder: (c, i) => items[i], itemCount: items.length, padding: padding);
}

Widget PickDateButton(BuildContext context, {required DateTime firstDate, DateTime? lastDate, DateTime? date, void Function(DateTime date)? onChange}) {
  return FilledButton(
    onPressed: () async {
      DateTime? dt = await showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate ?? DateTime.now(), initialDate: date);
      if (dt != null) {
        onChange?.call(dt);
      }
    },
    child: date?.formatDate.text() ?? "选择日期".text(),
  );
}

Widget ButtonGroup(BuildContext context, {required List<String> items, String? selected, required void Function(String item) onChange}) {
  return SegmentedButton<String>(
    segments: items.mapList((e) => ButtonSegment<String>(value: e, label: e.text())),
    selected: selected == null ? {} : {selected},
    showSelectedIcon: false,
    multiSelectionEnabled: false,
    emptySelectionAllowed: true,
    style: SegStyle,
    onSelectionChanged: (st) => st.isEmpty ? 1 == 1 : onChange(st.first),
  );
}

IndexedWidgetBuilder makeSeparatorBuilder({double? height, Color? color, double? indent, double? endIndent, double? thickness = 0}) {
  return (BuildContext context, int index) => Divider(height: height ?? 1, indent: indent, endIndent: endIndent, thickness: thickness, color: color);
}

Widget separatorBuilder(BuildContext context, int index) {
  return Divider(height: 1, thickness: 0);
  // return Container(color: Theme.of(context).dividerColor, height: 1);
}

Widget separator({double? height, Color? color, double? indent, double? endIndent, double? thickness = 1, double? hor}) {
  return Divider(height: height ?? 1, indent: indent ?? hor, endIndent: endIndent ?? hor, thickness: thickness, color: color);
}

Widget LeftRightExpanded(List<Widget> left, Widget right) {
  return Row(children: [...left, space(width: 8), right.expanded()]);
}

Widget LeftRight(List<Widget> left, List<Widget> right) {
  return Row(children: [...left, space(width: 8), const Spacer(), ...right]);
}

Widget LabelWidget(Widget label, Widget widget) {
  return Row(children: [label, space(width: 8), const Spacer(), widget]);
}

Wrap WrapRow(
  List<Widget> children, {
  Axis direction = Axis.horizontal,
  WrapAlignment alignment = WrapAlignment.start,
  WrapAlignment runAlignment = WrapAlignment.start,
  WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.center,
  double spacing = 8,
  double runSpacing = 8,
  TextDirection? textDirection,
  VerticalDirection verticalDirection = VerticalDirection.down,
  Clip clipBehavior = Clip.none,
}) {
  return Wrap(
    alignment: alignment,
    runAlignment: runAlignment,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    clipBehavior: clipBehavior,
    spacing: spacing,
    runSpacing: runSpacing,
    children: children,
    direction: direction,
  );
}

Widget space({double? width, double? height, EdgeInsets? margin}) {
  if (margin == null) return SizedBox(width: width, height: height);
  return Container(height: height, width: width, margin: margin);
}

Column ColumnMinStretch(List<Widget> children, {MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
  return ColumnMin(children, crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: mainAxisAlignment);
}

Column ColumnMaxStretch(List<Widget> children, {MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start}) {
  return ColumnMax(children, crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: mainAxisAlignment);
}

Column ColumnMax(
  List<Widget> children, {
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  TextBaseline? textBaseline,
}) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: crossAxisAlignment,
    mainAxisAlignment: mainAxisAlignment,
    children: children,
    textBaseline: textBaseline,
  );
}

Column ColumnMin(
  List<Widget> children, {
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  TextBaseline? textBaseline,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: crossAxisAlignment,
    mainAxisAlignment: mainAxisAlignment,
    children: children,
    textBaseline: textBaseline,
  );
}

Row RowMax(
  List<Widget> children, {
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  TextBaseline? textBaseline,
}) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    children: children,
    textBaseline: textBaseline,
  );
}

Row RowMin(
  List<Widget> children, {
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  TextDirection? textDirection,
  TextBaseline? textBaseline,
  VerticalDirection verticalDirection = VerticalDirection.down,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    children: children,
    textBaseline: textBaseline,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
  );
}

ExpansionTile ExpandTile(
  Widget title,
  List<Widget> children, {
  Widget? leading,
  Widget? subtitle,
  void Function(bool)? onExpansionChanged,
  Widget? trailing,
  bool showTrailingIcon = true,
  bool initiallyExpanded = false,
  bool maintainState = false,
  EdgeInsetsGeometry? tilePadding,
  CrossAxisAlignment? expandedCrossAxisAlignment = CrossAxisAlignment.start,
  Alignment? expandedAlignment = Alignment.centerLeft,
  EdgeInsetsGeometry? childrenPadding = const Edges.symmetric(horizontal: 12, vertical: 4),
  Color? backgroundColor,
  Color? collapsedBackgroundColor,
  Color? textColor,
  Color? collapsedTextColor,
  Color? iconColor,
  Color? collapsedIconColor,
  ShapeBorder? shape,
  ShapeBorder? collapsedShape,
  Clip? clipBehavior,
  ListTileControlAffinity? controlAffinity = ListTileControlAffinity.leading,
  ExpansibleController? controller,
  bool? dense,
  VisualDensity? visualDensity,
  double? minTileHeight,
  bool? enableFeedback = true,
  bool enabled = true,
  AnimationStyle? expansionAnimationStyle,
}) {
  return ExpansionTile(
    title: title,
    children: children,
    childrenPadding: childrenPadding,
    controlAffinity: controlAffinity,
    expandedAlignment: expandedAlignment,
    expandedCrossAxisAlignment: expandedCrossAxisAlignment,
    initiallyExpanded: initiallyExpanded,
    onExpansionChanged: onExpansionChanged,
    leading: leading,
    subtitle: subtitle,
    trailing: trailing,
    showTrailingIcon: showTrailingIcon,
    maintainState: maintainState,
    tilePadding: tilePadding,
    backgroundColor: backgroundColor,
    collapsedBackgroundColor: collapsedBackgroundColor,
    textColor: textColor,
    collapsedTextColor: collapsedTextColor,
    iconColor: iconColor,
    collapsedIconColor: collapsedIconColor,
    shape: shape,
    collapsedShape: collapsedShape,
    clipBehavior: clipBehavior,
    controller: controller,
    dense: dense,
    visualDensity: visualDensity,
    minTileHeight: minTileHeight,
    enableFeedback: enableFeedback,
    enabled: enabled,
    expansionAnimationStyle: expansionAnimationStyle,
  );
}

Drawer ListDrawer(List<Widget> items, {double? width = 200, List<Widget>? tailItems}) {
  return Drawer(
    width: width,
    child: ColumnMax([ListView(shrinkWrap: true, children: items), Spacer(), ...(tailItems ?? [])]),
  );
}
