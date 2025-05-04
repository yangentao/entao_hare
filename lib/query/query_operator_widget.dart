// ignore_for_file: must_be_immutable
part of 'query.dart';

const List<String> _bigFonts = ["≠", "≥", "≤"];

//setOf("eq", "ne", "ge", "le", "gt", "lt",  "nul", "start", "end", "contain", "in")
class QueryOperatorWidget extends HareWidget {
  final List<QueryOperator> opList;
  void Function(QueryOperator e) onChange;
  late QueryOperator currentOperator = opList.first;

  QueryOperatorWidget(this.opList, this.onChange)
      : assert(opList.isNotEmpty),
        super();

  QueryOperatorWidget.number(this.onChange)
      : opList = numConditionOperators,
        super();

  QueryOperatorWidget.text(this.onChange)
      : opList = textConditionOperators,
        super();

  void clear() {
    currentOperator = opList.first;
    updateState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<QueryOperator>(
      value: currentOperator,
      isExpanded: true,
      focusColor: Colors.transparent,
      iconSize: 0,
      iconEnabledColor: Colors.transparent,
      iconDisabledColor: Colors.transparent,
      alignment: AlignmentDirectional.centerEnd,
      items: _makeDropList(opList),
      onChanged: (e) {
        currentOperator = e ?? opList.first;
        updateState();
        if (e != null) onChange(e);
      },
      decoration: InputDecoration(border: InputBorder.none, enabledBorder: InputBorder.none),
    ).sizedBox(width: 42);
  }

  List<DropdownMenuItem<QueryOperator>> _makeDropList(List<QueryOperator> items) {
    return items.mapList((e) => DropdownMenuItem<QueryOperator>(
          value: e,
          child: e.label.text(style: TextStyle(fontSize: _itemFontSize(e.label), color: Colors.lightBlue)).centered(),
        ));
  }

  double _itemFontSize(String e) {
    if (_bigFonts.contains(e)) return 22;
    if (e.length == 1) return e.isAscii ? 22 : 18;
    return e.isAscii ? 16 : 12;
  }
}
