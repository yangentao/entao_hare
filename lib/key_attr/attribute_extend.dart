part of 'key_attr.dart';

extension AttributeProviderExtend on AttributeProvider {
  IntAttribute intAttribute({required String key, int missValue = 0, AttributeTransform<int>? transform}) {
    return IntAttribute(key: key, provider: this, missValue: missValue, transform: transform);
  }

  IntOptional intOptional({required String key, AttributeTransform<int>? transform}) {
    return IntOptional(key: key, provider: this, transform: transform);
  }

  DoubleAttribute doubleAttribute({required String key, double missValue = 0, AttributeTransform<double>? transform}) {
    return DoubleAttribute(key: key, provider: this, missValue: missValue, transform: transform);
  }

  DoubleOptional doubleOptional({required String key, AttributeTransform<double>? transform}) {
    return DoubleOptional(key: key, provider: this, transform: transform);
  }

  BoolAttribute boolAttribute({required String key, bool missValue = false, AttributeTransform<bool>? transform}) {
    return BoolAttribute(key: key, provider: this, missValue: missValue, transform: transform);
  }

  BoolOptional boolOptional({required String key, AttributeTransform<bool>? transform}) {
    return BoolOptional(key: key, provider: this, transform: transform);
  }

  StringAttribute stringAttribute({required String key, String missValue = "", AttributeTransform<String>? transform}) {
    return StringAttribute(key: key, provider: this, missValue: missValue, transform: transform);
  }

  StringOptional stringOptional({required String key, AttributeTransform<String>? transform}) {
    return StringOptional(key: key, provider: this, transform: transform);
  }
}

class IntAttribute extends RequiredAttribute<int> {
  IntAttribute({required super.key, super.missValue = 0, required super.provider, super.transform});
}

class IntOptional extends OptionalAttribute<int> {
  IntOptional({required super.key, required super.provider, super.transform});
}

class DoubleAttribute extends RequiredAttribute<double> {
  DoubleAttribute({required super.key, super.missValue = 0, required super.provider, super.transform});
}

class DoubleOptional extends OptionalAttribute<double> {
  DoubleOptional({required super.key, required super.provider, super.transform});
}

class BoolAttribute extends RequiredAttribute<bool> {
  BoolAttribute({required super.key, super.missValue = false, required super.provider, super.transform});
}

class BoolOptional extends OptionalAttribute<bool> {
  BoolOptional({required super.key, required super.provider, super.transform});
}

class StringAttribute extends RequiredAttribute<String> {
  StringAttribute({required super.key, super.missValue = "", required super.provider, super.transform});
}

class StringOptional extends OptionalAttribute<String> {
  StringOptional({required super.key, required super.provider, super.transform});
}

class JsonValueAttribute extends JsonValueOptional with RequiredValue {
  @override
  final JsonValue missValue;

  JsonValueAttribute({required super.key, required this.missValue, required super.provider});
}

class JsonValueOptional extends OptionalAttribute<JsonValue> {
  JsonValueOptional({required super.key, required super.provider}) : super(transform: JsonValueTransform());
}

class ListIntAttribute extends ListIntOptional with RequiredValue {
  @override
  final List<int> missValue;

  ListIntAttribute({required super.key, required this.missValue, required super.provider});
}

class ListIntOptional extends OptionalAttribute<List<int>> {
  ListIntOptional({required super.key, required super.provider}) : super(transform: ListIntTransform());
}

class ListStringAttribute extends ListStringOptional with RequiredValue {
  @override
  final List<String> missValue;

  ListStringAttribute({required super.key, required this.missValue, required super.provider});
}

class ListStringOptional extends OptionalAttribute<List<String>> {
  ListStringOptional({required super.key, required super.provider}) : super(transform: ListStringTransform());
}
