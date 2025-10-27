part of 'prefer.dart';

typedef BoolAttribute = RequiredAttribute<bool>;
typedef IntAttribute = RequiredAttribute<int>;
typedef DoubleAttribute = RequiredAttribute<double>;
typedef StringAttribute = RequiredAttribute<String>;

typedef BoolOptionalAttribute = OptionalAttribute<bool>;
typedef IntOptionalAttribute = OptionalAttribute<int>;
typedef DoubleOptionalAttribute = OptionalAttribute<double>;
typedef StringOptionalAttribute = OptionalAttribute<String>;

class JsonValueAttribute extends JsonValueOptional with RequiredValue {
  @override
  final JsonValue missValue;

  JsonValueAttribute({required super.key, required this.missValue, super.provider});
}

class JsonValueOptional extends OptionalAttribute<JsonValue> {
  JsonValueOptional({required super.key, super.provider});

  @override
  JsonValue fromRawAttribute(AttributeProvider provider, Object attr) {
    if (attr is String) return JsonValue(json.decode(attr));
    if (attr is JsonValue) return attr;
    typeError(JsonValue, attr);
  }

  @override
  Object toRawAtttribute(AttributeProvider provider, JsonValue value) {
    return value.jsonText;
  }
}

class ListIntAttribute extends ListIntOptional with RequiredValue {
  @override
  final List<int> missValue;

  ListIntAttribute({required super.key, required this.missValue, super.provider, super.transform});
}

class ListIntOptional extends OptionalAttribute<List<int>> {
  ListIntOptional({required super.key, super.provider, super.transform});

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

class ListStringAttribute extends ListStringOptional with RequiredValue {
  @override
  final List<String> missValue;

  ListStringAttribute({required super.key, required this.missValue, super.provider, super.transform});
}

class ListStringOptional extends OptionalAttribute<List<String>> {
  ListStringOptional({required super.key, super.provider, super.transform});

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
