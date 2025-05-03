part of '../fhare.dart';

class TreePath<T> extends HareWidget {
  final List<T> _paths = [];
  final OnLabel<T> _onLabel;
  final FutureOr<List<T>> Function(T item) _onChildren;
  final FutureOr<List<T>> Function(T item) _onSiblings;
  final OnValue<List<T>>? _onChanged;
  final bool _cached;
  final Map<T, List<T>> _childMap = {};
  final Map<T, List<T>> _siblingMap = {};

  TreePath(
      {required T root,
      required String Function(T) onLabel,
      required FutureOr<List<T>> Function(T) onSiblings,
      required FutureOr<List<T>> Function(T) onChildren,
      void Function(List<T>)? onChanged,
      bool cache = true})
      : _onChanged = onChanged,
        _onSiblings = onSiblings,
        _onChildren = onChildren,
        _onLabel = onLabel,
        _cached = cache,
        super() {
    _paths.add(root);
  }

  void _fireChanged() {
    _onChanged?.call(_paths);
  }

  Future<void> _tapItem(int idx, T e) async {
    if (idx >= 0) {
      _paths.removeRange(idx + 1, _paths.length);
      updateState();
      _fireChanged();
    }
  }

  Future<List<T>> _sibOf(T item) async {
    if (_cached) {
      if (_siblingMap.containsKey(item)) {
        return _siblingMap[item] ?? [];
      }
    }
    FutureOr<List<T>> ch = _onSiblings(item);
    List<T> sibList;
    if (ch is Future<List<T>>) {
      sibList = await ch;
    } else {
      sibList = ch;
    }
    if (_cached) {
      _siblingMap[item] = sibList;
    }
    return sibList;
  }

  Future<void> _siblings(int idx, T item) async {
    List<T> sibList = await _sibOf(item);
    if (sibList.isEmpty) return;
    if (sibList.length == 1 && sibList.first == item) return;
    T? v = await dialogs.pickValue(sibList, onTitle: (a) => _onLabel(a).text());
    if (v != null) {
      _paths.removeRange(idx, _paths.length);
      _paths.add(v);
      updateState();
      _fireChanged();
    }
  }

  Future<List<T>> _childListOf(T item) async {
    if (_cached) {
      if (_childMap.containsKey(item)) {
        return _childMap[item] ?? [];
      }
    }
    FutureOr<List<T>> ch = _onChildren(item);
    List<T> chList;
    if (ch is Future<List<T>>) {
      chList = await ch;
    } else {
      chList = ch;
    }
    if (_cached) {
      _childMap[item] = chList;
    }
    return chList;
  }

  Future<void> _children() async {
    List<T> chList = await _childListOf(_paths.last);
    if (chList.isEmpty) return;
    if (chList.length == 1) {
      _paths.add(chList.last);
      updateState();
      _fireChanged();
    } else {
      T? v = await dialogs.pickValue(chList, onTitle: (a) => _onLabel(a).text());
      if (v != null) {
        _paths.add(v);
        updateState();
        _fireChanged();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> ls = _paths.mapIndex((idx, item) {
      return RawChip(
        label: _onLabel(item).text().paddings(right: 16),
        selected: idx == _paths.length - 1,
        selectedColor: Colors.blueAccent,
        showCheckmark: false,
        deleteButtonTooltipMessage: "选择",
        deleteIcon: Icons.arrow_drop_down.icon(size: 24),
        onDeleted: () {
          _siblings(idx, item);
        },
        onPressed: () {
          _tapItem(idx, item);
        },
      );
    });
    var last = RawChip(
      label: Icons.arrow_right.icon(),
      selected: false,
      selectedColor: Colors.blueAccent,
      showCheckmark: false,
      onPressed: _children,
    );
    ls.add(last);
    return WrapRow(ls);
  }
}
