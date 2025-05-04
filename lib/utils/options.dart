part of '../entao_hare.dart';

class StringOptions {
  List<String> items;

  StringOptions({required this.items});

  List<LabelValue<String>> options() {
    return items.mapList((e) => LabelValue(e, e));
  }
}

class IntOptions {
  final Map<int, String> items;
  final bool bitOperator;
  final String missLabel;
  final Set<int> hiddenSet;

  IntOptions(this.items, {
    List<int>? hiddenValues,
    this.bitOperator = false,
    this.missLabel = "未指定",
  }) : hiddenSet = hiddenValues?.toSet() ?? <int>{};

  static int joinBits(Set<int> intSet) {
    return intSet.joinBits();
  }

  List<int> toBits(int value) {
    List<int> ls = [];
    for (int b in items.keys) {
      if (value & b == b) ls.add(b);
    }
    return ls;
  }

  List<MapEntry<int, String>> entries([bool visiableOnly = true]) {
    if (visiableOnly) {
      return items.entries.exclude((e) => hiddenSet.contains(e.key));
    }
    return items.entries.toList();
  }

  List<int> values({bool visiableOnly = true}) => entries(visiableOnly).mapList((e) => e.key);

  List<LabelValue<int>> options({bool visiableOnly = true}) => entries(visiableOnly).mapList((e) => LabelValue(e.value, e.key));

  List<PopupMenuItem<int>> menuItems({bool visiableOnly = true}) => entries(visiableOnly).mapList((e) => toMenuItem(e.key));

  List<DropdownMenuItem<int>> dropdownItems({bool visiableOnly = true}) => entries(visiableOnly).mapList((e) => DropdownMenuItem<int>(value: e.key, child: e.value.text()));

  List<ButtonSegment<int>> segmentItems({bool visiableOnly = true, double paddingX = 8}) => entries(visiableOnly).mapList((e) => ButtonSegment<int>(value: e.key, label: e.value.text().paddings(hor: paddingX)));

  DropdownMenuItem<int> toDropdownItem(int value) => DropdownMenuItem<int>(value: value, child: toWidget(value));

  PopupMenuItem<int> toMenuItem(int value) {
    return PopupMenuItem<int>(value: value, child: toWidget(value));
  }

  Widget toWidgetOr(int? value, String? emptyText) => toLabelOr(value, emptyText).text();

  Widget toWidget(int? value) => toLabel(value).text();

  String toLabel(int? value) {
    return toLabelOr(value, null);
  }

  String toLabelOr(int? value, String? emptyText) {
    if (value == null || !bitOperator) {
      return items[value] ?? emptyText ?? missLabel;
    }
    List<String> ls = [];
    for (var e in items.entries) {
      if (e.key & value != 0) ls.add(e.value);
    }
    if (ls.isEmpty) return emptyText ?? missLabel;
    return ls.join(",");
  }
}
