part of '../basic.dart';

typedef TextValidator = FormFieldValidator<String>;

enum MatchType { None, Start, End, Contains, Entire }

TextValidator RegexValidator({required RegExp regex, MatchType matchType = MatchType.Entire, bool trim = false, bool allowEmpty = true, String message = "格式不符"}) {
  String? validator(String? text) {
    if (text == null || text.isEmpty) return allowEmpty ? null : message;
    String s = trim ? text.trim() : text;
    if (s.isEmpty) return allowEmpty ? null : message;
    RegExpMatch? m = regex.firstMatch(s);
    switch (matchType) {
      case MatchType.None:
        return m == null ? null : message;
      case MatchType.Start:
        return m?.start == 0 ? null : message;
      case MatchType.End:
        return m?.end == s.length ? null : message;
      case MatchType.Contains:
        return m != null ? null : message;
      case MatchType.Entire:
        return m?.start == 0 && m?.end == s.length ? null : message;
    }
  }

  return validator;
}

TextValidator ListValidator(List<TextValidator> list) {
  String? validator(String? text) {
    for (var f in list) {
      String? s = f(text);
      if (s != null) return s;
    }
    return null;
  }

  return validator;
}

TextValidator LengthValidator({int maxLength = 256, int minLength = 0, bool allowEmpty = true, bool trim = false, String? message}) {
  String msg = message ?? "长度介于$minLength和$maxLength之间";
  String? validator(String? text) {
    if (text == null || text.isEmpty) return allowEmpty ? null : msg;
    String s = trim ? text.trim() : text;
    if (s.length < minLength) return msg;
    if (s.length > maxLength) return msg;
    return null;
  }

  return validator;
}

TextValidator IntValidator({int? minValue, int? maxValue, bool allowEmpty = true, String? message}) {
  return NumValidator(minValue: minValue, maxValue: maxValue, allowEmpty: allowEmpty, message: message);
}

TextValidator DoubleValidator({double? minValue, double? maxValue, bool allowEmpty = true, String? message}) {
  return NumValidator(minValue: minValue, maxValue: maxValue, allowEmpty: allowEmpty, message: message);
}

TextValidator NumValidator({num? minValue, num? maxValue, bool allowEmpty = true, String? message}) {
  String msg;
  if (message != null) {
    msg = message;
  } else if (minValue != null && maxValue != null) {
    msg = "须介于$minValue和$maxValue之间";
  } else if (minValue != null) {
    msg = "须大于等于$minValue";
  } else if (maxValue != null) {
    msg = "须小于等于$maxValue";
  } else {
    msg = "请输入数字";
  }

  bool isReal = minValue is double || maxValue is double;

  String? validator(String? text) {
    if (text == null || text.isEmpty) return allowEmpty ? null : msg;
    String s = text.trim();
    if (!allowEmpty && s.isEmpty) return msg;
    num? v = isReal ? s.toDouble : s.toInt;
    if (v == null) return msg;
    if (minValue != null && v < minValue) return msg;
    if (maxValue != null && v > maxValue) return msg;
    return null;
  }

  return validator;
}

TextValidator NotEmptyValidator({bool trim = true, String message = "不可为空"}) {
  String? validator(String? text) {
    String? s = trim ? text?.trim() : text;
    if (s == null || s.isEmpty) return message;
    return null;
  }

  return validator;
}
