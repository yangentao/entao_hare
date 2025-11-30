part of 'basic.dart';

extension ScrollViewLoadingEx on ScrollView {
  ScrollLoading scrollLoading({
    FutureOr<void> Function()? onTopStart,
    VoidCallback? onTopEnd,
    WidgetBuilder? topIndicator,
    FutureOr<void> Function()? onBottomStart,
    VoidCallback? onBottomEnd,
    WidgetBuilder? bottomIndicator,
  }) {
    return ScrollLoading(
      child: this,
      onTopStart: onTopStart,
      onTopEnd: onTopEnd,
      topIndicator: topIndicator,
      onBottomStart: onBottomStart,
      onBottomEnd: onBottomEnd,
      bottomIndicator: bottomIndicator,
    );
  }
}

class ScrollLoading extends HareWidget {
  static final int _N = 10;
  static final int _DELAY = 300;
  static const Widget indicator = Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: SizedBox(child: CircularProgressIndicator(), width: 32, height: 32),
  );

  final Widget child;
  final FutureOr<void> Function()? onTopStart;
  final VoidCallback? onTopEnd;
  final WidgetBuilder? topIndicator;
  final FutureOr<void> Function()? onBottomStart;
  final VoidCallback? onBottomEnd;
  final WidgetBuilder? bottomIndicator;

  final LimitList<({int st, int tm})> _history = LimitList(30);

  // 0: in range;  <0: above;  >0:below
  int _state = 0;
  bool _topFinish = false;
  bool _bottomFinish = false;

  // ignore: use_key_in_widget_constructors
  ScrollLoading({required this.child, this.onTopStart, this.onTopEnd, this.topIndicator, this.onBottomStart, this.onBottomEnd, this.bottomIndicator});

  Widget? _topWidget(BuildContext context) {
    if (_state == -1 && !_topFinish && onTopStart != null) {
      return topIndicator?.call(context) ?? indicator;
    }
    return null;
  }

  Widget? _bottomWidget(BuildContext context) {
    if (_state == 1 && !_bottomFinish && onBottomStart != null) {
      return bottomIndicator?.call(context) ?? indicator;
    }
    return null;
  }

  void _topClear() {
    _topFinish = true;
    updateState();
  }

  void _bottomClear() {
    _bottomFinish = true;
    updateState();
  }

  void _topStart() {
    _topFinish = false;
    updateState();
    if (onTopStart != null) {
      var r = onTopStart!();
      if (r is Future<void>) {
        r.whenComplete(_topClear);
      } else {
        _topClear();
      }
    }
  }

  void _topEnd() {
    onTopEnd?.call();
    if (onTopStart == null) {
      _topClear();
    }
  }

  void _topUpdate(double value) {}

  void _bottomStart() {
    _bottomFinish = false;
    updateState();
    if (onBottomStart != null) {
      var r = onBottomStart!();
      if (r is Future<void>) {
        r.whenComplete(_bottomClear);
      } else {
        _bottomClear();
      }
    }
  }

  void _bottomEnd() {
    onBottomEnd?.call();
    if (onBottomStart == null) {
      _bottomClear();
    }
  }

  void _bottomUpdate(double value) {}

  void _checkExpire() {
    int t = DateTime.now().millisecondsSinceEpoch;
    _history.removeAll((e) => e.tm + _DELAY < t);
    if (_history.isNotEmpty) return;
    switch (_state) {
      case 0:
        break;
      case 1:
        _state = 0;
        _bottomEnd();
      case -1:
        _state = 0;
        _topEnd();
    }
  }

  void _changeState(int state, double value) {
    _history.add((st: state, tm: DateTime.now().millisecondsSinceEpoch));
    mergeCall(this, _checkExpire, delay: _DELAY);
    switch (_state) {
      case 0:
        if (_history.backCount((e) => e.st < 0) >= _N) {
          _state = -1;
          _topStart();
        } else if (_history.backCount((e) => e.st > 0) >= _N) {
          _state = 1;
          _bottomStart();
        }
      case 1:
        _state = state;
        switch (state) {
          case 1:
            _bottomUpdate(value);
          case 0:
            _bottomEnd();
          case -1:
            _bottomEnd();
            _topStart();
        }
      case -1:
        _state = state;
        switch (state) {
          case -1:
            _topUpdate(value);
          case 0:
            _topEnd();
          case 1:
            _topEnd();
            _bottomStart();
        }
    }
  }

  bool _onScrollNotify(ScrollNotification sn) {
    if (sn.depth != 0) return true;
    ScrollMetrics m = sn.metrics;
    if (m.pixels <= m.minScrollExtent) {
      _changeState(-1, m.minScrollExtent - m.pixels);
    } else if (m.pixels >= m.maxScrollExtent) {
      _changeState(1, m.pixels - m.maxScrollExtent);
    } else {
      _changeState(0, 0);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      child: Stack(children: [child.positionedFill(), ?_topWidget(context)?.align(.topCenter), ?_bottomWidget(context)?.align(.bottomCenter)]),
      onNotification: _onScrollNotify,
    );
  }
}
