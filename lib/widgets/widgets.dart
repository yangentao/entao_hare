library;

import 'dart:async';
import 'dart:math' as math;

import 'package:entao_dutil/entao_dutil.dart';
import 'package:entao_hare/basic/basic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../harewidget/harewidget.dart';

part 'actions.dart';
part 'auto_complete.dart';
part 'chips.dart';
part 'edits.dart';
part 'hare_button.dart';
part 'hare_widgets.dart';
part 'int_item_pick.dart';
part 'radios.dart';
part 'segments.dart';
part 'slider.dart';
part 'hare_text.dart';
part 'hare_edit.dart';

extension WidgetPopButtonExt on Widget {
  Widget popActions({List<XAction>? items, List<XAction> Function(BuildContext)? builder}) {
    return PopupMenuButton<XAction>(
      child: this,
      onSelected: (e) => e.onclick(),
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext c) {
        List<XAction> ls = builder?.call(c) ?? items ?? [];
        return ls.mapList((e) => e.menuitem());
      },
    );
  }

  Widget popValues<T>({
    List<T>? items,
    List<T> Function(BuildContext)? builder,
    Widget Function(T)? display,
    required void Function(T) callback,
    T? initialValue,
  }) {
    return PopupMenuButton<T>(
      child: this,
      onSelected: (e) => callback(e),
      position: PopupMenuPosition.under,
      initialValue: initialValue,
      itemBuilder: (BuildContext c) {
        List<T> ls = builder?.call(c) ?? items ?? [];
        return ls.mapList((e) => PopupMenuItem<T>(value: e, child: display?.call(e) ?? e.toString().text()));
      },
    );
  }

  Widget popLabelValues<T>({
    List<LabelValue<T>>? items,
    List<LabelValue<T>> Function(BuildContext)? builder,
    Widget Function(LabelValue<T>)? display,
    required void Function(LabelValue<T>) callback,
    LabelValue<T>? initialValue,
  }) {
    return PopupMenuButton<LabelValue<T>>(
      child: this,
      onSelected: (e) => callback(e),
      position: PopupMenuPosition.under,
      initialValue: initialValue,
      itemBuilder: (BuildContext c) {
        List<LabelValue<T>> ls = builder?.call(c) ?? items ?? [];
        return ls.mapList((e) => PopupMenuItem<LabelValue<T>>(value: e, child: display?.call(e) ?? e.label.text()));
      },
    );
  }
}
