part of 'basic.dart';

ThemeData get globalTheme => globalContext.themeData;

BuildContext get globalContext {
  return onGlobalContext();
}

late RFunc<BuildContext> onGlobalContext;

void postFrame(VoidFunc callback) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}

class ContextIndex {
  BuildContext context;
  int index;

  ContextIndex(this.context, this.index);
}

class ContextIndexItem<T> extends ContextIndex {
  T item;

  ContextIndexItem(super.context, super.index, this.item);

  static NullableIndexedWidgetBuilder nullableIndexBuilder<V>(List<V> items, Widget Function(ContextIndexItem<V>) itemBuilder) {
    Widget? builder(BuildContext context, int index) {
      if (index >= items.length) return null;
      ContextIndexItem<V> cii = ContextIndexItem(context, index, items[index]);
      return itemBuilder(cii);
    }

    return builder;
  }

  static IndexedWidgetBuilder indexBuilder<V>(List<V> items, Widget Function(ContextIndexItem<V>) itemBuilder) {
    Widget builder(BuildContext context, int index) {
      ContextIndexItem<V> cii = ContextIndexItem(context, index, items[index]);
      return itemBuilder(cii);
    }

    return builder;
  }
}

extension ContextExt on BuildContext {
  void showBottomModal(List<Widget> children, {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) {
    showModalBottomSheet(
      context: this,
      builder: (c) {
        return ColumnMin(children, crossAxisAlignment: crossAxisAlignment);
      },
    );
  }

  NavigatorState get navigator {
    return Navigator.of(this);
  }

  Future<T?> replacePage<T extends Object>(Widget page) {
    return Navigator.of(this).pushReplacement(MaterialPageRoute(builder: (context) => page));
  }

  Future<T?> pushPage<T extends Object>(Widget page) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (context) => page));
  }

  void popPage<T extends Object>([T? result]) {
    Navigator.of(this).pop(result);
  }

  Future<bool> maybePop<T extends Object>([T? result]) {
    return Navigator.of(this).maybePop(result);
  }

  MediaQueryData get mediaData => MediaQuery.of(this);

  ThemeData get themeData => Theme.of(this);

  bool get isDark => this.themeData.brightness == Brightness.dark;

  bool get isLight => this.themeData.brightness == Brightness.light;

  bool get largeScreen => mediaData.size.width > 600;

  Color get grayFill {
    return this.isDark ? Colors.grey[700]! : Colors.grey[400]!;
  }
}

extension StateUtilsEx<T extends StatefulWidget> on State<T> {
  void unfocus() {
    FocusScope.of(this.context).unfocus();
  }

  MediaQueryData get mediaData => MediaQuery.of(context);

  ThemeData get themeData => Theme.of(context);
}
