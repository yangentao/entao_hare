part of 'widgets.dart';

mixin class FormMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, TextEditingController> _nameControllerMap = {};
  final Map<String, FocusNode> _focusMap = {};
  final Map<String, bool> _eyeMap = {};
  final Map<String, dynamic> _valueMap = {};

  T? valueOf<T extends Object>(String name) => _valueMap[name];

  String textOf(String name) {
    return _nameControllerMap[name]?.text ?? "";
  }

  TextEditingController controllerOf(String name) => _nameControllerMap.getOrPut(name, () => TextEditingController());

  FocusNode focusNodeOf(String name) => _focusMap.getOrPut(name, () => FocusNode());

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  Widget form(Widget child, {AutovalidateMode? autovalidateMode, VoidCallback? onChanged}) {
    return Form(key: _formKey, child: child, autovalidateMode: autovalidateMode, onChanged: onChanged);
  }

  Widget editPassword({
    Key? key,
    required String name,
    required VoidCallback onUpdateState,
    String? initialValue,
    int minLength = 1,
    int maxLength = 128,
    String? label = "密码",
    String? errorText,
    String? hint,
    bool allowEmpty = false,
    TextValidator? validator,
    OnValue<String>? onChanged,
    OnValue<String>? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    Color? cursorColor,
    InputBorder? border,
    Widget? prefixIcon = const Icon(Icons.lock),
    TextInputAction? textInputAction = TextInputAction.done,
  }) {
    _nameControllerMap[name] ??= TextEditingController(text: initialValue);
    _focusMap[name] ??= FocusNode();
    _eyeMap[name] ??= true;

    var lv = LengthValidator(minLength: minLength, maxLength: maxLength, allowEmpty: allowEmpty);
    TextValidator tv = validator == null ? lv : ListValidator([validator, lv]);

    return TextFormField(
      key: key ?? UniqueKey(),
      initialValue: null,
      controller: _nameControllerMap[name],
      cursorColor: cursorColor,
      obscureText: _eyeMap[name]!,
      maxLength: maxLength,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: tv,
      inputFormatters: inputFormatters,
      focusNode: _focusMap[name],
      onTapOutside: (e) => _focusMap[name]?.unfocus(),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: label,
        errorText: errorText,
        hintText: hint,
        counterText: "",
        border: border,
        suffixIcon: IconButton(
          icon: _eyeMap[name]! ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
          onPressed: () {
            _eyeMap[name] = !_eyeMap[name]!;
            onUpdateState();
          },
        ),
      ),
    );
  }

  TextFormField editText({
    Key? key,
    required String name,
    String? initialValue,
    String? label,
    String? hint,
    int? minLength,
    int maxLength = 256,
    bool allowEmpty = true,
    ValueChanged<String>? onSubmitted,
    Widget? prefixIcon,
    String? helperText,
    String? errorText,
    bool clear = false,
    Widget? suffixIcon,
    Color? cursorColor,
    TextValidator? validator,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType = TextInputType.text,
    TextInputAction? textInputAction = TextInputAction.next,
    TextAlign textAlign = TextAlign.start,
    bool autofocus = false,
    int? maxLines,
    int? minLines,
    bool readonly = false,
    InputDecoration? decoration,
    InputBorder? border,
    void Function(String)? onChanged,
    void Function(PointerDownEvent)? onTapOutside,
  }) {
    _nameControllerMap[name] ??= TextEditingController(text: initialValue);
    _focusMap[name] ??= FocusNode();
    var lv = LengthValidator(minLength: minLength ?? 0, maxLength: maxLength, allowEmpty: allowEmpty);
    TextValidator tv = validator == null ? lv : ListValidator([validator, lv]);

    return TextFormField(
      key: key ?? UniqueKey(),
      controller: _nameControllerMap[name],
      maxLength: maxLength,
      validator: tv,
      maxLines: maxLines,
      minLines: minLines,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      textAlign: textAlign,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      readOnly: readonly,
      autofocus: autofocus,
      cursorColor: cursorColor,
      focusNode: _focusMap[name],
      onTapOutside: onTapOutside ?? (e) => _focusMap[name]?.unfocus(),
      decoration:
          decoration ??
          InputDecoration(
            labelText: label,
            hintText: hint,
            counterText: "",
            prefixIcon: prefixIcon,
            helperText: helperText,
            errorText: errorText,
            border: border,
            suffixIcon: suffixIcon ?? (!clear ? null : IconButton(icon: const Icon(Icons.clear), onPressed: () => _nameControllerMap[name]?.clear())),
          ),
    );
  }

  TextFormField editArea({
    required String name,
    Key? key,
    String? initialValue,
    String? label,
    String? hint,
    int? minLength,
    int maxLength = 256,
    bool allowEmpty = true,
    OnValue<String>? onSubmitted,
    Widget? prefixIcon,
    String? helperText,
    String? errorText,
    Widget? suffixIcon,
    Color? cursorColor,
    TextValidator? validator,
    List<TextInputFormatter>? inputFormatters,
    bool autofocus = false,
    int? minLines = 3,
    int? maxLines = 6,
    bool readonly = false,
    InputDecoration? decoration,
    InputBorder? border,
    void Function(String)? onChanged,
    void Function(PointerDownEvent)? onTapOutside,
  }) {
    _nameControllerMap[name] ??= TextEditingController(text: initialValue);
    _focusMap[name] ??= FocusNode();
    var lv = LengthValidator(minLength: minLength ?? 0, maxLength: maxLength, allowEmpty: allowEmpty);
    TextValidator tv = validator == null ? lv : ListValidator([validator, lv]);

    return TextFormField(
      key: key ?? UniqueKey(),
      controller: _nameControllerMap[name],
      maxLength: maxLength,
      validator: tv,
      maxLines: maxLines,
      minLines: minLines,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      inputFormatters: inputFormatters,
      readOnly: readonly,
      autofocus: autofocus,
      cursorColor: cursorColor,
      focusNode: _focusMap[name],
      onTapOutside: onTapOutside ?? (e) => _focusMap[name]?.unfocus(),
      decoration:
          decoration ??
          InputDecoration(
            labelText: label,
            hintText: hint,
            counterText: "",
            prefixIcon: prefixIcon,
            helperText: helperText,
            errorText: errorText,
            border: border ?? OutlineInputBorder(),
          ),
    );
  }

  Widget EditInt({
    required String name,
    Key? key,
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
    Color? cursorColor,
    TextInputAction? textInputAction = TextInputAction.next,
    InputDecoration? decoration,
    InputBorder? border,
  }) {
    _nameControllerMap[name] ??= TextEditingController(text: initialValue?.toString());
    _focusMap[name] ??= FocusNode();

    return TextFormField(
      key: key,
      controller: _nameControllerMap[name],
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      focusNode: _focusMap[name],
      maxLength: maxLength,
      validator: IntValidator(minValue: minValue, maxValue: maxValue, allowEmpty: allowEmpty),
      keyboardType: TextInputType.numberWithOptions(signed: signed, decimal: false),
      inputFormatters: [signed ? InputFormats.reals : InputFormats.realsUnsigned],
      textInputAction: textInputAction,
      onTapOutside: (e) => _focusMap[name]?.unfocus(),
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
            suffixIcon: suffixIcon ?? (!clear ? null : IconButton(icon: const Icon(Icons.clear), onPressed: () => _nameControllerMap[name]?.clear())),
          ),
    );
  }

  Widget EditDouble({
    required String name,
    Key? key,
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
    TextInputAction? textInputAction = TextInputAction.next,
    InputDecoration? decoration,
    InputBorder? border,
  }) {
    _nameControllerMap[name] ??= TextEditingController(text: initialValue?.toString());
    _focusMap[name] ??= FocusNode();

    return TextFormField(
      key: key,
      controller: _nameControllerMap[name],
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      focusNode: _focusMap[name],
      maxLength: maxLength,
      validator: DoubleValidator(minValue: minValue, maxValue: maxValue, allowEmpty: allowEmpty),
      keyboardType: TextInputType.numberWithOptions(signed: signed, decimal: true),
      textInputAction: textInputAction,
      inputFormatters: [signed ? InputFormats.reals : InputFormats.realsUnsigned],
      onTapOutside: (e) => _focusMap[name]?.unfocus(),
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
            suffixIcon: suffixIcon ?? (!clear ? null : IconButton(icon: Icon(Icons.clear), onPressed: () => _nameControllerMap[name]?.clear())),
          ),
    );
  }

  RadioGroup<T> radioGroupRow<T>({
    required String name,
    required List<LabelValue<T>> items,
    T? initValue,
    required VoidCallback onUpdateState,
    double spacing = 0.0,
    MainAxisSize mainAxisSize = .max,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceAround,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    _valueMap[name] ??= initValue;
    return RadioGroup<T>(
      groupValue: _valueMap[name],
      onChanged: (v) {
        _valueMap[name] = v;
        onUpdateState();
      },
      child: Row(
        children: items.mapList((e) => RowMin([Radio(value: e.value), e.label.text()])),
        spacing: spacing,
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
      ),
    );
  }
}
