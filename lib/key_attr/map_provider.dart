part of 'key_attr.dart';

class MapAttributeProvider<V> extends AttributeProvider {
  final Map<String, V> map;
  final DType<V> valueType = DType();

  MapAttributeProvider(this.map);

  @override
  V? getAttribute(String key) {
    return map[key];
  }

  @override
  bool hasAttribute(String key) {
    return map.containsKey(key);
  }

  @override
  V? removeAttribute(String key) {
    return map.remove(key);
  }

  @override
  void setAttribute(String key, Object? value) {
    if (value == null) {
      map.remove(key);
    } else {
      map[key] = value as V;
    }
  }

  @override
  bool acceptValue(Object? value) {
    return valueType.acceptInstance(value);
  }

  @override
  bool acceptType<CH>(DType<CH> chtype) {
    return chtype.isSubtypeOf<V>();
  }
}
