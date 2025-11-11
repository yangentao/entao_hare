part of 'basic.dart';

class ValueListener<T extends Object> {
  T value;
  final bool allowEqual;
  final Predicate<T>? acceptor;
  final VoidCallback? afterChanged;
  final VoidCallback? after;
  final OnValue<T>? afterValue;
  final Predicate<T>? delegate;

  ValueListener({required this.value, this.allowEqual = false, this.acceptor, this.afterChanged, this.after, this.afterValue, this.delegate});

  void onChanged(T newValue) {
    if (delegate != null) {
      if (delegate?.call(newValue) == true) {
        value = newValue;
      }
      return;
    }
    if (!allowEqual && value == newValue) return;
    if (acceptor?.call(newValue) == false) return;
    this.value = newValue;
    afterValue?.call(newValue);
    afterChanged?.call();
    after?.call();
  }
}

class OptionalValueListener<T> {
  T? value;
  final bool allowEqual;
  final bool nullable;
  final Predicate<T?>? acceptor;
  final VoidCallback? after;
  final OnValue<T?>? afterValue;
  final Predicate<T?>? delegate;

  T get valueRequired => value!;

  OptionalValueListener({this.value, this.allowEqual = false, this.nullable = false, this.acceptor, this.after, this.afterValue, this.delegate});

  void onChanged(T? newValue) {
    if (delegate != null) {
      if (delegate?.call(newValue) == true) {
        value = newValue;
      }
      return;
    }
    if (!nullable && newValue == null) return;
    if (!allowEqual && value == newValue) return;
    if (acceptor?.call(newValue) == false) return;
    this.value = newValue;
    afterValue?.call(newValue);
    after?.call();
  }
}
