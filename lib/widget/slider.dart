part of '../entao_hare.dart';

//step = (max - min)/divisions
class HareSlider extends HareWidget {
  double value;
  double? secondaryTrackValue;
  OnValue<double>? onChanged;
  OnValue<double>? onChangeStart;
  OnValue<double>? onChangeEnd;
  double min;
  double max;
  int? divisions;
  String? label;
  OnLabel<double>? labelBuilder;
  bool autoLabel;
  Color? activeColor;
  Color? inactiveColor;
  Color? secondaryActiveColor;
  Color? thumbColor;
  WidgetStateProperty<Color?>? overlayColor;
  MouseCursor? mouseCursor;
  String Function(double)? semanticFormatterCallback;
  FocusNode? focusNode;
  bool autofocus;

  SliderInteraction? allowedInteraction;

  HareSlider({
    required this.value,
    this.secondaryTrackValue,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.autoLabel = true,
    this.labelBuilder,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.thumbColor,
    this.overlayColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
    this.allowedInteraction,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      onChanged: (v) {
        this.value = v;
        onChanged?.call(v);
        updateState();
      },
      secondaryTrackValue: secondaryTrackValue,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      divisions: divisions,
      label: labelBuilder?.call(value) ?? label ?? (autoLabel ? value.toString() : null),
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      secondaryActiveColor: secondaryActiveColor,
      thumbColor: thumbColor,
      overlayColor: overlayColor,
      mouseCursor: mouseCursor,
      semanticFormatterCallback: semanticFormatterCallback,
      focusNode: focusNode,
      autofocus: autofocus,
      allowedInteraction: allowedInteraction,
    );
  }
}

//step = (max - min)/divisions
class HareSliderInt extends HareWidget {
  int value;
  int? secondaryTrackValue;
  OnValue<int>? onChanged;
  OnValue<int>? onChangeStart;
  OnValue<int>? onChangeEnd;
  int min;
  int max;
  int divisions;
  String? label;
  OnLabel<int>? labelBuilder;
  bool autoLabel;
  Color? activeColor;
  Color? inactiveColor;
  Color? secondaryActiveColor;
  Color? thumbColor;
  WidgetStateProperty<Color?>? overlayColor;
  MouseCursor? mouseCursor;
  String Function(int)? semanticFormatterCallback;
  FocusNode? focusNode;
  bool autofocus;

  SliderInteraction? allowedInteraction;

  HareSliderInt({
    required this.value,
    this.secondaryTrackValue,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0,
    this.max = 100,
    int? divisions,
    this.label,
    this.autoLabel = true,
    this.labelBuilder,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.thumbColor,
    this.overlayColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
    this.allowedInteraction,
  })  : this.divisions = divisions ?? (max - min),
        super();

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value.toDouble(),
      onChanged: (v) {
        this.value = v.round();
        onChanged?.call(this.value);
        updateState();
      },
      secondaryTrackValue: secondaryTrackValue?.toDouble(),
      onChangeStart: onChangeStart == null ? null : (v) => onChangeStart?.call(v.toInt()),
      onChangeEnd: onChangeEnd == null ? null : (v) => onChangeEnd?.call(v.toInt()),
      min: min.toDouble(),
      max: max.toDouble(),
      divisions: divisions,
      label: labelBuilder?.call(value) ?? label ?? (autoLabel ? value.toString() : null),
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      secondaryActiveColor: secondaryActiveColor,
      thumbColor: thumbColor,
      overlayColor: overlayColor,
      mouseCursor: mouseCursor,
      semanticFormatterCallback: semanticFormatterCallback == null ? null : (v) => semanticFormatterCallback!.call(v.toInt()),
      focusNode: focusNode,
      autofocus: autofocus,
      allowedInteraction: allowedInteraction,
    );
  }
}
