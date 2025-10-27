part of 'key_attr.dart';

class PreferProvider extends AttributeProvider {
  final SharedPreferences prefer;

  PreferProvider._(this.prefer);

  static late PreferProvider _instance;

  static PreferProvider get instance => _instance;

  static Future<PreferProvider> prepare() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    _instance = PreferProvider._(p);
    return _instance;
  }

  Set<String> get keySet {
    return prefer.getKeys();
  }

  T? getValue<T extends Object>(String key) {
    Object? value = prefer.get(key);
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
    typeError(T, value);
  }

  Future<bool> setValue(String key, Object? value) {
    if (value == null) {
      return prefer.remove(key);
    }
    if (value is bool) return prefer.setBool(key, value);
    if (value is int) return prefer.setInt(key, value);
    if (value is double) return prefer.setDouble(key, value);
    if (value is String) return prefer.setString(key, value);
    if (value is Iterable<String>) return prefer.setStringList(key, value.toList());
    if (value is Iterable<int>) return prefer.setStringList(key, value.mapList((e) => e.toString()));
    if (value is Iterable<double>) return prefer.setStringList(key, value.mapList((e) => e.toString()));
    if (value is Iterable<bool>) return prefer.setStringList(key, value.mapList((e) => e.toString()));
    typeError(value.runtimeType, value);
  }

  bool? getBool(String key) {
    return prefer.getBool(key);
  }

  int? getInt(String key) {
    return prefer.getInt(key);
  }

  double? getDouble(String key) {
    return prefer.getDouble(key);
  }

  String? getString(String key) {
    return prefer.getString(key);
  }

  List<String>? getStringList(String key) {
    return prefer.getStringList(key);
  }

  @override
  Object? getAttribute(String key) {
    return prefer.get(key);
  }

  @override
  bool hasAttribute(String key) {
    return prefer.containsKey(key);
  }

  @override
  Object? removeAttribute(String key) {
    return prefer.remove(key);
  }

  @override
  void setAttribute(String key, Object? value) {
    switch (value) {
      case null:
        prefer.remove(key);
      case bool _:
        prefer.setBool(key, value);
      case int _:
        prefer.setInt(key, value);
      case double _:
        prefer.setDouble(key, value);
      case String _:
        prefer.setString(key, value);
      case List<String> _:
        prefer.setStringList(key, value);
      default:
        error("Not support type, LocalStore.setValue: $key, $value");
    }
  }

  @override
  bool acceptValue(dynamic value) {
    return value is bool || value is int || value is double || value is String || value is List<String>;
  }

  @override
  bool acceptType<CH>(XType<CH> chtype) {
    return chtype.isSubtypeOf<bool>() || chtype.isSubtypeOf<int>() || chtype.isSubtypeOf<double>() || chtype.isSubtypeOf<String>() || chtype.isSubtypeOf<List<String>>();
  }
}
