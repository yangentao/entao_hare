part of 'key_attr.dart';

//bool, int, double, String, List<String>
class RequiredAttribute<T extends Object> extends OptionalAttribute<T> with RequiredValue {
  @override
  final T missValue;

  RequiredAttribute({required super.key, required this.missValue, required super.provider, super.transform});
}

//bool?, int?, double?, String?, List<String>?
class OptionalAttribute<T extends Object> {
  final String key;
  final AttributeProvider provider;
  final AttributeTransform<T>? transform;

  OptionalAttribute({required this.key, required this.provider, this.transform});

  bool get exists => provider.hasAttribute(key);

  Object? get rawValue => provider.getAttribute(key);

  set rawValue(Object? value) => provider.setAttribute(key, value);

  T? get value {
    Object? v = provider.getAttribute(key);
    if (v == null) return null;
    return fromRawAttribute(v);
  }

  set value(T? newValue) {
    if (newValue == null) {
      provider.removeAttribute(key);
    } else {
      var v = toRawAtttribute(newValue);
      provider.setAttribute(key, v);
    }
  }

  T fromRawAttribute(Object attr) {
    if (attr is T) return attr;
    if (provider.acceptType<T>()) return attr as T;
    if (transform != null) {
      return transform!.fromRawAttribute(provider, attr);
    }
    typeError(T, attr);
  }

  Object toRawAtttribute(T value) {
    if (provider.acceptType<T>()) {
      return value;
    }
    if (transform != null) {
      return transform!.toRawAtttribute(provider, value);
    }
    typeError(T, value);
  }

  @override
  String toString() {
    return "PreferOptional{ key=$key, value=$value }";
  }
}

mixin RequiredValue<T extends Object> on OptionalAttribute<T> {
  T get missValue;

  @override
  T get value => super.value ?? missValue;
}

Never typeError(Type t, Object? value) {
  throw Exception("Type error, type=$t, value=$value ");
}
