// ignore_for_file: must_be_immutable, non_constant_identifier_names
part of 'binder.dart';

class RadioGroupB extends HareWidget {
  int? _value;
  final Iterable<int> items;
  final OnLabel<int> onLabel;
  final Binder<int?>? _binder;

  int? get value => _binder?.value ?? _value;

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

  RadioGroupB({
    required this.items,
    required this.onLabel,
    int? value,
    Binder<int?>? binder,
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
  })  : _value = value,
        _binder = binder,
        _clipBehavior = clipBehavior,
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
        super() {
    assert(!(_binder != null && value != null));
  }

  Widget _buildItem(int v) {
    return RowMin([
      Radio(
        value: v,
        groupValue: value,
        onChanged: (b) {
          if (_binder == null) {
            _value = b;
            updateState();
          } else {
            _binder.value = b;
            _binder.fireChanged();
            updateState();
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
      onLabel(v).text()
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
        for (int v in items) _buildItem(v),
      ],
    );
  }
}
