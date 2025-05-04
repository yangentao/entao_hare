// ignore_for_file: must_be_immutable
import 'dart:async';

import 'package:entao_dutil/entao_dutil.dart';
import 'package:flutter/material.dart';

import '../basic/basic.dart';
import '../dialog/dialog.dart';
import '../harewidget/harewidget.dart';
import '../widgets/widgets.dart';

// enum LayoutStyle { list, wrap, grid }

Future<T?> showSearchDialog<T>({
  required Future<List<T>> Function(String input) onItems,
  Widget Function(T item)? onItemView,
  String? searchText,
  Widget? title,
}) async {
  var w = _SearchWidget<T>(onItems: onItems, onItemView: onItemView, searchText: searchText);
  return w.show(title: title);
}

class _SearchWidget<T> extends HareWidget {
  Future<List<T>> Function(String input) onItems;
  late Widget Function(T item) _onItemView;
  late HareEdit _edit;
  List<T> _items = [];
  FocusNode focusNode = FocusNode();

  _SearchWidget({required this.onItems, Widget Function(T item)? onItemView, String? searchText}) : super() {
    _onItemView = onItemView ?? _listItemView;
    _edit = HareEdit(
      autofucus: true,
      focusNode: focusNode,
      value: searchText ?? "",
      onSubmit: (s) async {
        await _queryItems();
        updateState();
        focusNode.requestFocus();
      },
      onClear: () async {
        await _queryItems();
        updateState();
      },
    );
  }

  Future<void> _queryItems() async {
    _items = await onItems(_edit.value);
    if (_items.isEmpty && _edit.value.isNotEmpty) {
      _items = await onItems("");
    }
  }

  Future<T?> show({Widget? title}) async {
    await _queryItems();
    return await showDialogX((b) {
      b.title(title);
      return b.buildColumn([this]);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> ws = _items.mapList((e) => _onItemView.call(e));
    return ColumnMin([
      _edit.padded(xy(16)),
      space(height: 8),
      ...ws,
      space(height: 8),
    ]).padded(xy(0, 0));
  }

  Widget _listItemView(T item) {
    return ListTile(
      title: item.toString().text(),
      onTap: () {
        dialogs.pop(item);
      },
    );
  }
}
