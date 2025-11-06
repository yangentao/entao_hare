part of 'harewidget.dart';

class TextAction extends HareWidget {
  Widget child;
  VoidCallback? onTap;

  // ignore: use_key_in_widget_constructors
  TextAction({String? title, Widget? child, this.onTap}) : assert(child != null || title != null), child = child ?? title!.text();

  void update({String? title, Widget? child}) {
    Widget? w = child ?? title?.text();
    if (w != null) {
      this.child = w;
    }
    updateState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: DefaultTextStyle(
        textAlign: TextAlign.center,
        style: context.themeData.textTheme.titleSmall!.copyWith(color: context.themeData.colorScheme.onPrimary),
        child: child,
      ),
      onPressed: onTap,
    );
  }
}
