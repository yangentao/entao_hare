library;

import 'package:entao_dutil/entao_dutil.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

part 'hare_text.dart';
part 'hare_widget.dart';
part 'hare_widget_ext.dart';
part 'ticker_providers.dart';

extension HareWidgetAttrEx on HareWidget {
  AnyProp<T> widgetProp<T extends Object>(String name, {T? missValue}) {
    return AnyProp<T>(map: this.holder.attrs, key: name, missValue: missValue);
  }
}
