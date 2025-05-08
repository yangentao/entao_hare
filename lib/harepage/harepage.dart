library;

import 'dart:async';

import 'package:entao_dutil/entao_dutil.dart';
import 'package:flutter/material.dart';

import '../basic/basic.dart';
import '../harewidget/harewidget.dart';

part 'dashslot.dart';

abstract class GroupHarePage extends HarePage {
  GroupHarePage() : super();
  List<HarePage> children = [];
}

extension HarePageAttrEx on HarePage {
  AnyProp<T> pageProp<T extends Object>(String name, {T? missValue}) {
    return AnyProp<T>(map: this.holder.attrs, key: name, missValue: missValue);
  }
}

abstract class HarePage extends HareWidget with DashSlot, OnMessage {
  //用于tabbar/drawer/bottombar的情况下, 没有设置title的时候,pageLabel用作title
  IconData pageIcon = Icons.home;
  String pageLabel = "Title";

  HarePage() : super() {
    MsgCenter.add(this);
  }

  Widget pageIconWidget() {
    return pageIcon.icon();
  }

  @override
  State<HareWidget> createState() {
    return HareWidgetState();
  }

  @override
  void onDestroy() {
    MsgCenter.remove(this);
    super.onDestroy();
  }

  @override
  void onMsg(Msg msg) {}

  @override
  Widget? buildTitle(BuildContext context) {
    title ??= pageLabel.hareText();
    return title;
  }

  void setTitle(String text) {
    HareText? ht = title?.castTo();
    if (ht != null) {
      ht.update(text);
      return;
    }
    title = HareText(text);
  }

  Future<void> loading(Future<void> Function() callback) async {
    await Loading.loading(callback);
  }
}
