part of 'basic.dart';

int makeShort({required int low, required int hight}) {
  return ((hight & 0xFF) << 8) | (low & 0xFF);
}

extension SetIntExt on Set<int> {
  int joinBits() {
    return this.fold(0, (p, e) => p | e);
  }
}

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

//bitPack([1,1,0,0, 0,0,0,0]) => [0x03]
List<int> packBits(List<int> values, {bool lowFirst = true}) {
  List<int> results = [];
  int a = 0;
  for (int i = 0; i < values.length; ++i) {
    int m = i % 8;
    if (m == 0) {
      a = values[i];
    } else {
      a = a | (values[i] << m);
    }
    if (m == 7 || i == values.length - 1) {
      results.add(a);
    }
  }
  return results;
}

//bitValues([0x03]) => [1100 0000]
List<int> expandBits(List<int> bytes, {bool lowFirst = true}) {
  List<int> results = List<int>.filled(bytes.length * 8, 0);
  for (int i = 0; i < bytes.length; ++i) {
    for (int k = 0; k < 8; ++k) {
      if (lowFirst) {
        results[i * 8 + k] = ((bytes[i] >> k) & 0x01);
      } else {
        results[i * 8 + k] = ((bytes[i] >> (7 - k)) & 0x01);
      }
    }
  }
  return results;
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

extension IntExts on int {
  // 返回 0 或 1
  int bitGet(int bit) {
    return ((1 << bit) & this) == 0 ? 0 : 1;
  }

  int bitSet1(int bit) {
    return this | (1 << bit);
  }

  int bitSet0(int bit) {
    return this & ~(1 << bit);
  }

  int bitSet01(int bit, int value) {
    assert(value == 0 || value == 1);
    if (value == 0) {
      return bitSet0(bit);
    } else {
      return bitSet1(bit);
    }
  }

  int get low0 => this & 0xff;

  int get low1 => (this >> 8) & 0xff;

  int get low2 => (this >> 16) & 0xff;

  int get low3 => (this >> 24) & 0xff;

  bool hasAllBit(int b) {
    return this & b == b;
  }

  bool hasAnyBit(int b) {
    return this & b != 0;
  }
}
