part of '../fhare.dart';

class IniItem {
  String key;
  String value;
  String section;

  IniItem({required this.key, required this.value, this.section = ""});

  @override
  String toString() {
    if (section.isEmpty) return "$key=$value";
    return "[$section] $key=$value";
  }

  String toText() {
    return "$key=$value";
  }
}

class ini {
  ini._();

  static List<IniItem>? read({required String file}) {
    String? s = File(file).readText();
    if (s == null) return null;
    return fromText(s);
  }

  static void write({required String file, required List<IniItem> items}) {
    String text = toText(items);
    text.writeToPath(file);
  }

  static List<IniItem> fromText(String text) {
    List<IniItem> items = [];
    List<String> lines = text.splitLines();
    String sec = "";
    for (String line in lines) {
      String ln = line.substringBefore("#").trim();
      if (ln.length < 3) continue; //[a], a=1
      if (ln[0] == '[' && ln[ln.length - 1] == ']') {
        sec = ln.substring(1, ln.length - 1).trim();
        continue;
      }
      int idx = ln.indexOf('=');
      if (idx <= 0) continue;
      String k = ln.substring(0, idx).trim();
      String v = ln.substring(idx + 1).trim();
      if (k.isEmpty) continue;
      items << IniItem(key: k, value: v, section: sec);
    }

    return items;
  }

  static String toText(List<IniItem> items) {
    Map<String, List<IniItem>> map = items.groupBy((e) => e.section);
    String text = "";
    List<IniItem>? globalItems = map.remove("");
    if (globalItems != null && globalItems.isNotEmpty) {
      for (var e in globalItems) {
        text += "${e.key}=${e.value}\n";
      }
    }
    String preSection = "";
    for (MapEntry<String, List<IniItem>> e in map.entries) {
      if (e.key != preSection) {
        preSection = e.key;
        if (text.isEmpty) {
          text += "[${e.key}]\n";
        } else {
          text += "\n[${e.key}]\n";
        }
      }
      for (IniItem item in e.value) {
        text += "${item.toText()}\n";
      }
    }
    return text;
  }
}
