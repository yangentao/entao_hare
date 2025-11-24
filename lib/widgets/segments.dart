// ignore_for_file: must_be_immutable
part of 'widgets.dart';

class HareSegments<V> extends HareWidget {
  final bool multi;
  final bool allowEmpty;
  final List<LabelValue<V>> items;
  final Set<V> selected = {};
  final VoidCallback? onChanged;

  HareSegments({required this.items, this.multi = false, this.allowEmpty = false, Set<V>? selected, this.onChanged}) : super() {
    if (selected != null) {
      this.selected.addAll(selected);
    }
    if (!allowEmpty && this.selected.isEmpty) {
      this.selected.add(this.items.first.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<V>(
        showSelectedIcon: false,
        multiSelectionEnabled: multi,
        emptySelectionAllowed: allowEmpty,
        style: SegStyle,
        segments: items.mapList((e) => ButtonSegment<V>(value: e.value, label: e.label.text())),
        selected: selected,
        onSelectionChanged: (newSelection) {
          selected.clear();
          selected.addAll(newSelection);
          updateState();
          onChanged?.call();
        });
  }
}

enum LabelPosition { none, leftCenter, topLeft, topCenter, bottomCenter }

abstract class AbstractSegments<V> extends HareWidget {
  List<V> items;
  Widget? label;
  LabelPosition labelPosition;
  bool spaceBetween;
  Widget Function(V value) toButtonLabel;

  AbstractSegments({
    required this.items,
    required this.toButtonLabel,
    required this.label,
    required this.labelPosition,
    required this.spaceBetween,
  })  : assert(items.isNotEmpty),
        super();

  SegmentedButton _make();

  @override
  Widget build(BuildContext context) {
    if (label == null || labelPosition == LabelPosition.none) {
      return _make();
    }
    switch (labelPosition) {
      case LabelPosition.leftCenter:
        if (spaceBetween) {
          return RowMax([label!, _make()], mainAxisAlignment: MainAxisAlignment.spaceBetween);
        } else {
          return RowMin([label!, _make()]);
        }
      case LabelPosition.topCenter:
        return ColumnMin([label!, _make()], mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center);
      case LabelPosition.bottomCenter:
        return ColumnMin([_make(), label!], mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center);

      case LabelPosition.topLeft:
        return ColumnMin([label!, _make()], mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch);
      default:
        raise("Bad Label Position");
    }
  }
}

class SegmentCheck<V> extends AbstractSegments<V> {
  bool multiCheck;
  bool allowEmpty;
  Set<V> checkedValues;

  void Function(Set<V> checkedItems)? onChange;

  SegmentCheck({
    required super.items,
    required super.toButtonLabel,
    required this.checkedValues,
    this.multiCheck = true,
    this.allowEmpty = true,
    super.label,
    super.spaceBetween = true,
    super.labelPosition = LabelPosition.leftCenter,
    this.onChange,
  })  : assert(items.isNotEmpty),
        super();

  void _onChanged() {
    updateState();
    this.onChange?.call(checkedValues);
  }

  @override
  SegmentedButton _make() {
    if (!allowEmpty) {
      if (checkedValues.isEmpty) {
        checkedValues.add(items.first);
      }
    }
    return SegmentedButton<V>(
        multiSelectionEnabled: multiCheck,
        emptySelectionAllowed: allowEmpty,
        style: SegStyle,
        segments: items.mapList((e) => ButtonSegment<V>(value: e, label: toButtonLabel(e))),
        selected: checkedValues,
        onSelectionChanged: (newSelection) {
          checkedValues = newSelection;
          _onChanged();
        });
  }
}

class SegmentRadio<V> extends AbstractSegments<V> {
  V? checkedValue;
  bool allowEmpty;
  void Function(V? selectedItem)? onChange;

  SegmentRadio({
    required super.items,
    required super.toButtonLabel,
    this.checkedValue,
    this.allowEmpty = true,
    super.label,
    super.spaceBetween = true,
    super.labelPosition = LabelPosition.leftCenter,
    this.onChange,
  })  : assert(items.isNotEmpty),
        super();

  void _onChanged() {
    updateState();
    this.onChange?.call(checkedValue);
  }

  @override
  SegmentedButton _make() {
    if (!allowEmpty) {
      checkedValue ??= items.first;
    }
    return SegmentedButton<V>(
        multiSelectionEnabled: false,
        emptySelectionAllowed: allowEmpty,
        showSelectedIcon: false,
        style: SegStyle,
        segments: items.mapList((e) => ButtonSegment<V>(value: e, label: toButtonLabel(e))),
        selected: checkedValue == null ? {} : {checkedValue as V},
        onSelectionChanged: (newSelection) {
          checkedValue = newSelection.firstOrNull;
          _onChanged();
        });
  }
}

class SegmentBits extends AbstractSegments<int> {
  int checkedValue;
  bool allowEmpty;
  void Function(int? selectedItem)? onChange;

  SegmentBits({
    required super.items,
    required super.toButtonLabel,
    this.checkedValue = 0,
    this.allowEmpty = true,
    super.label,
    super.spaceBetween = true,
    super.labelPosition = LabelPosition.leftCenter,
    this.onChange,
  })  : assert(items.isNotEmpty),
        super();

  void _onChanged() {
    updateState();
    onChange?.call(checkedValue);
  }

  @override
  SegmentedButton _make() {
    return SegmentedButton<int>(
        multiSelectionEnabled: true,
        emptySelectionAllowed: allowEmpty,
        showSelectedIcon: false,
        style: SegStyle,
        segments: items.mapList((e) => ButtonSegment<int>(value: e, label: toButtonLabel(e))),
        selected: _checkedSet,
        onSelectionChanged: (newSelection) {
          checkedValue = _selectionToCheckBits(newSelection);
          _onChanged();
        });
  }

  int _selectionToCheckBits(Set<int> selectionSet) {
    int result = 0;
    for (int item in selectionSet) {
      result = result | item;
    }
    return result;
  }

  Set<int> get _checkedSet {
    Set<int> ls = {};
    for (int item in items) {
      if (item & checkedValue != 0) ls.add(item);
    }
    return ls;
  }
}
