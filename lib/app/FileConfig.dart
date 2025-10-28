part of 'app.dart';

class FileConfig implements AttributeProvider {
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

  bool containsKey(String key) {
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

  @override
  bool acceptType<CH>(DType<CH> chtype) {
    return chtype.isSubtypeOf<bool?>() ||
        chtype.isSubtypeOf<int?>() ||
        chtype.isSubtypeOf<double?>() ||
        chtype.isSubtypeOf<String?>() ||
        chtype.isSubtypeOf<List<dynamic>>() ||
        chtype.isSubtypeOf<Map<String, dynamic>>();
  }

  @override
  bool acceptValue(Object? value) {
    return value == null || value is bool || value is int || value is double || value is String || value is List || value is Map<String, dynamic>;
  }

  @override
  Object? getAttribute(String key) {
    return get(key);
  }

  @override
  void setAttribute(String key, Object? value) {
    put(key, value);
  }

  @override
  bool hasAttribute(String key) {
    return containsKey(key);
  }

  @override
  Object? removeAttribute(String key) {
    return remove(key);
  }
}
