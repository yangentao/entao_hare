part of 'basic.dart';

extension DoubleExts on double {
  //[start, end)
  double limitOpen(double start, double end, {required double step}) {
    if (this < start) return start;
    if (this >= end) {
      if (end - step < start) {
        return start;
      }
      return end - step;
    }
    return this;
  }
}

class IntPair<T> {
  final int first;
  final T second;

  const IntPair(this.first, this.second);
}

extension DateFormatEx on DateTime {
  String get dateString => "${this.year}-${month.pad2}-${day.pad2}";

  String get timeString => "${this.hour.pad2}-${minute.pad2}-${second.pad2}";

  String get dateTimeString => "$dateString $timeString";
}

extension IntCompare on int {
  String get pad2 => this < 10 ? "0$this" : "$this";

  String get pad3 => this < 10 ? "00$this" : (this < 100 ? "0$this" : "$this");

  String get pad4 => this >= 1000 ? "$this" : "0${this.pad3}";
}
