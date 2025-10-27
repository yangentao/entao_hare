part of 'prefer.dart';

//bool, int, double, String, List<String>
class RequiredAttribute<T extends Object> extends OptionalAttribute<T> with RequiredValue {
  @override
  final T missValue;

  RequiredAttribute({required super.key, required this.missValue, super.transform, super.provider});
}

//bool?, int?, double?, String?, List<String>?
class OptionalAttribute<T extends Object> {
  final String key;
  final AttributeTransform<T>? transform;
  final AttributeProvider? provider;

  OptionalAttribute({required this.key, this.transform, this.provider});

  AttributeProvider get requiredProvider {
    var p = this.provider ?? AttributeProvider.globalProvider;
    if (p != null) return p;
    throw Exception("No Provider");
  }

  bool get exists => requiredProvider.hasAttribute(key);

  Object? get rawValue => requiredProvider.getAttribute(key);

  set rawValue(Object? value) => requiredProvider.setAttribute(key, value);

  T? get value {
    Object? v = requiredProvider.getAttribute(key);
    if (v == null) return null;
    return fromRawAttribute(requiredProvider, v);
  }

  set value(T? newValue) {
    if (newValue == null) {
      requiredProvider.removeAttribute(key);
    } else {
      var v = toRawAtttribute(requiredProvider, newValue);
      requiredProvider.setAttribute(key, v);
    }
  }

  T fromRawAttribute(AttributeProvider provider, Object attr) {
    if (transform != null) {
      return transform!.fromRawAttribute(provider, attr);
    }
    if (attr is T) return attr;
    typeError(T, attr);
  }

  Object toRawAtttribute(AttributeProvider provider, T value) {
    if (transform != null) {
      return transform!.toRawAtttribute(provider, value);
    }
    if (provider.acceptType<T>()) {
      return value as Object;
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
