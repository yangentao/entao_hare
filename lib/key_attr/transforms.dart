part of 'key_attr.dart';

class ListStringTransform extends AttributeTransform<List<String>> {
  @override
  List<String> fromRawAttribute(AttributeProvider provider, Object attr) {
    switch (attr) {
      case List<String> _:
        return attr;
      case List<dynamic> ls:
        return ls.map((e) => e?.toString()).nonNullList;
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
    if (provider.acceptType(DType.typeString)) {
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
      case List<dynamic> ls:
        return ls.map((e) {
          return switch (e) {
            int n => n,
            num m => m.toInt(),
            String s => s.toInt,
            _ => null,
          };
        }).nonNullList;
      default:
        typeError(List<int>, attr);
    }
  }

  @override
  Object toRawAtttribute(AttributeProvider provider, List<int> value) {
    if (provider.acceptValue(value)) {
      return value;
    }
    if (provider.acceptType(DType.typeListString)) {
      return value.mapList((e) => e.toString());
    }
    if (provider.acceptType(DType.typeString)) {
      return value.join(",");
    }
    typeError(List<int>, value);
  }
}
