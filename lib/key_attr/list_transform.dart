part of 'key_attr.dart';

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
    if (provider.acceptValue(value)) {
      return value;
    }
    if (provider.acceptType(XType.typeString)) {
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
    if (provider.acceptValue(value)) {
      return value;
    }
    if (provider.acceptType(XType.typeListString)) {
      return value.mapList((e) => e.toString());
    }
    if (provider.acceptType(XType.typeString)) {
      return value.join(",");
    }
    typeError(List<int>, value);
  }
}
