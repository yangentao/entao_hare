part of '../basic.dart';

/// call prepare() first.
class Dirs {
  Dirs._();

  static late final Directory dirTemp;
  static late final Directory dirDocument;
  static late final Directory dirSupport;
  static late final Directory dirCache;
  static late final Directory? dirDownload;
  static bool _inited = false;

  static Future<void> prepare() async {
    if (_inited) return;
    _inited = true;
    dirTemp = await getTemporaryDirectory();
    dirDocument = await getApplicationDocumentsDirectory();
    dirDownload = await getDownloadsDirectory();
    dirSupport = await getApplicationSupportDirectory();
    dirCache = await getApplicationCacheDirectory();
  }

  /// for user
  static File userFile({String? file, String? ext, String? dir}) {
    return makeFile(dirDocument, file: file, ext: ext, dir: dir);
  }

  /// for app
  static File appFile({String? file, String? ext, String? dir}) {
    return makeFile(dirSupport, file: file, ext: ext, dir: dir);
  }

  /// for cache
  static File cacheFile({String? file, String? ext, String? dir}) {
    return makeFile(dirCache, file: file, ext: ext, dir: dir);
  }

  /// for temp
  static File tempFile({String? file, String? ext, String? dir}) {
    return makeFile(dirTemp, file: file, ext: ext, dir: dir);
  }

  static File makeFile(Directory base, {String? file, String? ext, String? dir}) {
    String s = file ?? uuidString();
    if (notBlank(ext)) {
      if (ext!.startsWith(".")) {
        s = s + ext;
      } else {
        s = "$s.$ext";
      }
    }
    if (dir == null || dir.isEmpty) {
      return File(joinPath(base.path, s));
    }
    Directory subdir = Directory(joinPath(base.path, dir));
    if (!subdir.existsSync()) {
      subdir.createSync(recursive: true);
    }
    return File(joinPath(subdir.path, s));
  }

  static void tempWriteText(String data, {String ext = ".tmp"}) {
    tempWrite(data.utf8Bytes(), ext: ext);
  }

  static void tempWrite(Uint8List data, {String ext = ".tmp"}) {
    File f = tempFile(ext: ext);
    f.writeAsBytesSync(data, flush: true);
  }
}

extension FileDelExt on File {
  bool deleteSafe({bool recursive = false}) {
    try {
      this.deleteSync(recursive: recursive);
      return true;
    } catch (e) {
      return false;
    }
  }
}
