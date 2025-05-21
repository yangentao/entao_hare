// ignore_for_file: must_be_immutable
part of 'query.dart';

class SegmentQueryWidget<T> extends HareWidget with WithCondition {
  final List<LabelValue<T>> items = [];
  final String field;
  final bool multi;
  final bool bitOperator;
  Set<T> selectedItems = {};

  SegmentQueryWidget(
    this.field,
    List<LabelValue<T>> items, {
    required this.multi,
    this.bitOperator = false,
    Set<T>? selectedItems,
  }) : super() {
    this.items.addAll(items);
    if (selectedItems != null) this.selectedItems.addAll(selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
        multiSelectionEnabled: multi,
        emptySelectionAllowed: true,
        showSelectedIcon: false,
        style: SegStyle,
        segments: items.mapList((e) => ButtonSegment<T>(value: e.value, label: e.label.text())),
        selected: selectedItems,
        onSelectionChanged: (newSelection) {
          selectedItems = newSelection;
          updateState();
          onConditionChange?.call(condition());
        });
  }

  @override
  QueryCond? condition() {
    var set = selectedItems;
    if (set.isEmpty) return null;
    if (bitOperator && T == int) {
      List<int> ns = set.toList().castTo();
      int a = ns.reduce((value, element) => value | element);
      return FieldCond(field: field, values: [a], op: QueryOp.bit);
    }
    return FieldCond(op: QueryOp.inset, field: field, values: selectedItems.toList());
  }
}
