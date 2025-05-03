part of '../fhare.dart';

typedef OnChildren<T> = List<T> Function(T value);

typedef OnWidget<T> = Widget Function(T value);
typedef OnItemView<T> = Widget Function(T value);
typedef OnWidgetOpt<T> = Widget? Function(T value);

typedef ListWidget = List<Widget>;

typedef TypeWidgetBuilder<T> = T Function(BuildContext context);

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

class Plat {
  Plat._();

  static bool get isDebug => kDebugMode;

  static bool get isDebugMode => kDebugMode;

  static bool get isWeb => kIsWeb || kIsWasm;

  static bool get isMobile => !isWeb && (Platform.isAndroid || Platform.isIOS);

  static bool get isDesktop => !isWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

  static bool get isAndroid => !isWeb && (Platform.isAndroid);

  static bool get isIOS => !isWeb && (Platform.isIOS);

  static bool get isFuchsia => !isWeb && (Platform.isFuchsia);

  static bool get isMacOS => !isWeb && (Platform.isMacOS);

  static bool get isWindows => !isWeb && (Platform.isWindows);

  static bool get isLinux => !isWeb && (Platform.isLinux);
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
