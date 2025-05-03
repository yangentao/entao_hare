part of '../fhare.dart';

typedef TextValidator = String? Function(String?);

class Valids {
  Valids._();

  static TextValidator regex(RegExp regex, {MatchType matchType = MatchType.Entire, bool trim = false, bool allowEmpty = false, String message = "格式不符"}) {
    return RegexValidator(regex: regex, matchType: matchType, trim: trim, allowEmpty: allowEmpty, message: message).call;
  }

  static TextValidator length(int minLength, int maxLength, {bool allowEmpty = false, bool trim = false, String? message}) {
    return LengthValidator(minLength: minLength, maxLength: maxLength, allowEmpty: allowEmpty, trim: trim, message: message).call;
  }

  static TextValidator notEmpty({bool trim = true, String message = "不可为空"}) {
    return NotEmptyValidator(trim: trim, message: message).call;
  }

  static TextValidator number(num minValue, num maxValue, {bool allowEmpty = false, String? message}) {
    return NumValidator(minValue: minValue, maxValue: maxValue, allowEmpty: allowEmpty, message: message).call;
  }

  static TextValidator list(List<TextValidator> list) {
    return ValidatorList(list).call;
  }
}

class ValidatorList {
  List<TextValidator> list;

  ValidatorList([List<TextValidator>? vs]) : list = vs ?? [];

  String? call(String? text) {
    for (var f in list) {
      String? err = f.call(text);
      if (err != null) return err;
    }
    return null;
  }
}

class NumValidator {
  final bool allowEmpty;
  final num? minValue;
  final num? maxValue;
  late String message;

  NumValidator({required this.minValue, required this.maxValue, this.allowEmpty = false, String? message}) {
    if (message != null) {
      this.message = message;
    } else if (minValue != null && maxValue != null) {
      this.message = "须介于$minValue和$maxValue之间";
    } else if (minValue != null) {
      this.message = "须大于等于$minValue";
    } else if (maxValue != null) {
      this.message = "须小于等于$maxValue";
    } else {
      this.message = "请输入数字";
    }
  }

  bool get isReal => minValue is double || maxValue is double;

  String? call(String? text) {
    if (text == null) return allowEmpty ? null : message;
    String s = text.trim();
    if (!allowEmpty && s.isEmpty) return message;
    num? v = isReal ? s.toDouble : s.toInt;
    if (v == null) return message;
    if (minValue != null && v < minValue!) return message;
    if (maxValue != null && v > maxValue!) return message;
    return null;
  }
}

class NotEmptyValidator {
  final bool trim;
  final String message;

  NotEmptyValidator({this.trim = true, this.message = "不可为空"});

  String? call(String? text) {
    if (text == null) return message;
    String s = trim ? text.trim() : text;
    if (s.isEmpty) return message;
    return null;
  }
}

class LengthValidator {
  final bool allowEmpty;
  final bool trim;
  final int minLength;
  final int maxLength;
  late String message;

  LengthValidator({required this.minLength, required this.maxLength, this.allowEmpty = false, this.trim = false, String? message}) {
    if (message != null) {
      this.message = message;
    } else {
      this.message = "长度介于$minLength和$maxLength之间";
    }
  }

  String? call(String? text) {
    if (text == null || text.isEmpty) return allowEmpty ? null : message;
    String s = trim ? text.trim() : text;
    if (s.length < minLength) return message;
    if (s.length > maxLength) return message;
    return null;
  }
}

enum MatchType {
  None,
  Start,
  End,
  Contains,
  Entire;
}

class RegexValidator {
  final bool trim;
  final bool allowEmpty;
  final RegExp regex;
  final MatchType matchType;
  late String message;

  RegexValidator({required this.regex, this.matchType = MatchType.Entire, this.trim = false, this.allowEmpty = false, this.message = "格式不符"});

  String? call(String? text) {
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
}
