import 'package:entao_hare/key_attr/key_attr.dart';
import 'package:println/println.dart';

void main() async {
  AttributeProvider p = MapAttributeProvider({});
  var n = p.require<int>(key: "age", missValue: 0);
  n.value = 99;
  println("99? ", n.value);

  var name = p.optional<String>(key: "name");
  println("name: ", name.value);
  name.value = "entao";
  println("name: ", name.value);

  var c = p.optional<List<int>>(key: "a", transform: ListIntTransform());
  c.value = [1, 2, 3];
  println(c.value);
}
