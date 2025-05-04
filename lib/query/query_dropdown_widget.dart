// ignore_for_file: must_be_immutable
part of '../entao_hare.dart';

class DropdownQueryWidget extends QueryWidget {
  final IntOptions options;
  late QueryOperatorWidget operatorDropdown = QueryOperatorWidget.number((e) => _fireChanged());
  final String field;
  final String label;
  final String? emptyText;
  final FocusNode focusNode = FocusNode();
  int? value;

  DropdownQueryWidget(this.field, this.options, {required this.label, this.value, this.emptyText, QueryConditionChange? onChange}) : super() {
    onConditionChange = onChange;
  }

  QueryOperator get currentOperator => operatorDropdown.currentOperator;

  @override
  QueryCondition? condition() {
    if (value == null) return null;
    return SingleCondition(op: currentOperator, field: field, params: [value]);
  }

  void _fireChanged() {
    updateState();
    onConditionChange?.call(condition());
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      focusNode: focusNode,
      value: value,
      enableFeedback: false,
      focusColor: Colors.transparent,
      itemHeight: kMinInteractiveDimension,
      items: options.dropdownItems(),
      //.items.entries.mapList((e) => DropdownMenuItem<int>(value: e.key, child: e.value.text())),
      selectedItemBuilder: (c) => options.entries(true).mapList((e) => e.value.text()),
      icon: Icons.arrow_drop_down_outlined.icon(),
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: operatorDropdown,
          suffixIcon: IconButton(
              onPressed: () {
                value = null;
                operatorDropdown.clear();
                focusNode.unfocus();
                _fireChanged();
              },
              icon: Icons.clear_outlined.icon(size: 16))),
      onChanged: (e) {
        value = e;
        // focusNode.unfocus();
        _fireChanged();
        delayMills(100, () => focusNode.unfocus());
      },
    );
  }
}
