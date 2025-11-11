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

  Future<bool> maybePop<T extends Object>([T? result]) {
    return Navigator.of(context).maybePop(result);
  }

  void set(String key, dynamic value) {
    updatable.holder.put(key, value);
  }

  T? get<T>(String key) {
    return updatable.holder.get(key);
  }

  T? getResult<T extends Object>() => get(RESULT);

  void setResult<T extends Object>(T? value) => set(RESULT, value);

  Future<bool> popResult<T extends Object>() {
    return Navigator.of(context).maybePop(getResult());
  }
}
