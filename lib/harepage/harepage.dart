library;

import 'dart:async';

import 'package:entao_dutil/entao_dutil.dart';
import 'package:flutter/material.dart';

import '../basic/basic.dart';
import '../harewidget/harewidget.dart';

part 'dashslot.dart';
part 'hare_page.dart';

extension HarePageAttrEx on HarePage {
  AnyProp<T> pageProp<T extends Object>(String name, {T? missValue}) {
    return AnyProp<T>(map: this.holder.attrs, key: name, missValue: missValue);
  }
}
