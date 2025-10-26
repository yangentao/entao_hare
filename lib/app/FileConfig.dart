part of 'app.dart';

class FileConfig {
  static const int DELAY_SAVE_MS = 1000;
  final File _file;
  final bool _autoSave;
  final Map<String, dynamic> configMap = {};
  final int _delay;
  Future<dynamic>? _preTask;

  FileConfig({required File file, bool autoSave = true, int delay = DELAY_SAVE_MS}) : _file = file, _autoSave = autoSave, _delay = delay {
    load();
  }

  dynamic get(String key) => configMap[key];

  void put(String key, dynamic value) {
    configMap[key] = value;
    _triggerSave();
  }

  dynamic remove(String key) {
    dynamic v = configMap.remove(key);
    _triggerSave();
    return v;
  }

  void clear() {
    configMap.clear();
    _triggerSave();
  }

  Map<String, dynamic> all() {
    return configMap;
  }

  bool exist(String key) {
    return configMap.containsKey(key);
  }

  void load({bool clear = true}) {
    if (clear) configMap.clear();
    if (!_file.existsSync()) return;
    String text = _file.readAsStringSync();
    if (text.isEmpty) {
      return;
    }
    dynamic v = json.decode(text);
    if (v == null) return;
    if (v is Map) {
      for (var a in v.entries) {
        configMap[a.key] = a.value;
      }
    }
  }

  void save() {
    String text = json.encode(configMap);
    _file.writeAsStringSync(text);
  }

  void _triggerSave() {
    if (!_autoSave) {
      return;
    }
    if (_delay <= 0) {
      save();
      return;
    }
    if (_preTask != null) return;
    _preTask = Future.delayed(Duration(milliseconds: _delay)).then((e) {
      _preTask = null;
      save();
    });
  }

  FileConfigAttr<T> attr<T>(String key) {
    return FileConfigAttr<T>(this, key);
  }
}

class FileConfigAttr<T> {
  final FileConfig config;
  final String key;

  FileConfigAttr(this.config, this.key);

  T get value => config.get(key);

  set value(T v) {
    config.put(key, v);
  }
}

typedef FCString = FileConfigAttr<String>;
typedef FCString_ = FileConfigAttr<String?>;

typedef FCInt = FileConfigAttr<int>;
typedef FCInt_ = FileConfigAttr<int?>;

typedef FCDouble = FileConfigAttr<double>;
typedef FCDouble_ = FileConfigAttr<double?>;

typedef FCBool = FileConfigAttr<bool>;
typedef FCBool_ = FileConfigAttr<bool?>;
