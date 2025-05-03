part of '../fhare.dart';

class Dirs {
  Dirs._();

  static Future<Directory> temp() async {
    return await getTemporaryDirectory();
  }

  static Future<Directory?> download() async {
    return await getDownloadsDirectory();
  }

  /// data ,  for user
  static Future<Directory> document() async {
    return await getApplicationDocumentsDirectory();
  }

  /// android files dir, for app
  static Future<Directory> support() async {
    return await getApplicationSupportDirectory();
  }

  static Future<Directory> cache() async {
    return await getApplicationCacheDirectory();
  }

  /// for user
  static Future<File> userFile({String? file, String? ext, String? dir}) async {
    return await makeFile(await getApplicationDocumentsDirectory(), file: file, ext: ext, dir: dir);
  }

  /// for app
  static Future<File> appFile({String? file, String? ext, String? dir}) async {
    return await makeFile(await getApplicationSupportDirectory(), file: file, ext: ext, dir: dir);
  }

  /// for cache
  static Future<File> cacheFile({String? file, String? ext, String? dir}) async {
    return await makeFile(await getApplicationCacheDirectory(), file: file, ext: ext, dir: dir);
  }

  /// for temp
  static Future<File> tempFile({String? file, String? ext, String? dir}) async {
    return await makeFile(await getTemporaryDirectory(), file: file, ext: ext, dir: dir);
  }

  static Future<File> makeFile(Directory base, {String? file, String? ext, String? dir}) async {
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

  static Future<File> tempWriteText(String data, {String ext = ".tmp"}) async {
    return await tempWrite(data.utf8Bytes(), ext: ext);
  }

  static Future<File> tempWrite(Uint8List data, {String ext = ".tmp"}) async {
    File f = await tempFile(ext: ext);
    return await f.writeAsBytes(data, flush: true);
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
