part of 'app.dart';

late PreferStore preferStore;

typedef PreferBool = PreferAttr<bool>;
typedef PreferInt = PreferAttr<int>;
typedef PreferDouble = PreferAttr<double>;
typedef PreferString = PreferAttr<String>;
typedef PreferListString = PreferAttr<List<String>>;
typedef PreferListBool = PreferAttr<List<bool>>;
typedef PreferListInt = PreferAttr<List<int>>;
typedef PreferListDouble = PreferAttr<List<double>>;

typedef PreferBoolOpt = PreferAttrOpt<bool>;
typedef PreferIntOpt = PreferAttrOpt<int>;
typedef PreferDoubleOpt = PreferAttrOpt<double>;
typedef PreferStringOpt = PreferAttrOpt<String>;
typedef PreferListStringOpt = PreferAttrOpt<List<String>>;
typedef PreferListBoolOpt = PreferAttrOpt<List<bool>>;
typedef PreferListIntOpt = PreferAttrOpt<List<int>>;
typedef PreferListDoubleOpt = PreferAttrOpt<List<double>>;

typedef PreferDecoder<T> = T Function(Object);
typedef PreferEncoder<T> = Object Function(T);

JsonValue preferJsonValueDecoder(Object value) {
  if (value is String) return JsonValue.parse(value);
  if (value is JsonValue) return value;
  error("NOT support value: $value");
}

Object preferJsonValueEncoder(JsonValue value) => value.jsonText;

class PreferJsonModel<T extends JsonModel> extends PreferModel<T> {
  PreferJsonModel({required super.key, required T Function(JsonValue) map})
    : super(encoder: (T v) => preferJsonValueEncoder(v.jsonValue), decoder: (Object v) => map(preferJsonValueDecoder(v)));
}

class PreferModel<T> {
  final String key;
  final PreferDecoder<T> decoder;
  final PreferEncoder<T> encoder;

  PreferModel({required this.key, required this.encoder, required this.decoder});

  bool get exists => preferStore.prefer.containsKey(key);

  T? get value {
    Object? v = preferStore.getObject(key);
    if (v == null) return null;
    return decoder(v);
  }

  set value(T? newValue) {
    if (newValue == null) {
      preferStore.setValue(key, null);
      return;
    }
    preferStore.setObject(key, encoder(newValue));
  }

  @override
  String toString() {
    return "LocalAttr{ key=$key, value=$value }";
  }
}

class PreferJson {
  final String key;

  PreferJson({required this.key});

  bool get exists => preferStore.prefer.containsKey(key);

  JsonValue get value {
    String? s = preferStore.getString(key);
    if (s == null) return JsonValue.nullValue;
    return JsonValue.parse(s);
  }

  set value(dynamic newValue) {
    if (newValue == null) {
      preferStore.setValue(key, null);
    } else if (newValue is String) {
      preferStore.setValue(key, newValue);
    } else if (newValue is JsonValue) {
      preferStore.setValue(key, newValue.jsonText);
    }
    error("NOT support value: $newValue");
  }

  @override
  String toString() {
    return "LocalAttr{ key=$key, value=$value }";
  }
}

//bool, int, double, String, List<String>
class PreferAttr<T> {
  final String key;
  final T defaultValue;

  PreferAttr({required this.key, required this.defaultValue});

  bool get exists => preferStore.prefer.containsKey(key);

  T get value {
    return preferStore.getValue(key) ?? defaultValue;
  }

  set value(T? newValue) {
    preferStore.setValue(key, newValue);
  }

  @override
  String toString() {
    return "LocalAttr{ key=$key, value=$value }";
  }
}

class PreferAttrOpt<T> {
  final String key;

  PreferAttrOpt(this.key);

  bool get exists => preferStore.exists(key);

  T? get value {
    return preferStore.getValue(key);
  }

  set value(T? newValue) {
    preferStore.setValue(key, newValue);
  }

  @override
  String toString() {
    return "LocalAttr{ key=$key, value=$value }";
  }
}

class PreferStore {
  final SharedPreferences prefer;

  PreferStore._(this.prefer);

  static PreferStore get inst {
    return preferStore;
  }

  static Future<bool> prepare() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    preferStore = PreferStore._(p);
    return true;
  }

  bool exists(String key) => prefer.containsKey(key);

  Set<String> get keySet {
    return prefer.getKeys();
  }

  String? operator [](Object key) {
    return getString(key);
  }

  void operator []=(Object key, String? value) {
    setString(key, value);
  }

  T? getValue<T>(Object key) {
    Object? value = prefer.get(key.stringKey);
    if (value == null) return null;
    if (value is bool) return value.castTo();
    if (value is int) return value.castTo();
    if (value is double) return value.castTo();
    if (value is String) return value.castTo();
    if (value is List<String>) {
      if (T == List<String>) return value.castTo<List<String>>()?.castTo();
      if (T == List<bool>) return value.castTo<List<String>>()?.mapList((e) => bool.parse(e)).castTo();
      if (T == List<int>) return value.castTo<List<String>>()?.mapList((e) => int.parse(e)).castTo();
      if (T == List<double>) return value.castTo<List<String>>()?.mapList((e) => double.parse(e)).castTo();
    }
    error("Unsupport type, LocalStore.getValue:type=$T key=$key, value:$value");
  }

  Future<bool> setValue(Object key, Object? value) {
    if (value == null) {
      return prefer.remove(key.stringKey);
    }
    if (value is bool) return prefer.setBool(key.stringKey, value);
    if (value is int) return prefer.setInt(key.stringKey, value);
    if (value is double) return prefer.setDouble(key.stringKey, value);
    if (value is String) return prefer.setString(key.stringKey, value);
    if (value is Iterable<String>) return prefer.setStringList(key.stringKey, value.toList());
    if (value is Iterable<int>) return prefer.setStringList(key.stringKey, value.mapList((e) => e.toString()));
    if (value is Iterable<double>) return prefer.setStringList(key.stringKey, value.mapList((e) => e.toString()));
    if (value is Iterable<bool>) return prefer.setStringList(key.stringKey, value.mapList((e) => e.toString()));
    error("Not support type, LocalStore.setValue: $key, $value");
  }

  Object? getObject(String key) {
    return prefer.get(key);
  }

  Future<bool> setObject(String key, Object? value) {
    return setValue(key, value);
  }

  void setStringList(Object key, List<String>? value) {
    if (value == null) {
      prefer.remove(key.stringKey);
    } else {
      prefer.setStringList(key.stringKey, value);
    }
  }

  void setString(Object key, String? value) {
    if (value == null) {
      prefer.remove(key.stringKey);
    } else {
      prefer.setString(key.stringKey, value);
    }
  }

  void setDouble(Object key, double? value) {
    if (value == null) {
      prefer.remove(key.stringKey);
    } else {
      prefer.setDouble(key.stringKey, value);
    }
  }

  void setInt(Object key, int? value) {
    if (value == null) {
      prefer.remove(key.stringKey);
    } else {
      prefer.setInt(key.stringKey, value);
    }
  }

  void setBool(Object key, bool? value) {
    if (value == null) {
      prefer.remove(key.stringKey);
    } else {
      prefer.setBool(key.stringKey, value);
    }
  }

  List<String>? getStringList(Object key) {
    return prefer.getStringList(key.stringKey);
  }

  String? getString(Object key) {
    return prefer.getString(key.stringKey);
  }

  int? getInt(Object key) {
    return prefer.getInt(key.stringKey);
  }

  double? getDouble(Object key) {
    return prefer.getDouble(key.stringKey);
  }

  bool? getBool(Object key) {
    return prefer.getBool(key.stringKey);
  }
}
