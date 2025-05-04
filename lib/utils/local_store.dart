part of '../entao_hare.dart';

//LocalStore.prepare()
late LocalStore localStore;

typedef LocalBool = LocalAttr<bool>;
typedef LocalInt = LocalAttr<int>;
typedef LocalDouble = LocalAttr<double>;
typedef LocalString = LocalAttr<String>;
typedef LocalListString = LocalAttr<List<String>>;
typedef LocalListBool = LocalAttr<List<bool>>;
typedef LocalListInt = LocalAttr<List<int>>;
typedef LocalListDouble = LocalAttr<List<double>>;

typedef LocalBoolOpt = LocalAttrOpt<bool>;
typedef LocalIntOpt = LocalAttrOpt<int>;
typedef LocalDoubleOpt = LocalAttrOpt<double>;
typedef LocalStringOpt = LocalAttrOpt<String>;
typedef LocalListStringOpt = LocalAttrOpt<List<String>>;
typedef LocalListBoolOpt = LocalAttrOpt<List<bool>>;
typedef LocalListIntOpt = LocalAttrOpt<List<int>>;
typedef LocalListDoubleOpt = LocalAttrOpt<List<double>>;

typedef LocalDecoder<T> = T Function(Object);
typedef LocalEncoder<T> = Object Function(T);

JsonValue jsonValueDecoder(Object value) {
  if (value is String) return JsonValue.parse(value);
  if (value is JsonValue) return value;
  error("NOT support value: $value");
}

Object jsonValueEncoder(JsonValue value) => value.jsonText;

class LocalJsonModel<T extends JsonModel> extends LocalModel<T> {
  LocalJsonModel({required super.key, required T Function(JsonValue) map})
      : super(encoder: (T v) => jsonValueEncoder(v.jsonValue), decoder: (Object v) => map(jsonValueDecoder(v)));
}

class LocalModel<T> {
  final String key;
  final LocalDecoder<T> decoder;
  final LocalEncoder<T> encoder;

  LocalModel({required this.key, required this.encoder, required this.decoder});

  bool get exists => localStore.prefer.containsKey(key);

  T? get value {
    Object? v = localStore.getObject(key);
    if (v == null) return null;
    return decoder(v);
  }

  set value(T? newValue) {
    if (newValue == null) {
      localStore.setValue(key, null);
      return;
    }
    localStore.setObject(key, encoder(newValue));
  }

  @override
  String toString() {
    return "LocalAttr{ key=$key, value=$value }";
  }
}

class LocalJson {
  final String key;

  LocalJson({required this.key});

  bool get exists => localStore.prefer.containsKey(key);

  JsonValue get value {
    String? s = localStore.getString(key);
    if (s == null) return JsonValue.nullValue;
    return JsonValue.parse(s);
  }

  set value(dynamic newValue) {
    if (newValue == null) {
      localStore.setValue(key, null);
    } else if (newValue is String) {
      localStore.setValue(key, newValue);
    } else if (newValue is JsonValue) {
      localStore.setValue(key, newValue.jsonText);
    }
    error("NOT support value: $newValue");
  }

  @override
  String toString() {
    return "LocalAttr{ key=$key, value=$value }";
  }
}

//bool, int, double, String, List<String>
class LocalAttr<T> {
  final String key;
  final T defaultValue;

  LocalAttr({required this.key, required this.defaultValue});

  bool get exists => localStore.prefer.containsKey(key);

  T get value {
    return localStore.getValue(key) ?? defaultValue;
  }

  set value(T? newValue) {
    localStore.setValue(key, newValue);
  }

  @override
  String toString() {
    return "LocalAttr{ key=$key, value=$value }";
  }
}

class LocalAttrOpt<T> {
  final String key;

  LocalAttrOpt(this.key);

  bool get exists => localStore.exists(key);

  T? get value {
    return localStore.getValue(key);
  }

  set value(T? newValue) {
    localStore.setValue(key, newValue);
  }

  @override
  String toString() {
    return "LocalAttr{ key=$key, value=$value }";
  }
}

class LocalStore {
  final SharedPreferences prefer;

  LocalStore._(this.prefer);

  static LocalStore get inst {
    return localStore;
  }

  static Future<bool> prepare() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    localStore = LocalStore._(p);
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
