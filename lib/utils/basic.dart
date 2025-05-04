part of '../entao_hare.dart';

Future<PackageInfo> packageInfo() async {
  PackageInfo info = await PackageInfo.fromPlatform();
  return info;
}

final RegExp _itemSep = RegExp(r"[,;]");
final RegExp _attrSep = RegExp(r"[=:]");
//a=1;b:2,c:3   => [(a,1), (b,2), (c, 3)]
List<MapEntry<String, String>> parseProperties(String text, {Pattern? itemSep, Pattern? attrSep}) {
  List<String> items = text.split(itemSep ?? _itemSep).mapList((e) => e.trim()).filter((e) => e.isNotEmpty);
  List<MapEntry<String, String>> values = [];
  for (String item in items) {
    List<String> pair = item.split(attrSep ?? _attrSep).mapList((e) => e.trim());
    if (pair.isEmpty) continue;
    values << MapEntry<String, String>(pair.first, pair.second?.trim() ?? "");
  }
  return values;
}

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
