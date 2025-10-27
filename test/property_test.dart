import 'package:entao_hare/key_attr/key_attr.dart';
import 'package:println/println.dart';

void main() async {
  MapAttributeProvider<String> mp = MapAttributeProvider({});

  OptionalAttribute<List<int>> attr = mp.optional(key: "age ", transform: ListIntTransform());
  attr.value = [1, 2];
  println(attr.value);
  println(mp.map);
  attr.value = null;
  println(attr.value);
  println(mp.map);
}
