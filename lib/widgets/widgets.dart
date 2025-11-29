library;

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:entao_dutil/entao_dutil.dart';
import 'package:entao_hare/basic/basic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../harewidget/harewidget.dart';

part 'AmplitudeWidget.dart';
part 'AsyncBuilder.dart';
part 'FlipCard.dart';
part 'PaintWidget.dart';
part 'actions.dart';
part 'auto_complete.dart';
part 'chips.dart';
part 'edits.dart';
part 'hare_button.dart';
part 'hare_edit.dart';
part 'hare_text.dart';
part 'hare_widgets.dart';
part 'int_item_pick.dart';
part 'pop_menu.dart';
part 'radios.dart';
part 'segments.dart';
part 'slider.dart';
part 'snack.dart';
part 'TipText.dart';
part 'form.dart';

extension ScrollControllerExt on ScrollController {
  void jumpBottom({int delay = 0}) {
    if (delay > 0) {
      Future.delayed(Duration(milliseconds: delay), () {
        postFrame(() {
          this.jumpTo(this.position.maxScrollExtent);
        });
      });
    } else {
      postFrame(() {
        this.jumpTo(this.position.maxScrollExtent);
      });
    }
  }

  void jumpTop({int delay = 0}) {
    if (delay > 0) {
      Future.delayed(Duration(milliseconds: delay), () {
        postFrame(() {
          this.jumpTo(this.position.minScrollExtent);
        });
      });
    } else {
      postFrame(() {
        this.jumpTo(this.position.minScrollExtent);
      });
    }
  }
}

RadioGroup<T> RadioGroupVer<T>(
  List<LabelValue<T>> items,
  OptionalValueListener<T> listener, {
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
}) {
  return RadioGroup<T>(
    groupValue: listener.value,
    onChanged: listener.onChanged,
    child: ColumnMin(
      items.mapList((e) => RowMin([Radio(value: e.value), e.label.text()])),
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
    ),
  );
}

RadioGroup<T> RadioGroupHor<T>(List<LabelValue<T>> items, OptionalValueListener<T> listener, {MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceAround}) {
  return RadioGroup<T>(
    groupValue: listener.value,
    onChanged: listener.onChanged,
    child: RowMax(items.mapList((e) => RowMin([Radio(value: e.value), e.label.text()])), mainAxisAlignment: mainAxisAlignment),
  );
}

class QuickScrollPhysics extends ScrollPhysics {
  const QuickScrollPhysics({super.parent});

  @override
  QuickScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return QuickScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(mass: 0.1, stiffness: 100, ratio: 1);
}

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

  Widget popValues<T>({List<T>? items, List<T> Function(BuildContext)? builder, Widget Function(T)? display, required void Function(T) callback, T? initialValue}) {
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
    T? value,
  }) {
    return PopupMenuButton<LabelValue<T>>(
      child: this,
      onSelected: (e) => callback(e),
      position: PopupMenuPosition.under,
      initialValue: initialValue ?? items?.firstOr((e) => e.value == value),
      itemBuilder: (BuildContext c) {
        List<LabelValue<T>> ls = builder?.call(c) ?? items ?? [];
        return ls.mapList((e) => PopupMenuItem<LabelValue<T>>(value: e, child: display?.call(e) ?? e.label.text()));
      },
    );
  }

  Widget popPairs<T>({required List<LabelValue<T>> items, Widget Function(LabelValue<T>)? display, required void Function(LabelValue<T>) callback, T? value}) {
    return PopupMenuButton<LabelValue<T>>(
      child: this,
      onSelected: (e) => callback(e),
      position: PopupMenuPosition.under,
      initialValue: items.firstOr((e) => e.value == value),
      itemBuilder: (BuildContext c) {
        return items.mapList((e) => PopupMenuItem<LabelValue<T>>(value: e, child: display?.call(e) ?? e.label.text()));
      },
    );
  }
}
