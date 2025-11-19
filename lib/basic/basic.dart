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

part 'actions.dart';
part 'bits.dart';
part 'buttons.dart';
part 'chain.dart';
part 'compose.dart';
part 'context.dart';
part 'data_widget.dart';
part 'define.dart';
part 'dimension.dart';
part 'grid_builder.dart';
part 'grid_delegate.dart';
part 'grid_items.dart';
part 'grid_tile.dart';
part 'hare_layout.dart';
part 'listview.dart';
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

