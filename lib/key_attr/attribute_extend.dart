part of 'key_attr.dart';

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
