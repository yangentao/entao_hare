part of 'prefer.dart';

abstract mixin class AttributeProvider {
  bool acceptType<T extends Object>();

  bool hasAttribute(String key);

  Object? getAttribute(String key);

  void setAttribute(String key, Object? value);

  Object? removeAttribute(String key);

  static AttributeProvider? globalProvider;
}

class MapAttributeProvider extends AttributeProvider {
  Map<String, dynamic> map;

  MapAttributeProvider({Map<String, dynamic>? map}) : this.map = map ?? {};

  @override
  Object? getAttribute(String key) {
    return map[key];
  }

  @override
  bool hasAttribute(String key) {
    return map.containsKey(key);
  }

  @override
  Object? removeAttribute(String key) {
    return map.remove(key);
  }

  @override
  void setAttribute(String key, Object? value) {
    if (value == null) {
      map.remove(key);
    } else {
      map[key] = value;
    }
  }

  @override
  bool acceptType<T extends Object>() {
    return true;
  }
}
