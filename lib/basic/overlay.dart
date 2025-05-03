part of '../basic.dart';


class OverlayContext {
  final BuildContext context;
  final OverlayX entry;

  OverlayContext(this.context, this.entry);

  void remove() {
    entry.remove();
  }

  Future<void> removeDelay(int ms) {
    return entry.removeDelay(ms);
  }
}

typedef OverlayBuilder = Widget Function(OverlayContext);

enum OverlayXState {
  init,
  preShowing,
  showing,
  postRemove,
  removed;
}

class OverlayX {
  late final OverlayEntry _entry;
  final OverlayBuilder _builder;
  OverlayXState state = OverlayXState.init;

  OverlayX(this._builder, {bool opaque = false, bool maintainState = false, bool canSizeOverlay = false}) {
    _entry = OverlayEntry(builder: _builderOberlay, opaque: opaque, maintainState: maintainState, canSizeOverlay: canSizeOverlay);
  }

  Widget _builderOberlay(BuildContext context) {
    return _builder(OverlayContext(context, this));
  }

  void _asyncShow(BuildContext? context) {
    switch (state) {
      case OverlayXState.init:
        return;
      case OverlayXState.preShowing:
        state = OverlayXState.showing;
        OverlayState ov = Overlay.of(context ?? globalContext);
        ov.insert(_entry);
        return;
      case OverlayXState.showing:
        return;
      case OverlayXState.postRemove:
        state = OverlayXState.removed;
        return;
      case OverlayXState.removed:
        return;
    }
  }

  OverlayX show([BuildContext? context]) {
    switch (state) {
      case OverlayXState.init:
        state = OverlayXState.preShowing;
        delayMills(0, bindOne(context, _asyncShow));
        return this;
      case OverlayXState.preShowing:
        return this;
      case OverlayXState.showing:
        return this;
      case OverlayXState.postRemove:
        state = OverlayXState.removed;
        return this;
      case OverlayXState.removed:
        state = OverlayXState.init;
        delayMills(0, bindOne(context, _asyncShow));
        return this;
    }
  }

  void remove() {
    switch (state) {
      case OverlayXState.init:
        return;
      case OverlayXState.preShowing:
        state = OverlayXState.postRemove;
        return;
      case OverlayXState.showing:
        state = OverlayXState.removed;
        _entry.remove();
        return;
      case OverlayXState.postRemove:
        return;
      case OverlayXState.removed:
        return;
    }
  }

  Future<void> removeDelay(int ms) {
    return delayMills(ms, () {
      remove();
    });
  }

  void onRemoved(VoidCallback callback) {
    _entry.addListener(() {
      if (!_entry.mounted) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          callback();
        });
      }
    });
  }
}
