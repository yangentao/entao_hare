part of '../entao_hare.dart';

extension HarePageAttrEx on HarePage {
  AnyProp<T> pageProp<T extends  Object>(String name, {T? missValue}) {
    return AnyProp<T>(map: this.holder.attrs, key: name, missValue: missValue);
  }
}

extension HareWidgetAttrEx on HareWidget {
  AnyProp<T> widgetProp<T  extends  Object>(String name, {T? missValue}) {
    return AnyProp<T>(map: this.holder.attrs, key: name, missValue: missValue);
  }
}
