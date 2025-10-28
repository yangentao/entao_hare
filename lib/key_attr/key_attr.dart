import 'dart:convert';

import 'package:entao_dutil/entao_dutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'attribute.dart';
part 'attribute_extend.dart';
part 'map_provider.dart';
part 'prefer_provider.dart';
part 'transforms.dart';

abstract mixin class AttributeProvider {
  bool acceptValue(Object? value);

  bool acceptType<CH>(DType<CH> chtype);

  bool hasAttribute(String key);

  Object? getAttribute(String key);

  void setAttribute(String key, Object? value);

  Object? removeAttribute(String key);
}



abstract mixin class AttributeTransform<T extends Object> {
  final DType<T> attributeType = DType();

  T fromRawAttribute(AttributeProvider provider, Object attr);

  Object toRawAtttribute(AttributeProvider provider, T value);
}

class DType<T> {
  Type get type => T;

  bool isSubtypeOf<SUPER>() {
    return this is DType<SUPER>;
  }

  bool isSuperOf<CHILD>(DType<CHILD> ch) => ch is DType<T>;

  bool acceptNull() => null is T;

  bool acceptInstance(Object? inst) => inst is T;

  static final DType<String> typeString = DType();
  static final DType<bool> typeBool = DType();
  static final DType<int> typeInt = DType();
  static final DType<double> typeDouble = DType();
  static final DType<num> typeNum = DType();

  static final DType<List<String>> typeListString = DType();
  static final DType<List<bool>> typeListBool = DType();
  static final DType<List<int>> typeListInt = DType();
  static final DType<List<double>> typeListDouble = DType();
}

Never typeError(Type t, Object? value) {
  throw Exception("Type error, type=$t, value=$value ");
}
