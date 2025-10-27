part of 'prefer.dart';

abstract mixin class AttributeTransform<T extends Object> {
  T fromRawAttribute(AttributeProvider provider, Object attr);

  Object toRawAtttribute(AttributeProvider provider, T value);
}

class RawPreferTransform<T extends Object> extends AttributeTransform<T> {
  @override
  T fromRawAttribute(AttributeProvider provider, Object attr) {
    if (attr is T) return attr;
    typeError(T, attr);
  }

  @override
  Object toRawAtttribute(AttributeProvider provider, T value) {
    if (provider.acceptType<T>()) return value;
    typeError(T, value);
  }
}
