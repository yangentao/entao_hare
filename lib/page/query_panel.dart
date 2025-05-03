part of '../fhare.dart';
//
// class QueryEdit extends HareWidget {
//   final List<String> textOpList = queryCondTextOperators;
//   final List<String> numOpList = queryCondNumberOperators;
//   TextEditingController controller = TextEditingController();
//   String? label;
//   void Function(String)? onSubmit;
//   void Function()? onClear;
//   String op = "=";
//   final bool opNumber;
//   TextInputFormatter? inputFormater;
//
//   QueryEdit({
//     this.label,
//     this.onSubmit,
//     this.onClear,
//     this.opNumber = false,
//     this.inputFormater,
//   });
//
//   String get value => controller.text;
//
//   set value(String newValue) {
//     controller.text = newValue;
//   }
//
//   List<DropdownMenuItem<String>> _makeDropList(List<String> items) {
//     return items
//         .map((e) => DropdownMenuItem<String>(
//               value: e,
//               child: Center(
//                   child: Text(
//                 e,
//                 style: TextStyle(fontSize: _itemFontSize(e)),
//               )),
//             ))
//         .toList();
//   }
//
//   double _itemFontSize(String e) {
//     if (e == "≠") return 22;
//     if (e.length == 1) return e.isAscii ? 22 : 18;
//     return e.isAscii ? 16 : 12;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       inputFormatters: inputFormater == null ? null : [inputFormater!],
//       decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: DropdownButtonFormField<String>(
//             value: op,
//             isExpanded: true,
//             iconSize: 0,
//             iconEnabledColor: Colors.transparent,
//             iconDisabledColor: Colors.transparent,
//             // style: TextStyle(fontSize: 13),
//             alignment: AlignmentDirectional.centerEnd,
//             items: _makeDropList(opNumber ? numOpList : textOpList),
//             onChanged: (e) {
//               op = e ?? "=";
//               updateState();
//             },
//             decoration: InputDecoration(border: InputBorder.none, enabledBorder: InputBorder.none),
//           ).sized(width: 42),
//           suffixIcon: IconButton(
//               onPressed: () {
//                 controller.clear();
//                 op = "=";
//                 updateState();
//                 if (onClear != null) {
//                   onClear!();
//                 }
//               },
//               icon: Icons.clear_rounded.icon(size: 16))),
//       onFieldSubmitted: onSubmit,
//     );
//   }
// }
//
// class QueryPanel extends HareWidget {
//   final List<Widget> _items = [];
//   final LinkedHashMap<String, QueryEdit> _textMap = LinkedHashMap();
//   final LinkedHashMap<String, HareDropdown> _dropdownMap = LinkedHashMap();
//   void Function() onQuery;
//   int _breakIndex = 0;
//   late final HareCheckbox _andCheckbox = HareCheckbox(true, onChanged: _doQuery);
//   late final Text _andText = Text(
//     "全部满足",
//     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//   );
//
//   QueryPanel({required this.onQuery});
//
//   bool get isAnd => _andCheckbox.value;
//
//   List<QueryCond> get condList {
//     List<QueryCond> ls = [];
//     for (var e in _textMap.entries) {
//       String v = e.value.value.trim();
//       ls << QueryCond(e.key, e.value.op, v);
//     }
//     for (var e in _dropdownMap.entries) {
//       String v = e.value.value?.trim() ?? "";
//       if (v.isNotEmpty) {
//         ls << QueryCond(e.key, "=", v);
//       }
//     }
//     return ls;
//   }
//
//   void _doQuery([Object? value]) {
//     onQuery();
//   }
//
//   void breakLine() {
//     _breakIndex = _items.length;
//   }
//
//   void dropdown(String field, List<StringPair<dynamic>> dropitems, {double? width = 0, String? value, String? hintText}) {
//     int maxLen = dropitems.isEmpty ? 0 : dropitems.reduce((a, b) => a.second.length > b.second.length ? a : b).second.length;
//     HareDropdown d = HareDropdown(
//       dropitems,
//       value: value,
//       onChanged: _doQuery,
//       hint: Text(hintText ?? "选择"),
//     );
//
//     if (width == 0) {
//       _items << d.padded(Edges.only(left: 16)).sized(width: maxLen * 16 + 50);
//     } else if (width != null && width > 0) {
//       _items << d.padded(Edges.only(left: 16)).sized(width: width);
//     } else {
//       _items << d.padded(Edges.only(left: 16)).expanded();
//     }
//     _dropdownMap[field] = d;
//   }
//
//   RegExp _makeNumReg(bool signal, bool decimal) {
//     if (signal && decimal) {
//       return RegExp(r'[0-9.+-]');
//     }
//     if (signal) {
//       return RegExp(r'[0-9+-]');
//     }
//     if (decimal) {
//       return RegExp(r'[0-9.]');
//     }
//     return RegExp(r'[0-9]');
//   }
//
//   void phone(String field, String label, {double width = -1}) {
//     QueryEdit ed = QueryEdit(
//       label: label,
//       onSubmit: _doQuery,
//       onClear: _doQuery,
//       opNumber: false,
//       inputFormater: FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//     );
//     if (width == 0) {
//       _items << ed.padded(Edges.only(left: 16)).sized(width: 240);
//     } else if (width > 0) {
//       _items << ed.padded(Edges.only(left: 16)).sized(width: width);
//     } else {
//       _items << ed.padded(Edges.only(left: 16)).expanded();
//     }
//     _textMap[field] = ed;
//   }
//
//   void number(String field, String label, {double width = 0, bool signal = false, bool decimal = false}) {
//     QueryEdit ed = QueryEdit(
//       label: label,
//       onSubmit: _doQuery,
//       onClear: _doQuery,
//       opNumber: true,
//       inputFormater: FilteringTextInputFormatter.allow(_makeNumReg(signal, decimal)),
//     );
//     if (width > 0) {
//       _items << ed.padded(Edges.only(left: 16)).sized(width: width);
//     } else {
//       _items << ed.padded(Edges.only(left: 16)).expanded();
//     }
//     _textMap[field] = ed;
//   }
//
//   void text(String field, String label, {double width = 0}) {
//     QueryEdit ed = QueryEdit(
//       label: label,
//       onSubmit: _doQuery,
//       onClear: _doQuery,
//       opNumber: false,
//     );
//     if (width > 0) {
//       _items << ed.padded(Edges.only(left: 16)).sized(width: width);
//     } else {
//       _items << ed.padded(Edges.only(left: 16)).expanded();
//     }
//     _textMap[field] = ed;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_breakIndex > 0 && _breakIndex < _items.length) {
//       return Column(
//         children: [
//           Row(
//             children: [_andCheckbox, _andText, ..._items.sublist(0, _breakIndex)],
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 width: 88,
//               ),
//               ..._items.sublist(_breakIndex)
//             ],
//           )
//         ],
//       ).padded(edges(24, 10, 24, 10));
//     }
//     return Row(
//       children: [_andCheckbox, _andText, ..._items],
//     ).padded(edges(24, 10, 24, 10));
//   }
// }
