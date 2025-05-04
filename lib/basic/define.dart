part of 'basic.dart';

typedef ListWidget = List<Widget>;
typedef OnChildren<T> = List<T> Function(T value);
typedef OnWidget<T> = Widget Function(T value);
typedef OnItemView<T> = Widget Function(T value);
typedef OnWidgetOpt<T> = Widget? Function(T value);
typedef TypeWidgetBuilder<T> = T Function(BuildContext context);
