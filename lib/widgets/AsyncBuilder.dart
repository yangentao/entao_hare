part of 'widgets.dart';

Widget AsyncBuilder<T>({
  required Future<T> future,
  required Widget Function(BuildContext, T) builder,
  Widget Function(BuildContext)? waiting,
  Widget Function(BuildContext)? failed,
  T? initValue,
}) {
  return FutureBuilder<T>(
    future: future,
    initialData: initValue,
    builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting || ConnectionState.none || ConnectionState.active:
          return waiting?.call(context) ?? CircularProgressIndicator().centered();
        case ConnectionState.done:
          if (snapshot.hasData) {
            return builder(context, snapshot.requireData);
          } else {
            return failed?.call(context) ?? Icons.error_outline.icon(color: Colors.orangeAccent).centered();
          }
      }
    },
  );
}

class AsyncWidget<T extends Object> extends HareWidget {
  AsyncWidgetState state = AsyncWidgetState.waiting;
  FutureOr<T?> future;
  Widget Function(BuildContext)? waiting;
  Widget Function(BuildContext)? failed;
  Widget Function(BuildContext, T) builder;
  T? _value;
  T? defaultValue;

  // ignore: use_key_in_widget_constructors
  AsyncWidget({required this.future, required this.builder, this.waiting, this.failed, this.defaultValue}) {
    _queryValue();
  }

  Future<void> _queryValue() async {
    T? newValue;
    try {
      FutureOr<T?> f = future;
      if (f is Future<T?>) {
        newValue = await f;
      } else {
        newValue = f;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      _value = newValue;
      state = newValue == null ? AsyncWidgetState.failed : AsyncWidgetState.success;
      postFrame(() {
        updateState();
      });
    }
  }

  Widget _buildWaiting(BuildContext context) {
    return waiting?.call(context) ?? CircularProgressIndicator().centered();
    // return waiting?.call(context) ?? Container();
  }

  Widget _buildFailed(BuildContext context) {
    return failed?.call(context) ?? Icons.error_outline.icon(color: Colors.orangeAccent).centered();
    // return failed?.call(context) ?? Container();
  }

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case AsyncWidgetState.waiting:
        if (defaultValue != null) return builder(context, defaultValue!);
        return _buildWaiting(context);
      case AsyncWidgetState.failed:
        if (defaultValue != null) return builder(context, defaultValue!);
        return _buildFailed(context);
      case AsyncWidgetState.success:
        return builder(context, _value!);
    }
  }
}

enum AsyncWidgetState { waiting, success, failed }
