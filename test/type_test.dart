import 'package:println/println.dart';

void main() async {
  Apple a = Apple();
  a.hello();
}

class Fruit {
  void hello() {
    println("Fruit.hello()");
  }
}

class Apple extends Fruit with A, B {
  @override
  void hello() {
    super.hello();
    println("Apple.hello()");
  }
}

mixin A on Fruit {
  @override
  void hello() {
    super.hello();
    println("A.hello()");
  }
}

mixin B on Fruit {
  @override
  void hello() {
    super.hello();
    println("B.hello()");
  }
}
