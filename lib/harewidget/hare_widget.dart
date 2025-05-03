part of 'harewidget.dart';

abstract class HareWidget extends StatefulWidget {
  final StateHolder holder = StateHolder();

  HareWidget() : super(key: UniqueKey());

  @override
  State<HareWidget> createState() {
    return HareWidgetState();
  }

  bool get mounted => holder.state?.mounted ?? false;

  BuildContext get context {
    if (holder.state != null) {
      return holder.state!.context;
    }
    error("widget state has not created");
  }

  void postCreate() {}

  void onCreate() {}

  void onDestroy() {}

  void onStateRemoved() {}

  void onStateUpdated(HareWidgetState newState) {}

  void reassemble() {}

  void postUpdate() {
    delayCall(0, () => updateState());
  }

  void updateState() => setState(() {});

  void setState(VoidCallback cb) => holder.state?._updateState(cb);

  void beforeBuild(BuildContext context) {}

  Widget build(BuildContext context);
}

// instance 0
// init 0
// instance 1
// deactive 0
// init 1
// dispose 0
class HareWidgetState extends State<HareWidget> {
  void _updateState(VoidCallback c) {
    if (mounted) {
      setState(c);
    }
  }

  void _checkCreate() {
    if (widget.holder.life != HareLife.created) {
      widget.holder.life = HareLife.created;
      widget.onCreate();
      delayCall(0, widget.postCreate);
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    widget.reassemble();
  }

  @override
  void initState() {
    widget.holder.state = this;
    super.initState();
    _checkCreate();
  }

  @override
  void activate() {
    widget.holder.state = this;
    super.activate();
    _checkCreate();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    if (identical(widget.holder.state, this)) {
      if (widget.holder.life != HareLife.destroyed) {
        widget.holder.life = HareLife.destroyed;
        widget.onDestroy();
      }
      widget.holder.state = null;
    }
  }

  @override
  void didUpdateWidget(covariant HareWidget oldWidget) {
    if (identical(oldWidget.holder.state, this)) {
      oldWidget.holder.state = null;
      oldWidget.onStateRemoved();
    }
    widget.holder.state = this;
    widget.onStateUpdated(this);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    widget.beforeBuild(context);
    return widget.build(context);
  }
}

class StateHolder {
  HareLife life = HareLife.inited;
  HareWidgetState? state;
  Map<String, Object> attrs = {};

  void put(String key, Object value) {
    attrs[key] = value;
  }

  T? get<T>(String key) {
    return attrs[key]?.castTo();
  }
}

enum HareLife {
  inited(0),
  created(1),
  destroyed(2),
  disposed(3);

  const HareLife(this.value);

  final int value;
}
