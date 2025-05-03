// ignore_for_file: must_be_immutable
part of 'harewidget.dart';

class HareBuilder extends HareWidget {
  late Widget Function(BuildContext context) builder;

  HareBuilder([Widget Function(BuildContext context)? builder]) : super() {
    if (builder != null) {
      this.builder = builder;
    }
  }

  @override
  Widget build(BuildContext context) {
    return builder.call(context);
  }
}

class HareSingle extends HareWidget {
  final Widget child;

  HareSingle(this.child) : super();

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

extension BridgedWidgetExt on HareWidget {
  void unfocus() {
    FocusScope.of(this.context).unfocus();
  }

  MediaQueryData get mediaData => MediaQuery.of(context);

  ThemeData get themeData => Theme.of(context);

  TextTheme get textStyle => Theme.of(context).textTheme;
}
