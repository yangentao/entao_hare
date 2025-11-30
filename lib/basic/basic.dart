library;

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:entao_dutil/entao_dutil.dart';
import 'package:entao_hare/entao_hare.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:println/println.dart';

part 'ScrollLoading.dart';
part 'XGridDelegate.dart';
part 'XGridView.dart';
part 'XListView.dart';
part 'actions.dart';
part 'bits.dart';
part 'buttons.dart';
part 'chain.dart';
part 'compose.dart';
part 'context.dart';
part 'data_widget.dart';
part 'define.dart';
part 'dimension.dart';
part 'XGridTile.dart';
part 'hare_layout.dart';
part 'loading.dart';
part 'options.dart';
part 'overlay.dart';
part 'scroll.dart';
part 'tags.dart';
part 'text_ext.dart';
part 'toast.dart';
part 'utils/Dirs.dart';
part "utils/TipMessage.dart";
part 'utils/plat.dart';
part 'utils/validator.dart';
part 'value_listener.dart';

extension IntMinMaxExt on int {
  static const int minValue = (kIsWasm || kIsWeb) ? -9007199254740992 : -9223372036854775808;

  static const int maxValue = (kIsWasm || kIsWeb) ? 9007199254740991 : 9223372036854775807;
}

Builder builderWidget(WidgetBuilder b, {Key? key}) {
  return Builder(builder: b, key: key);
}

final IconData MORE_ICON = Icons.adaptive.more_rounded;
final Icon moreArrow = Icons.keyboard_arrow_right.icon();

void setClipboardText(String text) {
  Clipboard.setData(ClipboardData(text: text));
}

Future<String?> getClipboardText() async {
  ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
  return data?.text;
}

extension TimeOfDayFormatEx on TimeOfDay {
  String get formatTime => "${hour.formated("00")}:${minute.formated("00")}-00";

  String get formatTime2 => "${hour.formated("00")}:${minute.formated("00")}";
}

const Color primaryColor = Color(0xFFF44336);

ButtonStyle get elevatedButtonStyle => ElevatedButton.styleFrom(backgroundColor: primaryColor, elevation: 8, minimumSize: const Size(100, 44));

ButtonStyle get elevatedButtonStyleLarge => ElevatedButton.styleFrom(backgroundColor: primaryColor, elevation: 8, minimumSize: const Size(132, 44));

List<DropdownMenuItem<String>> makeDropList(List<String> items) {
  return items
      .map(
        (e) => DropdownMenuItem<String>(
          value: e,
          child: Center(child: Text(e)),
        ),
      )
      .toList();
}

class IndexItem<T> {
  int index;
  T item;

  IndexItem(this.index, this.item);
}

extension ListIndexItemExt<T> on List<T> {
  IndexItem<T> indexItem(int index) {
    return IndexItem(index, this.elementAt(index));
  }
}

class LimitList<T> extends Iterable<T> {
  final int limit;
  final List<T> _list = [];

  LimitList(this.limit, {List<T>? values}) {
    if (values != null && values.isNotEmpty) {
      if (values.length <= limit) {
        _list.addAll(values);
      } else {
        _list.addAll(values.sublist(values.length - limit));
      }
    }
  }

  @override
  int get length => _list.length;

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  bool get isNotEmpty => _list.isNotEmpty;

  int backCount(bool Function(T) test) {
    int n = 0;
    for (T e in _list.reversed) {
      if (test(e)) {
        n += 1;
      } else {
        return n;
      }
    }
    return n;
  }

  void clear() => _list.clear();

  T removeAt(int index) {
    return _list.removeAt(index);
  }

  bool removeFirst(T value) {
    return _list.remove(value);
  }

  void removeAll(bool Function(T) test) {
    _list.removeWhere(test);
  }

  T operator [](int index) {
    return _list[index];
  }

  void operator []=(int index, T value) {
    _list[index] = value;
    _checkLength();
  }

  T? getOr(int index) {
    return _list.getOr(index);
  }

  void add(T value) {
    _list.add(value);
    _checkLength();
  }

  void addAll(Iterable<T> values) {
    _list.addAll(values);
    _checkLength();
  }

  void _checkLength() {
    if (_list.length > limit) {
      _list.removeRange(0, _list.length - limit);
    }
  }

  @override
  Iterator<T> get iterator => _list.iterator;
}
