part of '../entao_hare.dart';

abstract class ColumnPage extends HarePage {
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.stretch;
  EdgeInsets? padding;

  ColumnPage() : super();

  List<Widget> buildWidgets(BuildContext context);

  @override
  Widget build(BuildContext context) {
    Widget w = ColumnMax(buildWidgets(context), mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment);
    return onDecorate(w).verticalScroll();
  }

  Widget onDecorate(Widget widget) {
    var pd = padding;
    return pd == null ? widget : widget.padded(pd);
  }
}
