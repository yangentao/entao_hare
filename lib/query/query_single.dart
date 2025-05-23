// ignore_for_file: must_be_immutable
part of 'query.dart';

class SingleSelectQueryWidget<T> extends HareWidget with WithCondition {
  final List<LabelValue<T>> items = [];
  final String label;
  final String? clearText;
  final String field;
  LabelValue<T>? selectedItem;

  SingleSelectQueryWidget(this.field, List<LabelValue<T>> items, {required this.label, this.clearText = "清除"}) : super() {
    if (items.isNotEmpty && clearText != null) {
      this.items.add(LabelValue<T>(clearText!, items.first.value));
    }
    this.items.addAll(items);
  }

  @override
  Widget build(BuildContext context) {
    String lb = selectedItem?.label ?? label;
    var w = lb.rawChip(); //RawChip(label: lb.text(), padding: xy(4, 4), elevation: 3);
    return w.popLabelValues(
        items: items,
        initialValue: selectedItem,
        callback: (e) {
          if (e.label == clearText) {
            selectedItem = null;
          } else {
            selectedItem = e;
          }
          updateState();
          onConditionChange?.call(condition());
        });
  }

  @override
  QueryCond? condition() {
    var item = selectedItem;
    if (item == null) return null;
    return FieldCond(op: QueryOp.eq, field: field, values: [item.value]);
  }
}
