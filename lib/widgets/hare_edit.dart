// ignore_for_file: must_be_immutable, non_constant_identifier_names
part of 'widgets.dart';

extension RegExpInputFormaterEx on RegExp {
  FilteringTextInputFormatter allowInput() {
    return FilteringTextInputFormatter.allow(this);
  }

  FilteringTextInputFormatter denyInput() {
    return FilteringTextInputFormatter.deny(this);
  }
}

FilteringTextInputFormatter get IntTextInputFormater => FilteringTextInputFormatter.allow(RegExp("[0-9]*"));

FilteringTextInputFormatter get FloatTextInputFormater => FilteringTextInputFormatter.allow(RegExp("[0-9.]*"));

class InputFormats {
  InputFormats._();

  static TextInputFormatter maxLength(int len) => LengthLimitingTextInputFormatter(len);
  static final TextInputFormatter singleLine = FilteringTextInputFormatter.singleLineFormatter;
  static final TextInputFormatter digits = FilteringTextInputFormatter.digitsOnly;
  static final TextInputFormatter reals = FilteringTextInputFormatter.allow(Regs.reals);
  static final TextInputFormatter realsUnsigned = FilteringTextInputFormatter.allow(Regs.realsUnsigned);
  static final TextInputFormatter integers = FilteringTextInputFormatter.allow(Regs.integers);

  static TextInputFormatter allow(RegExp exp) => FilteringTextInputFormatter.allow(exp);

  static TextInputFormatter deny(RegExp exp) => FilteringTextInputFormatter.deny(exp);
}

class HareEdit extends HareWidget {
  TextEditingController controller;
  String? label;
  String? hint;
  Icon? icon;
  bool? password;
  int? maxLength;
  TextStyle? style;
  void Function(String)? onChanged;
  void Function(String)? onSubmit;
  void Function()? onClear;
  TextValidator? validator;
  bool _showPassword = false;
  String? counterText;
  List<TextInputFormatter>? inputFormaters;
  TextInputType? keyboardType;
  int? maxLines;
  int? minLines;
  TextAlign? textAlign;
  bool noClear;
  String? helpText;
  bool autofucus;
  FocusNode? focusNode;
  String? errorText;
  InputBorder? border;
  bool readOnly;
  RegExp? allowExp;
  RegExp? denyExp;

  HareEdit({
    String? value,
    this.label,
    this.hint,
    this.icon,
    this.textAlign,
    this.style,
    this.counterText = "",
    this.inputFormaters,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onSubmit,
    this.onClear,
    this.noClear = false,
    this.password,
    this.helpText,
    this.errorText,
    this.autofucus = false,
    this.maxLength = 255,
    this.focusNode,
    this.border,
    this.readOnly = false,
    this.allowExp,
    this.denyExp,
    this.validator,
  }) : controller = TextEditingController(text: value),
       super();

  String get value => controller.text;

  set value(String newValue) {
    controller.text = newValue;
  }

  void clear() {
    controller.clear();
  }

  bool validate([TextValidator? validCallback]) {
    TextValidator? v = validCallback ?? validator;
    if (v == null) return true;
    String s = value;
    String? err = v(s);
    this.errorText = err;
    this.updateState();
    return err == null;
  }

  @override
  Widget build(BuildContext context) {
    bool pwd = password ?? false;
    List<TextInputFormatter> formats = [
      ...?inputFormaters,
      if (allowExp != null) InputFormats.allow(allowExp!),
      if (denyExp != null) InputFormats.deny(denyExp!),
      if (maxLength != null) InputFormats.maxLength(maxLength!),
      if (maxLines == 1) InputFormats.singleLine,
    ];
    Widget? makeSuffixIcon() {
      if (noClear && !pwd) return null;
      Icon? icon;
      if (pwd) {
        icon = _showPassword ? const Icon(Icons.visibility_off, size: 16) : const Icon(Icons.visibility, size: 16);
      } else {
        icon = Icons.clear_rounded.icon(size: 16);
      }
      return IconButton(
        onPressed: () {
          if (pwd) {
            _showPassword = !_showPassword;
          } else {
            controller.clear();
            onClear?.call();
            onChanged?.call("");
          }
          updateState();
        },
        icon: icon,
      );
    }

    return TextFormField(
      key: UniqueKey(),
      focusNode: focusNode,
      controller: controller,
      textAlign: textAlign ?? TextAlign.start,
      style: themeData.textTheme.titleMedium,
      obscureText: pwd && !_showPassword,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      autofocus: autofucus,
      readOnly: readOnly,
      inputFormatters: formats,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helpText,
        prefixIcon: icon,
        counterText: counterText,
        errorText: errorText,
        border: border,
        suffixIcon: makeSuffixIcon(),
      ),
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
    );
  }
}

class HareTextArea extends HareWidget {
  TextEditingController controller;
  String? label;
  Icon? icon;
  int? maxLength;
  TextStyle? style;
  void Function(String)? onChanged;
  void Function(String)? onSubmit;
  void Function()? onClear;

  String? counterText;
  TextInputFormatter? inputFormater;
  int? maxLines;
  int? minLines;
  bool readOnly;

  HareTextArea({
    String value = "",
    this.label,
    this.icon,
    this.style,
    this.readOnly = false,
    this.counterText,
    this.inputFormater,
    this.minLines,
    this.maxLines = 6,
    this.onChanged,
    this.onSubmit,
    this.maxLength,
  }) : controller = TextEditingController(text: value),
       super();

  String get value => controller.text;

  set value(String newValue) {
    controller.text = newValue;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: themeData.textTheme.titleMedium,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      inputFormatters: inputFormater == null ? null : [inputFormater!],
      decoration: InputDecoration(labelText: label, prefixIcon: icon, counterText: counterText, border: const OutlineInputBorder()),
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
    );
  }
}
