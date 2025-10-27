part of 'key_attr.dart';

abstract mixin class AttributeTransform<T extends Object> {
  T fromRawAttribute(AttributeProvider provider, Object attr);

  Object toRawAtttribute(AttributeProvider provider, T value);
}

class ListStringTransform extends AttributeTransform<List<String>> {
  @override
  List<String> fromRawAttribute(AttributeProvider provider, Object attr) {
    switch (attr) {
      case List<String> _:
        return attr;
      case String _:
        return attr.split(",").mapList((e) => e).nonNullList;
      default:
        typeError(List<String>, attr);
    }
  }

  @override
  Object toRawAtttribute(AttributeProvider provider, List<String> value) {
    if (provider.acceptType<List<String>>()) {
      return value;
    }
    if (provider.acceptType<Object>()) {
      return value;
    }
    if (provider.acceptType<String>()) {
      return value.join(",");
    }
    typeError(List<String>, value);
  }
}

class ListIntTransform extends AttributeTransform<List<int>> {
  @override
  List<int> fromRawAttribute(AttributeProvider provider, Object attr) {
    switch (attr) {
      case List<int> _:
        return attr;
      case String _:
        return attr.split(",").mapList((e) => e.toInt).nonNullList;
      case List<String> _:
        return attr.map((e) => e.toInt).nonNullList;
      default:
        typeError(List<int>, attr);
    }
  }

  @override
  Object toRawAtttribute(AttributeProvider provider, List<int> value) {
    if (provider.acceptType<List<int>>()) {
      return value;
    }
    if (provider.acceptType<Object>()) {
      return value;
    }
    if (provider.acceptType<List<String>>()) {
      return value.mapList((e) => e.toString());
    }
    if (provider.acceptType<String>()) {
      return value.join(",");
    }
    typeError(List<int>, value);
  }
}
