import 'package:entao_hare/app/prefer/prefer.dart';
import 'package:println/println.dart';

void main() async {
  AttributeProvider p = MapAttributeProvider();
  // AttributeProvider.globalProvider = MapAttributeProvider();
  IntAttribute n = IntAttribute(key: "age", missValue: 0, provider: p);
  n.value = 99;
  println("99? ", n.value);

  StringOptionalAttribute name = StringOptionalAttribute(key: "name", provider: p);
  println("name: ", name.value);
  name.value = "entao";
  println("name: ", name.value);
}

class ListIntPrefer extends OptionalAttribute<List<int>>{
  ListIntPrefer({required super.key});

}

