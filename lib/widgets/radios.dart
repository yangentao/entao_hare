part of 'widgets.dart';

class RadioGroupX<T> extends HareWidget {
  final Iterable<LabelValue<T>> items;
  final NotifyValue<T> notifyValue;

  final OnValue<T>? onChange;

  T get value => notifyValue.value;

  //wrap
  final Axis _direction;
  final WrapAlignment _alignment;
  final WrapAlignment _runAlignment;
  final double _spacing;
  final double _runSpacing;
  final WrapCrossAlignment _crossAxisAlignment;
  final TextDirection? _textDirection;
  final VerticalDirection _verticalDirection;
  final Clip _clipBehavior;

  //radio
  final MouseCursor? _mouseCursor;
  final bool _toggleable;
  final Color? _activeColor;
  final WidgetStateProperty<Color?>? _fillColor;
  final Color? _focusColor;
  final Color? _hoverColor;
  final WidgetStateProperty<Color?>? _overlayColor;
  final double? _splashRadius;
  final MaterialTapTargetSize? _materialTapTargetSize;
  final VisualDensity? _visualDensity;
  final FocusNode? _focusNode;
  final bool _autofocus;

  RadioGroupX({
    required this.items,
    T? value,
    this.onChange,
    NotifyValue<T>? notifyValue,
    // this.notifier,
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    WrapAlignment runAlignment = WrapAlignment.start,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
    double spacing = 0,
    double runSpacing = 0,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    Clip clipBehavior = Clip.none,
    MouseCursor? mouseCursor,
    bool toggleable = false,
    Color? activeColor,
    WidgetStateProperty<Color?>? fillColor,
    Color? focusColor,
    Color? hoverColor,
    WidgetStateProperty<Color?>? overlayColor,
    double? splashRadius,
    MaterialTapTargetSize? materialTapTargetSize,
    VisualDensity? visualDensity,
    FocusNode? focusNode,
    bool autofocus = false,
  })  : _clipBehavior = clipBehavior,
        _verticalDirection = verticalDirection,
        _textDirection = textDirection,
        _crossAxisAlignment = crossAxisAlignment,
        _spacing = spacing,
        _runSpacing = runSpacing,
        _runAlignment = runAlignment,
        _alignment = alignment,
        _direction = direction,
        _autofocus = autofocus,
        _focusNode = focusNode,
        _visualDensity = visualDensity,
        _materialTapTargetSize = materialTapTargetSize,
        _splashRadius = splashRadius,
        _overlayColor = overlayColor,
        _hoverColor = hoverColor,
        _focusColor = focusColor,
        _fillColor = fillColor,
        _activeColor = activeColor,
        _toggleable = toggleable,
        _mouseCursor = mouseCursor,
        assert(notifyValue != null || value != null),
        this.notifyValue = notifyValue ?? NotifyValue(value: value as T),
        super() {
    this.notifyValue.add(this._onChangedOut);
  }

  void _onChangedOut() {
    updateState();
  }

  Widget _buildItem(LabelValue<T> item) {
    return RowMin([
      Radio<T>(
        value: item.value,
        groupValue: value,
        onChanged: (b) {
          if (b != null) {
            notifyValue.value = b;
            updateState();
            onChange?.call(b);
            notifyValue.fire(except: _onChangedOut);
          }
        },
        mouseCursor: _mouseCursor,
        toggleable: _toggleable,
        activeColor: _activeColor,
        fillColor: _fillColor,
        focusColor: _focusColor,
        hoverColor: _hoverColor,
        overlayColor: _overlayColor,
        splashRadius: _splashRadius,
        materialTapTargetSize: _materialTapTargetSize,
        visualDensity: _visualDensity,
        focusNode: _focusNode,
        autofocus: _autofocus,
      ),
      space(width: 4),
      item.label.text()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: _spacing,
      runSpacing: _runSpacing,
      alignment: _alignment,
      runAlignment: _runAlignment,
      crossAxisAlignment: _crossAxisAlignment,
      verticalDirection: _verticalDirection,
      direction: _direction,
      textDirection: _textDirection,
      clipBehavior: _clipBehavior,
      children: [
        for (var v in items) _buildItem(v),
      ],
    );
  }
}
