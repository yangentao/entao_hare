part of 'key_attr.dart';

extension AttributeProviderExt on AttributeProvider {
  RequiredAttribute<T> require<T extends Object>({required String key, required T missValue, AttributeTransform<T>? transform}) {
    return RequiredAttribute<T>(key: key, provider: this, missValue: missValue, transform: transform);
  }

  OptionalAttribute<T> optional<T extends Object>({required String key, AttributeTransform<T>? transform}) {
    return OptionalAttribute<T>(key: key, provider: this, transform: transform);
  }
}

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
  final DType<T> attributeType = DType();

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
    if (transform != null) {
      return transform!.fromRawAttribute(provider, attr);
    }
    typeError(T, attr);
  }

  Object toRawAtttribute(T value) {
    if (provider.acceptValue(value)) {
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
