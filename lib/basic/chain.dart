part of 'basic.dart';

extension IconDataExt on IconData {
  Icon icon({double? size, Color? color}) => Icon(this, size: size, color: color);

  IconButton button({VoidCallback? onPressed, Color? color, double? iconSize, VisualDensity? visualDensity, EdgeInsetsGeometry? padding}) {
    return IconButton(onPressed: onPressed, icon: this.icon(), color: color, iconSize: iconSize, visualDensity: visualDensity, padding: padding);
  }
}

extension ListRowExt<T extends Widget> on List<T> {
  Stack stack({AlignmentGeometry alignment = Alignment.topLeft, StackFit fit = StackFit.loose}) {
    return Stack(children: this, alignment: alignment, fit: fit);
  }

  Row rowMin({MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start, CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) {
    return RowMin(this, mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment);
  }

  Row rowMax({MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start, CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) {
    return RowMax(this, mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment);
  }

  Column columnMin({MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start, CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) {
    return ColumnMin(this, mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment);
  }

  Column columnMax({MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start, CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) {
    return ColumnMax(this, mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment);
  }

  Wrap wraped({
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 0.0,
    WrapAlignment runAlignment = WrapAlignment.start,
    double runSpacing = 0.0,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
    VerticalDirection verticalDirection = VerticalDirection.down,
    Clip clipBehavior = Clip.none,
  }) {
    return Wrap(
      children: this,
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
    );
  }
}

extension WidgetChainExt on Widget {
  Widget safeArea(
      {bool left = true, bool top = true, bool right = true, bool bottom = true, EdgeInsets minimum = EdgeInsets.zero, bool maintainBottomViewPadding = false}) {
    return SafeArea(child: this, left: left, top: top, right: right, bottom: bottom, minimum: minimum, maintainBottomViewPadding: maintainBottomViewPadding);
  }

  MatrixTransition matrixTransition(
      {Key? key,
      required Animation<double> animation,
      required Matrix4 Function(double) onTransform,
      Alignment alignment = Alignment.center,
      FilterQuality? filterQuality}) {
    return MatrixTransition(child: this, key: key, animation: animation, onTransform: onTransform, alignment: alignment, filterQuality: filterQuality);
  }

  ScaleTransition scaleTransition({Key? key, required Animation<double> scale, Alignment alignment = Alignment.center, FilterQuality? filterQuality}) {
    return ScaleTransition(child: this, key: key, scale: scale, alignment: alignment, filterQuality: filterQuality);
  }

  AnimatedBuilder animatedBuilder({Key? key, required Listenable animation, required Widget Function(BuildContext, Widget?) builder}) {
    return AnimatedBuilder(child: this, key: key, animation: animation, builder: builder);
  }

  SizeTransition sizeTransition(
      {Key? key, Axis axis = Axis.vertical, required Animation<double> sizeFactor, double axisAlignment = 0.0, double? fixedCrossAxisSizeFactor}) {
    return SizeTransition(child: this, key: key, axis: axis, sizeFactor: sizeFactor, axisAlignment: axisAlignment, fixedCrossAxisSizeFactor: fixedCrossAxisSizeFactor);
  }

  FadeTransition fadeTransition({Key? key, required Animation<double> opacity, bool alwaysIncludeSemantics = false}) {
    return FadeTransition(child: this, key: key, opacity: opacity, alwaysIncludeSemantics: alwaysIncludeSemantics);
  }

  SlideTransition slideTransition({Key? key, required Animation<Offset> position, bool transformHitTests = true, TextDirection? textDirection}) {
    return SlideTransition(child: this, key: key, position: position, transformHitTests: transformHitTests, textDirection: textDirection);
  }

  RotationTransition rotationTransition({Key? key, required Animation<double> turns, Alignment alignment = Alignment.center, FilterQuality? filterQuality}) {
    return RotationTransition(child: this, key: key, turns: turns, alignment: alignment, filterQuality: filterQuality);
  }

  Widget opacity(double opacity, [bool alwaysIncludeSemantics = false]) {
    return Opacity(child: this, opacity: opacity, alwaysIncludeSemantics: alwaysIncludeSemantics);
  }

  Widget wellAction({Alignment? alignment = Alignment.center, Color? fillColor, double fillOpacity = 0.4, Color? hoverColor, double radius = 4, VoidCallback? onTap}) {
    Widget w = this;
    if (alignment != null) w = w.align(alignment);
    Color fc = fillColor ?? (globalContext.isDark ? Colors.grey[700]! : Colors.grey[400]!);
    w = w.roundRect(fillColor: fc.withOpacityX(fillOpacity), radius: radius);

    Color h = globalTheme.colorScheme.primary.withAlpha(125);
    return w.inkWell(hoverColor: hoverColor ?? h, borderRadius: BorderRadius.circular(radius), onTap: onTap);
  }

  Widget defaultTextStyle({
    required TextStyle style,
    TextAlign? textAlign,
    bool softWrap = true,
    TextOverflow overflow = TextOverflow.clip,
    int? maxLines,
    TextWidthBasis textWidthBasis = TextWidthBasis.parent,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return DefaultTextStyle(
      child: this,
      style: style,
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  Widget physicalModel({
    required Color color,
    double? radius = 3,
    double elevation = 3,
    Color shadowColor = Colors.black,
    BorderRadius? borderRadius,
  }) {
    return PhysicalModel(
      color: color,
      elevation: elevation,
      shadowColor: shadowColor,
      borderRadius: borderRadius ?? BorderRadius.circular(radius ?? 3),
      child: this,
    );
  }

  Widget refreshIndicator({required Future<void> Function() onRefresh}) {
    return RefreshIndicator(child: this, onRefresh: onRefresh);
  }

  Stack stack(
      {AlignmentGeometry alignment = AlignmentDirectional.topStart, TextDirection? textDirection, StackFit fit = StackFit.loose, Clip clipBehavior = Clip.hardEdge}) {
    return Stack(children: [this], alignment: alignment, textDirection: textDirection, fit: fit, clipBehavior: clipBehavior);
  }

  GestureDetector gesture(
      {GestureTapCallback? onTap,
      GestureTapCallback? onDoubleTap,
      GestureTapCallback? onSecondaryTap,
      GestureTapCallback? onRightTap,
      GestureLongPressCallback? onLongPress,
      GestureDragUpdateCallback? onPanUpdate}) {
    return GestureDetector(
      child: this,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onSecondaryTap: onSecondaryTap ?? onRightTap,
      onPanUpdate: onPanUpdate,
    );
  }

  Tab tab({double? height}) {
    return Tab(child: this, height: height);
  }

  Positioned positioned({double? left, double? top, double? right, double? bottom, double? width, double? height}) {
    return Positioned(child: this, left: left, top: top, right: right, bottom: bottom, width: width, height: height);
  }

  Positioned positionedFill({
    double? left = 0,
    double? top = 0,
    double? right = 0,
    double? bottom = 0,
  }) {
    return Positioned.fill(child: this, left: left, top: top, right: right, bottom: bottom);
  }

  Widget labeled(Widget label) {
    return RowMin([label, space(width: 8), this]);
  }

  AspectRatio aspectRatio(double ratio) {
    return AspectRatio(aspectRatio: ratio, child: this);
  }

  Transform flip({bool flipX = false, bool flipY = false, Offset? origin, FilterQuality? filterQuality}) {
    return Transform.flip(flipX: flipX, flipY: flipY, origin: origin, filterQuality: filterQuality, child: this);
  }

  RotatedBox rotatedBox(int quarterTurns) {
    return RotatedBox(child: this, quarterTurns: quarterTurns);
  }

  ConstrainedBox constrainedBox({double minWidth = 0, double maxWidth = double.infinity, double minHeight = 0, double maxHeight = double.infinity}) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight),
      child: this,
    );
  }

  Container container({
    Key? key,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Alignment? alignment,
    Color? color,
    double? radius,
    BoxConstraints? constraints,
    Decoration? decoration,
    double? width,
    double? height,
    Decoration? foregroundDecoration,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip clipBehavior = Clip.none,
  }) {
    Decoration? dec = decoration ?? (radius == null ? null : BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(radius))));
    return Container(
      child: this,
      key: key,
      padding: padding,
      margin: margin,
      alignment: alignment,
      color: color,
      constraints: constraints,
      decoration: dec,
      width: width,
      height: height,
      foregroundDecoration: foregroundDecoration,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
    );
  }

  IntrinsicWidth intrinsicWidth({double? stepWidth, double? stepHeight}) {
    return IntrinsicWidth(child: this, stepHeight: stepHeight, stepWidth: stepWidth);
  }

  IntrinsicHeight intrinsicHeight() {
    return IntrinsicHeight(child: this);
  }

  LimitedBox limited({double? maxWidth, double? maxHeight}) {
    return LimitedBox(child: this, maxWidth: maxWidth ?? double.infinity, maxHeight: maxHeight ?? double.infinity);
  }

  Padding paddings({double? left, double? top, double? right, double? bottom, double? hor, double? ver, double? all}) {
    var e = EdgeInsets.fromLTRB(left ?? hor ?? all ?? 0, top ?? ver ?? all ?? 0, right ?? hor ?? all ?? 0, bottom ?? ver ?? all ?? 0);
    return Padding(padding: e, child: this);
  }

  Widget padded(EdgeInsets? insets) {
    if (insets == null) return this;
    return Padding(padding: insets, child: this);
  }

  SizedBox sizedBox({double? width, double? height, double? all}) {
    if (all != null && all > 0) {
      return SizedBox(width: all, height: all, child: this);
    }
    return SizedBox(width: width, height: height, child: this);
  }

  Flexible flexible({int flex = 1}) {
    return Flexible(child: this, flex: flex);
  }

  Expanded expanded([int flex = 1]) {
    return Expanded(flex: flex, child: this);
  }

  Widget centered({double? widthFactor, double? heightFactor}) {
    return Center(widthFactor: widthFactor, heightFactor: heightFactor, child: this);
  }

  InkWell inkWell({
    Key? key,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    void Function()? onSecondaryTap,
    void Function()? onLongPress,
    void Function(bool)? onHover,
    void Function(TapDownDetails)? onTapDown,
    void Function(TapUpDetails)? onTapUp,
    void Function()? onTapCancel,
    void Function(TapUpDetails)? onSecondaryTapUp,
    void Function(TapDownDetails)? onSecondaryTapDown,
    void Function()? onSecondaryTapCancel,
    void Function(bool)? onHighlightChanged,
    void Function(bool)? onFocusChange,
    Color? hoverColor,
    Color? focusColor,
    Color? highlightColor,
    Color? splashColor,
    WidgetStateProperty<Color?>? overlayColor,
    InteractiveInkFeatureFactory? splashFactory,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    MouseCursor? mouseCursor,
    bool? enableFeedback = true,
    bool excludeFromSemantics = false,
    FocusNode? focusNode,
    bool canRequestFocus = true,
    bool autofocus = false,
    WidgetStatesController? statesController,
    Duration? hoverDuration,
  }) {
    return InkWell(
      child: this,
      key: key,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onSecondaryTap: onSecondaryTap,
      onLongPress: onLongPress,
      hoverColor: hoverColor,
      radius: radius,
      borderRadius: borderRadius,
      customBorder: customBorder,
      enableFeedback: enableFeedback ?? true,
      onHover: onHover,
      highlightColor: highlightColor,
      overlayColor: overlayColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onSecondaryTapUp: onSecondaryTapUp,
      onSecondaryTapDown: onSecondaryTapDown,
      onSecondaryTapCancel: onSecondaryTapCancel,
      onHighlightChanged: onHighlightChanged,
      mouseCursor: mouseCursor,
      focusColor: focusColor,
      excludeFromSemantics: excludeFromSemantics,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      autofocus: autofocus,
      statesController: statesController,
      hoverDuration: hoverDuration,
    );
  }

  SelectionArea selectionArea() {
    return SelectionArea(child: this);
  }

  SelectionContainer noSelection() {
    return SelectionContainer.disabled(child: this);
  }

  Card carded(
      {Color? color,
      Color? shadowColor,
      double? elevation,
      ShapeBorder? shape,
      bool semanticContainer = true,
      bool borderOnForeground = true,
      EdgeInsetsGeometry? margin,
      Clip? clipBehavior}) {
    return Card(
        child: this,
        color: color,
        shadowColor: shadowColor,
        elevation: elevation,
        shape: shape,
        borderOnForeground: borderOnForeground,
        margin: margin,
        clipBehavior: clipBehavior,
        semanticContainer: semanticContainer);
  }

  Widget pullRefresh(RefreshCallback callback) {
    return RefreshIndicator(onRefresh: callback, child: this);
  }

  ClipRRect clipRoundRect([double radius = 4]) {
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);
  }

  ColoredBox coloredBox(Color color) {
    return ColoredBox(color: color, child: this);
  }

  ClipRect clipRect({Clip clipBehavior = Clip.hardEdge}) {
    return ClipRect(child: this, clipBehavior: clipBehavior);
  }

  DecoratedBox roundRect({double radius = 4, Color? borderColor, double bordeWidth = 1.0, Color? fillColor, BoxShadow? shadow}) {
    return this.boxDecorated(
      color: fillColor,
      boxShadow: shadow == null ? null : [shadow],
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      border: borderColor != null ? Border.all(color: borderColor, width: bordeWidth) : null,
    );
  }

  DecoratedBox underLine() {
    return this.decoratedBox(BoxDecoration(border: Border(bottom: BorderSide(color: globalTheme.hintColor))));
  }

  DecoratedBox boxDecorated({
    Color? color,
    BoxBorder? border,
    double? radiusAll,
    BoxShadow? shadow,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    DecorationImage? image,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape shape = BoxShape.rectangle,
  }) {
    BorderRadiusGeometry? br = borderRadius;
    if (br == null && radiusAll != null) {
      br = BorderRadius.all(Radius.circular(radiusAll));
    }
    return DecoratedBox(
        child: this,
        decoration: BoxDecoration(
          color: color,
          image: image,
          border: border,
          borderRadius: br,
          boxShadow: boxShadow ?? (shadow == null ? null : [shadow]),
          gradient: gradient,
          backgroundBlendMode: backgroundBlendMode,
          shape: shape,
        ));
  }

  Widget shapeLinear(
      {Color? fillColor, Color? borderColor, BorderSide? side, LinearBorderEdge? start, LinearBorderEdge? end, LinearBorderEdge? top, LinearBorderEdge? bottom}) {
    BorderSide? bs = side;
    if (bs == null && borderColor != null) {
      bs = BorderSide(color: borderColor);
    }
    return this.shapeDecorated(shape: LinearBorder(side: bs ?? BorderSide.none, start: start, end: end, top: top, bottom: bottom), color: fillColor);
  }

  Widget shapeRounded({Color? fillColor, Color? borderColor, BorderSide? side, double radius = 4}) {
    BorderSide? bs = side;
    if (bs == null && borderColor != null) {
      bs = BorderSide(color: borderColor);
    }
    return this.shapeDecorated(shape: RoundedRectangleBorder(side: bs ?? BorderSide.none, borderRadius: BorderRadius.circular(radius)), color: fillColor);
  }

  Widget shapeStadium({Color? fillColor, Color? borderColor, BorderSide? side}) {
    BorderSide? bs = side;
    if (bs == null && borderColor != null) {
      bs = BorderSide(color: borderColor);
    }
    return this.shapeDecorated(shape: StadiumBorder(side: bs ?? BorderSide.none), color: fillColor);
  }

  DecoratedBox shapeDecorated({required ShapeBorder shape, Color? color, DecorationImage? image, Gradient? gradient, List<BoxShadow>? shadows}) {
    return DecoratedBox(child: this, decoration: ShapeDecoration(shape: shape, color: color, image: image, gradient: gradient, shadows: shadows));
  }

  DecoratedBox decoratedBox(Decoration decoration) {
    return DecoratedBox(child: this, decoration: decoration);
  }

  Align alignCenter({double? widthFactor, double? heightFactor}) {
    return Align(child: this, widthFactor: widthFactor, heightFactor: heightFactor, alignment: Alignment.center);
  }

  Align align(Alignment alignment, {double? widthFactor, double? heightFactor}) {
    return Align(child: this, widthFactor: widthFactor, heightFactor: heightFactor, alignment: alignment);
  }

  Material material({
    MaterialType type = MaterialType.canvas,
    double elevation = 0.0,
    Color? color,
    Color? shadowColor,
    Color? surfaceTintColor,
    TextStyle? textStyle,
    BorderRadiusGeometry? borderRadius,
    ShapeBorder? shape,
    bool borderOnForeground = true,
    Clip clipBehavior = Clip.none,
  }) {
    //   ,   ,  ,   ,
    return Material(
        child: this,
        type: type,
        elevation: elevation,
        color: color,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        textStyle: textStyle,
        borderRadius: borderRadius,
        shape: shape,
        borderOnForeground: borderOnForeground,
        clipBehavior: clipBehavior);
  }

  DataWidget<D> dataWidget<D>(D data) {
    return DataWidget(child: this, data: data);
  }

  Widget labelText(String label) {
    return RowMin([label.titleMedium(), space(width: 8), this]);
  }
}
