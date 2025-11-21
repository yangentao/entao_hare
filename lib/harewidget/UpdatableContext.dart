part of 'harewidget.dart';

typedef UpdableBuilder = Widget Function(UpdatableContext);

class UpdatableContext {
  static const String RESULT = "RESULT";
  final BuildContext context;
  final HareWidget updatable;
  BoolFunc onValidate = () => true;

  UpdatableContext({required this.context, required this.updatable});

  ThemeData get themeData => context.themeData;

  ColorScheme get colorScheme => context.themeData.colorScheme;

  void updateState() {
    updatable.updateState();
  }

  void set(String key, dynamic value) {
    updatable.holder.put(key, value);
  }

  T? get<T>(String key) {
    return updatable.holder.get(key);
  }

  bool has(String key) => updatable.holder.containsKey(key);

  bool get hasResult => has(RESULT);

  T? getResult<T extends Object>() => get(RESULT);

  void setResult<T extends Object>(T? value) => set(RESULT, value);

  Future<bool> popResult<T extends Object>() {
    return Navigator.of(context).maybePop(getResult());
  }

  Future<bool> pop<T extends Object>([Object? result]) {
    return Navigator.of(context).maybePop(result);
  }
}
