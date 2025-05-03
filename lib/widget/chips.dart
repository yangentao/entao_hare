part of '../fhare.dart';

class ChipChoiceGroup<T> extends HareWidget {
  final List<LabelValue<T>> items;
  final Set<T> selected = {};
  final Color? selectedColor;
  final bool allowEmpty;
  final bool multiSelect;
  final void Function(Set<T> selectedItems)? onChange;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final WrapCrossAlignment crossAxisAlignment;

  // static Color selectedColorDefault = Colors.deepOrangeAccent;
  static Color selectedColorDefault = Colors.lightBlueAccent;

  ChipChoiceGroup({
    required this.items,
    Set<T>? selected,
    Color? selectedColor,
    this.allowEmpty = true,
    this.multiSelect = false,
    this.onChange,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.center,
    this.crossAxisAlignment = WrapCrossAlignment.center,
  })  : selectedColor = selectedColor ?? selectedColorDefault,
        super() {
    if (selected != null) this.selected.addAll(selected);
    if (!allowEmpty && this.selected.isEmpty) error("allowEmpty=false, but selected is empty.");
  }

  bool _contains(T value) => selected.contains(value);

  void _add(T value) {
    if (!multiSelect) selected.clear();
    selected.add(value);
    onChange?.call(selected);
  }

  void _remove(T value) {
    if (!allowEmpty && selected.length == 1 && selected.first == value) return;
    selected.remove(value);
    onChange?.call(selected);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> wList = items.mapList(
      (e) => ChoiceChip(
        selectedColor: selectedColor,
        label: e.label.text(),
        selected: _contains(e.value),
        elevation: 3,
        onSelected: (b) {
          if (b) {
            _add(e.value);
          } else {
            _remove(e.value);
          }
          updateState();
        },
      ).constrainedBox(minWidth: 64),
    );

    return Wrap(spacing: 8, runSpacing: 8, alignment: alignment, runAlignment: runAlignment, crossAxisAlignment: crossAxisAlignment, children: wList);
  }
}
