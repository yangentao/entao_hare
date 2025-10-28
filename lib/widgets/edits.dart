// ignore_for_file: must_be_immutable
part of 'widgets.dart';

class EditNumber extends HareWidget {
  TextEditingController controller;
  num? initialValue;
  num minValue;
  num maxValue;
  bool signed;
  bool decimal;
  bool allowEmpty;
  String? label;
  void Function(num? value)? onSubmitted;
  Widget? prefixIcon;
  String? helperText;
  String? errorText;
  bool clear;
  Widget? suffixIcon;
  FocusNode focusNode;
  Color? cursorColor;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;

  num? get value => decimal ? controller.text.toDouble : controller.text.toInt;

  int? get valueInt => controller.text.toInt;

  double? get valueDouble => controller.text.toDouble;

  EditNumber({
    TextEditingController? controller,
    this.initialValue,
    this.label,
    FocusNode? focusNode,
    required this.minValue,
    required this.maxValue,
    this.allowEmpty = false,
    this.signed = true,
    this.decimal = true,
    this.cursorColor = Colors.deepOrange,
    this.prefixIcon,
    this.helperText,
    this.errorText,
    this.onSubmitted,
    this.clear = true,
    this.suffixIcon,
    TextInputType? keyboardType,
    this.textInputAction = TextInputAction.next,
  })  : controller = controller ?? TextEditingController(),
        keyboardType = keyboardType ?? TextInputType.numberWithOptions(signed: signed, decimal: decimal),
        focusNode = focusNode ?? FocusNode(),
        super();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      controller: controller,
      initialValue: initialValue?.toString(),
      focusNode: focusNode,
      cursorColor: cursorColor,
      maxLength: math.max(minValue.toString().length + 1, maxValue.toString().length + 1),
      onFieldSubmitted: (s) => onSubmitted?.call(decimal ? s.toDouble : s.toInt),
      validator: NumValidator(minValue: minValue, maxValue: maxValue, allowEmpty: allowEmpty).call,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onTapOutside: (e) => focusNode.unfocus(),
      decoration: InputDecoration(
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
    this.decoration ,
    this.onChanged,
    this.onTapOutside,
  })  : controller = controller ?? TextEditingController(),
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
      decoration: decoration ??
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

class EditPassword extends HareWidget {
  TextEditingController controller;
  bool showPassword;
  int minLength;
  int maxLength;
  FuncString? onSubmitted;
  String? label;
  Color? cursorColor;
  Widget? prefixIcon;
  String? errorText;
  TextInputAction? textInputAction;
  FocusNode focusNode;

  String get value => controller.text;

  EditPassword({
    TextEditingController? controller,
    this.label = "密码",
    this.minLength = 1,
    this.maxLength = 128,
    this.showPassword = false,
    FocusNode? focusNode,
    this.onSubmitted,
    this.cursorColor,
    this.errorText,
    this.textInputAction = TextInputAction.done,
    this.prefixIcon = const Icon(Icons.lock),
  })  : controller = controller ?? TextEditingController(),
        focusNode = focusNode ?? FocusNode(),
        super();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      controller: controller,
      cursorColor: cursorColor,
      obscureText: !showPassword,
      maxLength: maxLength,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      onFieldSubmitted: (s) => onSubmitted?.call(s),
      validator: LengthValidator(minLength: minLength, maxLength: maxLength, allowEmpty: false).call,
      focusNode: focusNode,
      onTapOutside: (e) => focusNode.unfocus(),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: label,
        counterText: "",
        suffixIcon: IconButton(
          icon: showPassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
          onPressed: () {
            showPassword = !showPassword;
            updateState();
          },
        ),
      ),
    );
  }
}

extension TextEditingControllerInsertExt on TextEditingController {
  void insert(String s) {
    if (s.isEmpty) return;
    TextEditingValue v = this.value;
    if (this.text.isEmpty) {
      this.value = TextEditingValue(text: s, selection: TextSelection.collapsed(offset: s.length));
      return;
    }
    String oldText = this.text;
    TextSelection old = v.selection;
    if (old.isValid && old.isNormalized) {
      String newText = old.textBefore(oldText) + s + old.textAfter(oldText);
      int newStart = old.start + s.length;
      this.value = TextEditingValue(text: newText, selection: TextSelection.collapsed(offset: newStart));
    }
  }
}
