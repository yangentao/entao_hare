import 'dart:convert';

import 'package:entao_dutil/entao_dutil.dart';
import 'package:println/println.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'attribute.dart';
part 'attribute_extend.dart';
part 'transforms.dart';
part 'map_provider.dart';
part 'prefer_provider.dart';

abstract mixin class AttributeProvider {
  bool acceptValue(dynamic value);

  bool acceptType<CH>(XType<CH> chtype);

  bool hasAttribute(String key);

  Object? getAttribute(String key);

  void setAttribute(String key, Object? value);

  Object? removeAttribute(String key);
}

extension AttributeProviderExt on AttributeProvider {
  RequiredAttribute<T> require<T extends Object>({required String key, required T missValue, AttributeTransform<T>? transform}) {
    return RequiredAttribute<T>(key: key, provider: this, missValue: missValue, transform: transform);
  }

  OptionalAttribute<T> optional<T extends Object>({required String key, AttributeTransform<T>? transform}) {
    return OptionalAttribute<T>(key: key, provider: this, transform: transform);
  }
}

abstract mixin class AttributeTransform<T extends Object> {
  final XType<T> attributeType = XType();

  T fromRawAttribute(AttributeProvider provider, Object attr);

  Object toRawAtttribute(AttributeProvider provider, T value);
}

class XType<T> {
  Type get type => T;

  bool isSubtypeOf<SUPER>() {
    return this is XType<SUPER>;
  }

  bool isSuperOf<CHILD>(XType<CHILD> ch) => ch is XType<T>;

  bool acceptNull() => null is T;

  bool acceptInstance(dynamic inst) => inst is T;

  static final XType<String> typeString = XType();
  static final XType<bool> typeBool = XType();
  static final XType<int> typeInt = XType();
  static final XType<double> typeDouble = XType();
  static final XType<num> typeNum = XType();

  static final XType<List<String>> typeListString = XType();
  static final XType<List<bool>> typeListBool = XType();
  static final XType<List<int>> typeListInt = XType();
  static final XType<List<double>> typeListDouble = XType();
}

Never typeError(Type t, Object? value) {
  throw Exception("Type error, type=$t, value=$value ");
}
