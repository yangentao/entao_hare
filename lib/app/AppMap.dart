part of '../entao_app.dart';

class AppMap {
  static PropMap appMap = {};

  AppMap._();

  static AnyProp<T> propAny<T extends Object>(String key, {T? missValue}) {
    return AnyProp<T>(map: appMap, key: key, missValue: missValue);
  }

  static SomeProp<T> propSome<T extends Object>(String key, {required T missValue}) {
    return SomeProp<T>(map: appMap, key: key, missValue: missValue);
  }

  static String? getString(String key) {
    return appMap[key] as String;
  }

  static void putString(String key, String value) {
    appMap[key] = value;
  }

  static int? getInt(String key) {
    return appMap[key] as int;
  }

  static void putInt(String key, int value) {
    appMap[key] = value;
  }

  static double? getDouble(String key) {
    return appMap[key] as double;
  }

  static void putDouble(String key, double value) {
    appMap[key] = value;
  }

  static void remove(String key) {
    appMap.remove(key);
  }
}
