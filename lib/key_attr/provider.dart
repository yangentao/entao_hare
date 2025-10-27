part of 'key_attr.dart';

abstract mixin class AttributeProvider {
  bool acceptType<T extends Object>();

  bool hasAttribute(String key);

  Object? getAttribute(String key);

  void setAttribute(String key, Object? value);

  Object? removeAttribute(String key);

  RequiredAttribute<T> require<T extends Object>({required String key, required T missValue, AttributeTransform<T>? transform}) {
    return RequiredAttribute<T>(key: key, provider: this, missValue: missValue, transform: transform);
  }

  OptionalAttribute<T> optional<T extends Object>({required String key, AttributeTransform<T>? transform}) {
    return OptionalAttribute<T>(key: key, provider: this, transform: transform);
  }
}

class MapAttributeProvider extends AttributeProvider {
  Map<String, dynamic> map;

  MapAttributeProvider(this.map);

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
