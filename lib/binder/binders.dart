// ignore_for_file: must_be_immutable, non_constant_identifier_names

library;

import 'dart:ui';

import 'package:entao_dutil/entao_dutil.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../basic/basic.dart';
import '../harewidget/harewidget.dart';

part 'binder_chip.dart';
part 'binder_radio.dart';
part 'binder_segments.dart';
part 'binder_widgets.dart';

extension HarePageBinderExt on HareWidget {
  Binder<T> bind<T>(T initValue, {BinderCallback<T>? onChanged}) {
    return Binder<T>(value: initValue, onUpdateUI: (s) => updateState(), onChanged: onChanged);
  }
}

typedef BinderCallback<T> = OnValue<Binder<T>>;

class Binder<T> {
  final List<BinderCallback<T>> _updateUIList = [];
  final List<BinderCallback<T>> _changedList = [];

  T value;

  Binder({required this.value, BinderCallback<T>? onUpdateUI, BinderCallback<T>? onChanged}) {
    if (onUpdateUI != null) {
      _updateUIList << onUpdateUI;
    }
    if (onChanged != null) {
      _changedList << onChanged;
    }
  }

  void fireUpdateUI() {
    List<OnValue<Binder<T>>> ls = [..._updateUIList];
    for (var c in ls) {
      c(this);
    }
  }

  void fireChanged() {
    List<OnValue<Binder<T>>> ls = [..._changedList];
    for (var c in ls) {
      c(this);
    }
  }

  void onUpdateUI(BinderCallback<T> callback) {
    if (!_updateUIList.contains(callback)) {
      _updateUIList.add(callback);
    }
  }

  void onChanged(BinderCallback<T> callback) {
    if (!_changedList.contains(callback)) {
      _changedList.add(callback);
    }
  }

  void remove(BinderCallback<T> callback) {
    _updateUIList.remove(callback);
    _changedList.remove(callback);
  }
}
