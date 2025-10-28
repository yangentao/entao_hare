// ignore_for_file: must_be_immutable
part of 'widgets.dart';

class EditText extends HareWidget {
  final TextEditingController controller;
  final String? label;
  final int minLength;
  final int maxLength;
  final bool allowEmpty;
  final FuncString? onSubmitted;
  final Widget? prefixIcon;
  final String? helperText;
  final String? errorText;
  final bool clear;
  final Widget? suffixIcon;
  final String? initialValue;
  final Color? cursorColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode focusNode;
  final TextAlign textAlign;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final InputDecoration? decoration;
  final void Function(String)? onChanged;
  final void Function(PointerDownEvent)? onTapOutside;

  String get value => controller.text;

  EditText({
    TextEditingController? controller,
    this.initialValue,
    this.label,
    FocusNode? focusNode,
    this.minLength = 1,
    this.maxLength = 256,
    this.allowEmpty = false,
    this.cursorColor = Colors.deepOrange,
    this.prefixIcon,
    this.helperText,
    this.errorText,
    this.onSubmitted,
    this.clear = true,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.decoration,
    this.onChanged,
    this.onTapOutside,
  }) : controller = controller ?? TextEditingController(),
       focusNode = focusNode ?? FocusNode(),
       super() {
    if (this.initialValue != null && this.initialValue!.isNotEmpty) {
      this.controller.text = this.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      controller: controller,
      focusNode: focusNode,
      cursorColor: cursorColor,
      maxLength: maxLength,
      onFieldSubmitted: (s) => onSubmitted?.call(s),
      validator: LengthValidator(minLength: minLength, maxLength: maxLength, allowEmpty: allowEmpty).call,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textAlign: textAlign,
      onTapOutside: onTapOutside ?? (e) => focusNode.unfocus(),
      maxLines: maxLines,
      minLines: minLines,
      autofocus: autofocus,
      onChanged: onChanged,
      decoration:
          decoration ??
          InputDecoration(
            labelText: label,
            counterText: "",
            prefixIcon: prefixIcon,
            helperText: helperText,
            errorText: errorText,
            suffixIcon: suffixIcon ?? (!clear ? null : IconButton(icon: const Icon(Icons.clear), onPressed: () => controller.clear())),
          ),
    );
  }
}

Widget EditPassword({
  required ValueListener<bool> eyeListener,
  ValueListener<String>? valueListener,
  TextEditingController? controller,
  String? initialValue,
  int minLength = 1,
  int maxLength = 128,
  String? label = "密码",
  String? errorText,
  String? hint,
  OnValue<String>? onChanged,
  OnValue<String>? onSubmitted,
  FocusNode? focusNode,
  Color? cursorColor,
  Widget? prefixIcon = const Icon(Icons.lock),
  TextInputAction? textInputAction = TextInputAction.done,
}) {
  TextEditingController c = controller ?? TextEditingController(text: initialValue ?? valueListener?.value);
  FocusNode node = focusNode ?? FocusNode();
  return TextFormField(
    key: UniqueKey(),
    initialValue: null,
    controller: c,
    cursorColor: cursorColor,
    obscureText: eyeListener.value,
    maxLength: maxLength,
    keyboardType: TextInputType.visiblePassword,
    textInputAction: textInputAction,
    onChanged: onChanged ?? valueListener?.onChanged,
    onFieldSubmitted: onSubmitted ?? valueListener?.onChanged,
    validator: LengthValidator(minLength: minLength, maxLength: maxLength, allowEmpty: false).call,
    focusNode: focusNode,
    onTapOutside: (e) => node.unfocus(),
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      labelText: label,
      errorText: errorText,
      hintText: hint,
      counterText: "",
      suffixIcon: IconButton(
        icon: eyeListener.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
        onPressed: () {
          eyeListener.onChanged(!eyeListener.value);
        },
      ),
    ),
  );
}

extension TextEditingControllerInsertExt on TextEditingController {
  void insert(String s) {
    if (s.isEmpty) return;
    TextEditingValue v = this.value;
    if (this.text.isEmpty) {
      this.value = TextEditingValue(
        text: s,
        selection: TextSelection.collapsed(offset: s.length),
      );
      return;
    }
    String oldText = this.text;
    TextSelection old = v.selection;
    if (old.isValid && old.isNormalized) {
      String newText = old.textBefore(oldText) + s + old.textAfter(oldText);
      int newStart = old.start + s.length;
      this.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newStart),
      );
    }
  }
}

Widget EditInt({
  Key? key,
  OptionalValueListener<int>? valueListener,
  TextEditingController? controller,
  int? initialValue,
  int? minValue,
  int? maxValue,
  bool signed = true,
  bool allowEmpty = true,
  void Function(String)? onSubmitted,
  void Function(String)? onChanged,
  String? label,
  String? hint,
  Widget? prefixIcon,
  String? helperText,
  String? errorText,
  int? maxLength,
  bool clear = false,
  Widget? suffixIcon,
  FocusNode? focusNode,
  Color? cursorColor,
  TextInputType? keyboardType,
  TextInputAction? textInputAction = TextInputAction.next,
  InputDecoration? decoration,
  InputBorder? border,
}) {
  TextEditingController? c = controller ?? (clear && suffixIcon == null && decoration == null ? TextEditingController() : null);
  FocusNode node = focusNode ?? FocusNode();
  void onTextChanged(String text) {
    valueListener?.onChanged(text.toInt);
  }

  return TextFormField(
    key: key,
    controller: c,
    initialValue: initialValue?.toString() ?? valueListener?.value?.toString(),
    onChanged: onChanged ?? onTextChanged,
    onFieldSubmitted: onSubmitted ?? onTextChanged,
    focusNode: node,
    maxLength: maxLength ?? 20,
    validator: IntValidator(minValue: minValue, maxValue: maxValue, allowEmpty: allowEmpty).call,
    keyboardType: keyboardType ?? TextInputType.numberWithOptions(signed: signed, decimal: false),
    textInputAction: textInputAction,
    onTapOutside: (e) => node.unfocus(),
    cursorColor: cursorColor,
    decoration:
        decoration ??
        InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: helperText,
          errorText: errorText,
          counterText: "",
          border: border,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon ?? (!clear ? null : IconButton(icon: const Icon(Icons.clear), onPressed: () => c?.clear())),
        ),
  );
}

Widget EditDouble({
  Key? key,
  TextEditingController? controller,
  OptionalValueListener<double>? valueListener,
  double? initialValue,
  double? minValue,
  double? maxValue,
  bool signed = true,
  bool allowEmpty = true,
  void Function(String)? onSubmitted,
  void Function(String)? onChanged,
  String? label,
  String? hint,
  Widget? prefixIcon,
  String? helperText,
  String? errorText,
  int? maxLength,
  bool clear = false,
  Widget? suffixIcon,
  FocusNode? focusNode,
  Color? cursorColor,
  TextInputType? keyboardType,
  TextInputAction? textInputAction = TextInputAction.next,
  InputDecoration? decoration,
  InputBorder? border,
}) {
  TextEditingController? c = controller ?? (clear && suffixIcon == null && decoration == null ? TextEditingController() : null);
  FocusNode node = focusNode ?? FocusNode();
  void onTextChanged(String text) {
    valueListener?.onChanged(text.toDouble);
  }

  return TextFormField(
    key: key,
    controller: c,
    initialValue: initialValue?.toString() ?? valueListener?.value.toString(),
    onChanged: onChanged ?? onTextChanged,
    onFieldSubmitted: onSubmitted ?? onTextChanged,
    focusNode: node,
    maxLength: maxLength,
    validator: DoubleValidator(minValue: minValue, maxValue: maxValue, allowEmpty: allowEmpty).call,
    keyboardType: keyboardType ?? TextInputType.numberWithOptions(signed: signed, decimal: true),
    textInputAction: textInputAction,
    onTapOutside: (e) => node.unfocus(),
    cursorColor: cursorColor,
    decoration:
        decoration ??
        InputDecoration(
          labelText: label,
          hintText: hint,
          helperText: helperText,
          errorText: errorText,
          counterText: "",
          border: border,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon ?? (!clear ? null : IconButton(icon: Icon(Icons.clear), onPressed: () => c?.clear())),
        ),
  );
}
