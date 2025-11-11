// ignore_for_file: must_be_immutable
part of 'widgets.dart';

TextFormField EditText({
  TextEditingController? controller,
  ValueListener<String>? valueListener,
  String? initialValue,
  String? label,
  String? hint,
  int? minLength,
  int maxLength = 256,
  bool allowEmpty = true,
  FuncString? onSubmitted,
  Widget? prefixIcon,
  String? helperText,
  String? errorText,
  bool clear = true,
  Widget? suffixIcon,
  Color? cursorColor,
  TextValidator? validator,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType = TextInputType.text,
  TextInputAction? textInputAction = TextInputAction.next,
  FocusNode? focusNode,
  TextAlign textAlign = TextAlign.start,
  bool autofocus = false,
  int? maxLines,
  int? minLines,
  bool readonly = false,
  InputDecoration? decoration,
  void Function(String)? onChanged,
  void Function(PointerDownEvent)? onTapOutside,
}) {
  TextEditingController c = controller ?? TextEditingController(text: initialValue ?? valueListener?.value);
  FocusNode node = focusNode ?? FocusNode();
  var lv = LengthValidator(minLength: minLength ?? 0, maxLength: maxLength, allowEmpty: allowEmpty);
  TextValidator tv = validator == null ? lv : ListValidator([validator, lv]);

  return TextFormField(
    key: UniqueKey(),
    controller: c,
    maxLength: maxLength,
    validator: tv,
    maxLines: maxLines,
    minLines: minLines,
    onFieldSubmitted: onSubmitted ?? valueListener?.onChanged,
    onChanged: onChanged ?? valueListener?.onChanged,
    textAlign: textAlign,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    inputFormatters: inputFormatters,
    readOnly: readonly,
    autofocus: autofocus,
    cursorColor: cursorColor,
    focusNode: node,
    onTapOutside: onTapOutside ?? (e) => node.unfocus(),
    decoration:
        decoration ??
        InputDecoration(
          labelText: label,
          hintText: hint,
          counterText: "",
          prefixIcon: prefixIcon,
          helperText: helperText,
          errorText: errorText,
          suffixIcon: suffixIcon ?? (!clear ? null : IconButton(icon: const Icon(Icons.clear), onPressed: () => c.clear())),
        ),
  );
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
  List<TextInputFormatter>? inputFormatters,
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
    validator: LengthValidator(minLength: minLength, maxLength: maxLength, allowEmpty: false),
    inputFormatters: inputFormatters,
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
  void backspace() {
    TextEditingValue v = this.value;
    if (v.text.isEmpty) {
      return;
    }
    String oldText = v.text;
    TextSelection old = v.selection;
    if (old.isValid && old.isNormalized) {
      if (old.isCollapsed) {
        if (old.start == 0) {
          return;
        } else if (old.start == 1) {
          this.value = TextEditingValue(text: oldText.substring(1), selection: TextSelection.collapsed(offset: 0));
        } else {
          int ch = oldText.codeUnitAt(old.start - 2);
          if (isUtf16Lead(ch)) {
            this.value = TextEditingValue(
              text: oldText.substring(0, old.start - 2) + oldText.substring(old.end),
              selection: TextSelection.collapsed(offset: old.start - 2),
            );
          } else {
            this.value = TextEditingValue(
              text: oldText.substring(0, old.start - 1) + oldText.substring(old.end),
              selection: TextSelection.collapsed(offset: old.start - 1),
            );
          }
        }
      } else {
        this.value = TextEditingValue(
          text: old.textBefore(oldText) + old.textAfter(oldText),
          selection: TextSelection.collapsed(offset: old.start),
        );
      }
    }
  }

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
    validator: IntValidator(minValue: minValue, maxValue: maxValue, allowEmpty: allowEmpty),
    keyboardType: keyboardType ?? TextInputType.numberWithOptions(signed: signed, decimal: false),
    inputFormatters: [signed ? InputFormats.reals : InputFormats.realsUnsigned],
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
    initialValue: (initialValue ?? valueListener?.value)?.toString(),
    onChanged: onChanged ?? onTextChanged,
    onFieldSubmitted: onSubmitted ?? onTextChanged,
    focusNode: node,
    maxLength: maxLength,
    validator: DoubleValidator(minValue: minValue, maxValue: maxValue, allowEmpty: allowEmpty),
    keyboardType: keyboardType ?? TextInputType.numberWithOptions(signed: signed, decimal: true),
    textInputAction: textInputAction,
    inputFormatters: [signed ? InputFormats.reals : InputFormats.realsUnsigned],
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
