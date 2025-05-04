part of 'binders.dart';

SegmentedButton<T> SegmentsBindSingle<T>(Binder<T?> binder, {Key? key, required List<LabelValue<T>> items, bool allowEmpty = true}) {
  return SegmentedButton<T>(
      key: key,
      multiSelectionEnabled: false,
      emptySelectionAllowed: allowEmpty,
      style: SegStyle,
      segments: items.mapList((e) => ButtonSegment(value: e.value, label: e.label.text())),
      selected: binder.value == null ? {} : {binder.value as T},
      showSelectedIcon: false,
      selectedIcon: null,
      onSelectionChanged: (vset) {
        binder.value = vset.firstOrNull;
        binder.fireUpdateUI();
        binder.fireChanged();
      });
}

SegmentedButton<T> SegmentsBind<T>(Binder<Set<T>> binder, {Key? key, required List<LabelValue<T>> items, bool multi = false, bool allowEmpty = true}) {
  return SegmentedButton<T>(
      key: key,
      multiSelectionEnabled: multi,
      emptySelectionAllowed: allowEmpty,
      style: SegStyle,
      segments: items.mapList((e) => ButtonSegment(value: e.value, label: e.label.text())),
      selected: binder.value,
      showSelectedIcon: false,
      selectedIcon: null,
      onSelectionChanged: (vset) {
        binder.value = vset;
        binder.fireUpdateUI();
        binder.fireChanged();
      });
}

@Deprecated("Use SegmentsBind instead.")
SegmentedButton<T> SegmentsRadioB<T>(Binder<T?> binder,
    {Key? key, required List<ButtonSegment<T>> segments, bool emptySelectionAllowed = true, ButtonStyle? style, bool showSelectedIcon = false, Widget? selectedIcon}) {
  return SegmentedButton<T>(
      key: key,
      multiSelectionEnabled: false,
      emptySelectionAllowed: emptySelectionAllowed,
      style: style ?? SegStyle,
      segments: segments,
      selected: binder.value == null ? {} : {binder.value as T},
      showSelectedIcon: showSelectedIcon,
      selectedIcon: selectedIcon,
      onSelectionChanged: (vset) {
        binder.value = vset.firstOrNull;
        binder.fireUpdateUI();
        binder.fireChanged();
      });
}

@Deprecated("Use SegmentsBind instead.")
SegmentedButton<T> SegmentsCheckB<T>(Binder<Set<T>> binder,
    {Key? key, required List<ButtonSegment<T>> segments, bool emptySelectionAllowed = true, ButtonStyle? style, bool showSelectedIcon = false, Widget? selectedIcon}) {
  return SegmentedButton<T>(
      key: key,
      multiSelectionEnabled: true,
      emptySelectionAllowed: emptySelectionAllowed,
      style: style ?? SegStyle,
      segments: segments,
      selected: binder.value,
      showSelectedIcon: showSelectedIcon,
      selectedIcon: selectedIcon,
      onSelectionChanged: (vset) {
        binder.value = vset;
        binder.fireUpdateUI();
        binder.fireChanged();
      });
}

@Deprecated("Use SegmentsBind instead.")
SegmentedButton<int> SegmentsBitsB(
  Binder<int> binder, {
  Key? key,
  required List<ButtonSegment<int>> segments,
  bool emptySelectionAllowed = true,
  ButtonStyle? style,
  bool showSelectedIcon = false,
  Widget? selectedIcon,
}) {
  Set<int> itemSet = segments.map((ne) => ne.value).toSet();
  Set<int> selectedSet = itemSet.where((int e) => binder.value.hasAllBit(e)).toSet();
  return SegmentedButton<int>(
      key: key,
      multiSelectionEnabled: true,
      emptySelectionAllowed: emptySelectionAllowed,
      style: style ?? SegStyle,
      segments: segments,
      selected: selectedSet,
      showSelectedIcon: showSelectedIcon,
      selectedIcon: selectedIcon,
      onSelectionChanged: (vset) {
        binder.value = vset.joinBits();
        binder.fireUpdateUI();
        binder.fireChanged();
      });
}
