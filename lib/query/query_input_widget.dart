// ignore_for_file: must_be_immutable

part of '../fhare.dart';

class InputQueryWidget extends QueryWidget {
  TextEditingController? _controller;

  final List<TextInputFormatter> _inputFormaters = [];
  final String label;
  final String field;
  final String? hint;
  double? _optionsWidth;
  late QueryOperatorWidget operatorDropdown;

  QueryOperator get currentOperator => operatorDropdown.currentOperator;

  set currentOperator(QueryOperator op) => operatorDropdown.currentOperator = op;

  String? _helper;
  Future<String?> Function(String input)? onSearch;
  AutocompleteOptionsBuilder<String>? autoCompleteBuilder;

  InputQueryWidget.integers(this.field, this.label, {this.hint, QueryConditionChange? onChange, int maxLength = 512}) : super() {
    _inputFormaters << LengthLimitingTextInputFormatter(maxLength);
    _inputFormaters << FilteringTextInputFormatter.allow(Regs.integers);
    operatorDropdown = QueryOperatorWidget.number((e) => onConditionChanged());
    onConditionChange = onChange;
  }

  InputQueryWidget.doubles(this.field, this.label, {this.hint, QueryConditionChange? onChange, int maxLength = 512}) : super() {
    _inputFormaters << LengthLimitingTextInputFormatter(maxLength);
    _inputFormaters << FilteringTextInputFormatter.allow(Regs.reals);
    operatorDropdown = QueryOperatorWidget.number((e) => onConditionChanged());
    onConditionChange = onChange;
  }

  InputQueryWidget.text(this.field, this.label,
      {this.hint, QueryOperator? operator, QueryConditionChange? onChange, this.onSearch, this.autoCompleteBuilder, double? optionsWidth, int maxLength = 512})
      : super() {
    _inputFormaters << LengthLimitingTextInputFormatter(maxLength);
    _inputFormaters << FilteringTextInputFormatter.deny(RegExp(r'[;"]'));
    operatorDropdown = QueryOperatorWidget.text((e) => onConditionChanged());
    _optionsWidth = optionsWidth;
    onConditionChange = onChange;
    if (operator != null) {
      currentOperator = operator;
    }
  }

  InputQueryWidget.textDigit(this.field, this.label, {this.hint, QueryConditionChange? onChange, int maxLength = 512}) : super() {
    _inputFormaters << LengthLimitingTextInputFormatter(maxLength);
    _inputFormaters << FilteringTextInputFormatter.allow(Regs.digits);
    operatorDropdown = QueryOperatorWidget.text((e) => onConditionChanged());
    onConditionChange = onChange;
  }

  String get value => _controller?.text.trim() ?? "";

  set value(String newValue) {
    _controller?.text = newValue;
  }

  @override
  QueryCondition? condition() {
    if (value.trim().isEmpty) {
      return null;
    }
    return SingleCondition(op: currentOperator, field: field, params: [value.trim()]);
  }

  void _fireChanged() {
    onConditionChange?.call(condition());
  }

  void onConditionChanged() {
    // _updateHelper();
    _fireChanged();
  }

  void onTextSubmit(String text) {
    // _updateHelper();
    _fireChanged();
  }

  void onTextChanged(String text) {
    // _updateHelper();
  }

  @override
  Widget build(BuildContext context) {
    var optBuilder = autoCompleteBuilder;
    if (optBuilder == null) {
      _controller ??= TextEditingController();
      return TextFormField(
        controller: _controller,
        inputFormatters: _inputFormaters,
        onChanged: onTextChanged,
        decoration: InputDecoration(
          labelText: label,
          helperText: _helper,
          hintText: hint,
          prefixIcon: operatorDropdown,
          suffixIcon: _makeSuffix(context),
        ),
        onFieldSubmitted: onTextSubmit,
      ).padded(edges(top: 4));
    }
    return HareAutoCompleteField(
      optionsBuilder: optBuilder,
      onSelected: onTextSubmit,
      onSubmited: onTextSubmit,
      onChange: onTextChanged,
      maxOptionsWidth: _optionsWidth ?? 320,
      maxOptionsHeight: 400,
      inputFormatters: _inputFormaters,
      onController: (c) {
        _controller = c;
      },
      decoration: InputDecoration(
        labelText: label,
        helperText: _helper,
        hintText: hint,
        prefixIcon: operatorDropdown,
        suffixIcon: _makeSuffix(context),
      ),
    );
  }

  Widget _makeSuffix(BuildContext context) {
    if (onSearch == null) {
      return _makeClear(context);
    }
    return RowMin([
      IconButton(
          onPressed: () async {
            String? s = await onSearch?.call(value);
            if (s != null) {
              value = s;
              onConditionChanged();
            }
          },
          icon: Icons.search_rounded.icon(size: 20)),
      _makeClear(context),
    ]);
  }

  Widget _makeClear(BuildContext context) {
    return IconButton(
        onPressed: () {
          _controller?.text = "";
          _asyncOnClear();
        },
        icon: Icons.clear_outlined.icon(size: 16));
  }

  Future<void> _asyncOnClear() async {
    onConditionChanged();
  }
}
