part of 'app.dart';

class Assets {
  static const List<String> imageExts = ["png", "jpg"];
  static List<String>? _allKeys;

  static List<String> get keyList => _allKeys ?? [];

  static Future<List<String>> loadKeys({bool reload = false}) async {
    if (reload || _allKeys == null) {
      AssetManifest am = await AssetManifest.loadFromAssetBundle(rootBundle);
      _allKeys = am.listAssets();
    }
    return keyList;
  }

  static List<String> filter({String? dir, String? ext, List<String>? exts, String? package}) {
    return keyList.assetFilter(dir: dir, ext: ext, exts: exts, package: package);
  }

  static List<Image> imageList({String? dir, String? ext, List<String>? exts, String? package}) {
    List<String> ls = keyList.assetFilter(dir: dir, ext: ext, exts: exts ?? imageExts, package: package);
    return ls.mapList((e) => Image.asset(e));
  }

  static Future<String> loadString(String key) async {
    return rootBundle.loadString(key);
  }

  static String packagekey(String name, {String? package}) {
    if (package == null) return name;
    return "packages/$package/$name";
  }
}

extension on List<String> {
  List<String> assetFilter({String? dir, String? ext, List<String>? exts, String? package}) {
    List<String> keyList = this;
    if (keyList.isEmpty) return [];
    String prifix = "";
    if (package != null && package.isNotEmpty) {
      prifix = "packages/$package/";
    }
    if (dir != null && dir.isNotEmpty) {
      String s = dir.startsWith("/") ? dir.substring(1) : dir;
      if (s.isNotEmpty) {
        prifix += s.endsWith("/") ? s : "$s/";
      }
    }
    if (prifix.isNotEmpty) {
      keyList = keyList.filter((e) => e.startsWith(prifix));
    }
    if (ext != null && ext.isNotEmpty) {
      String surfix = (ext.startsWith(".") ? ext : ".$ext").toLowerCase();
      keyList = keyList.filter((e) => e.toLowerCase().endsWith(surfix));
    } else if (exts != null && exts.isNotEmpty) {
      List<String> es = exts.filter((e) => e.isNotEmpty).mapList((e) => (e.startsWith(".") ? e : ".$e").toLowerCase());
      if (es.isNotEmpty) {
        keyList = keyList.filter((e) => es.any((a) => e.toLowerCase().endsWith(a)));
      }
    }
    return keyList;
  }
}
