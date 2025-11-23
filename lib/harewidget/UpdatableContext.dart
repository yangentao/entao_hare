part of 'harewidget.dart';

typedef UpdableBuilder = Widget Function(UpdatableContext);

class UpdatableContext {
  static const String _RESULT = "RESULT";
  final BuildContext context;
  final HareWidget _updatable;
  final Map<String, VoidCallback> _actionMap = {};
  BoolFunc onValidate = () => true;

  UpdatableContext({required this.context, required HareWidget updatable}) : _updatable = updatable;

  ThemeData get themeData => context.themeData;

  ColorScheme get colorScheme => context.themeData.colorScheme;

  void fireAction(String action) {
    _actionMap[action]?.call();
  }

  void onAction(String action, VoidCallback callback) {
    _actionMap[action] = callback;
  }

  void updateState() {
    _updatable.updateState();
  }

  void set(String key, dynamic value) {
    _updatable.holder.put(key, value);
  }

  T? get<T>(String key) {
    return _updatable.holder.get(key);
  }

  bool containsKey(String key) => _updatable.holder.containsKey(key);

  bool get hasResult => containsKey(_RESULT);

  T? getResult<T extends Object>() => get(_RESULT);

  void setResult<T extends Object>(T? value) => set(_RESULT, value);

  Future<bool> popResult<T extends Object>() {
    return Navigator.of(context).maybePop(getResult());
  }

  Future<bool> pop<T extends Object>([Object? result]) {
    return Navigator.of(context).maybePop(result);
  }
}
