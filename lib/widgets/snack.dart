

part of 'widgets.dart';


const Duration _snackBarDisplayDuration = Duration(milliseconds: 4000);

extension HareWidgetExts on HareWidget {
  void showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnack({
    String? message,
    Color? textColor,
    Color? actionTextColor,
    Color? acitonBackgroundColor,
    Color? actionDisabledTextColor,
    Color? actionDisabledBackgroundColor,
    String? actionLabel,
    void Function()? onAction,
    Widget? content,
    Color? backgroundColor,
    double? elevation,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? width,
    ShapeBorder? shape,
    HitTestBehavior? hitTestBehavior,
    SnackBarBehavior? behavior,
    SnackBarAction? action,
    double? actionOverflowThreshold,
    bool? showCloseIcon,
    Color? closeIconColor,
    Duration duration = _snackBarDisplayDuration,
    Animation<double>? animation,
    void Function()? onVisible,
    DismissDirection dismissDirection = DismissDirection.down,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    assert(message != null || content != null);

    SnackBarAction? ac = action;
    if (ac == null && actionLabel != null && onAction != null) {
      ac = SnackBarAction(
        label: actionLabel,
        onPressed: onAction,
        textColor: actionTextColor,
        backgroundColor: acitonBackgroundColor,
        disabledTextColor: actionDisabledTextColor,
        disabledBackgroundColor: actionDisabledBackgroundColor,
      );
    }

    SnackBar snackBar = SnackBar(
      content: content ?? message!.text(color: textColor),
      backgroundColor: backgroundColor,
      elevation: elevation,
      margin: margin,
      padding: padding,
      width: width,
      shape: shape,
      hitTestBehavior: hitTestBehavior,
      behavior: behavior,
      action: ac,
      actionOverflowThreshold: actionOverflowThreshold,
      showCloseIcon: showCloseIcon,
      closeIconColor: closeIconColor,
      duration: duration,
      animation: animation,
      onVisible: onVisible,
      dismissDirection: dismissDirection,
      clipBehavior: clipBehavior,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
