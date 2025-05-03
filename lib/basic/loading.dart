part of '../basic.dart';

class LoadingItem {
  String? text;
  OverlayX? _overlay;

  LoadingItem({this.text});

  Widget _defaultWidget() {
    return ColumnMin(
      [
        CircularProgressIndicator(
          backgroundColor: Colors.grey.withOpacityX(0.3),
          strokeCap: StrokeCap.round,
          strokeWidth: 3,
        ),
        space(height: 8),
        (this.text ?? Loading.textLoading).text(color: Colors.blueAccent, fontSize: 12, softWrap: false, overflow: TextOverflow.fade),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ).paddings(top: 12, bottom: 6).aspectRatio(1.2).sizedBox(height: 90).roundRect(fillColor: Colors.black.withOpacityX(0.15)).align(Alignment.center);
  }

  void show({Widget? widget}) {
    if (_overlay != null) {
      OverlayX ox = _overlay!;
      ox.onRemoved(() {
        _overlay = null;
        show(widget: widget);
      });
      _overlay?.remove();
    } else {
      OverlayX ox = OverlayX((c) => widget ?? _defaultWidget());
      ox.show();
      _overlay = ox;
      ox.onRemoved(() {
        _overlay = null;
      });
    }
  }

  void hide() {
    _overlay?.removeDelay(0);
    _overlay = null;
  }
}

class Loading {
  Loading._();

  static String textLoading = "加载中";
  static final Map<String, LoadingItem> _map = {};

  static Future<void> loading(AsyncCallback callback, {Widget? widget, String? text}) async {
    LoadingItem item = LoadingItem(text: text ?? textLoading);
    item.show(widget: widget);
    try {
      await callback();
    } finally {
      item.hide();
    }
  }

  static void show(String key, {Widget? widget, String? text}) {
    _map.remove(key)?.hide();
    LoadingItem item = LoadingItem(text: text);
    item.show(widget: widget);
    _map[key] = item;
  }

  static void hide(String key) {
    _map.remove(key)?.hide();
  }
}
