// ignore_for_file: must_be_immutable
part of 'pages.dart';

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

abstract class ColumnPageX extends HarePage with RefreshMixin {
  EdgeInsets? padding;

  ColumnPageX() : super();

  List<Widget> buildWidgets(BuildContext context);

  List<Widget> aboveWidgets(BuildContext context) {
    return [];
  }

  List<Widget> belowWidgets(BuildContext context) {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    Widget body = ColumnMaxStretch(buildWidgets(context));
    body = decorateBody(body);
    var ls1 = aboveWidgets(context);
    var ls2 = belowWidgets(context);
    if (ls1.isEmpty && ls2.isEmpty) return body.verticalScroll();
    return ColumnMaxStretch([...ls1, body.verticalScroll().expanded(), ...ls2]);
  }

  Widget decorateBody(Widget body) {
    var pd = padding;
    return pd == null ? body : body.padded(pd);
  }
}
