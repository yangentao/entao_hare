// ignore_for_file: must_be_immutable, non_constant_identifier_names
part of '../entao_hare.dart';

class HareAutoCompleteField extends StatelessWidget {
  late TextEditingController? _controller;
  final FutureOr<Iterable<String>> Function(TextEditingValue edit) optionsBuilder;
  final Widget? label;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? prefixIcon;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? initValue;
  final double maxOptionsWidth;
  final double maxOptionsHeight;
  final void Function(String text)? onChange;
  final void Function(String text)? onSubmited;
  final void Function(String value)? onSelected;
  final void Function(TextEditingController controller)? onController;

  String get value => _controller?.text ?? "";

  set value(String value) => _controller?.text = value;

  HareAutoCompleteField({
    required this.optionsBuilder,
    this.maxOptionsHeight = 400,
    this.maxOptionsWidth = 300,
    this.onSelected,
    this.onSubmited,
    this.onChange,
    this.initValue,
    this.label,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.decoration,
    this.keyboardType,
    this.inputFormatters,
    this.onController,
  }) : super(key: UniqueKey());

  void clear() {
    _controller?.text = "";
    // updateState();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      key: UniqueKey(),
      optionsBuilder: optionsBuilder,
      fieldViewBuilder: _fieldViewBuilder,
      onSelected: onSelected,
      optionsMaxHeight: 400,
      initialValue: TextEditingValue(text: initValue ?? ""),
      optionsViewBuilder: _buildOptionView,
    );
  }

  Widget _buildOptionView(BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (BuildContext context, int index) {
        final String option = options.elementAt(index);
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Text(option),
        ).inkWell(onTap: () {
          onSelected(option);
        });
      },
    ).constrainedBox(maxHeight: maxOptionsHeight, maxWidth: maxOptionsWidth).material(elevation: 4.0).align(Alignment.topLeft);
  }

  Widget _fieldViewBuilder(BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
    _controller = textEditingController;
    onController?.call(textEditingController);
    return TextFormField(
      controller: textEditingController,
      focusNode: focusNode,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChange,
      onFieldSubmitted: (String value) {
        onSubmited?.call(value);
      },
      decoration: decoration ??
          InputDecoration(
              label: label,
              prefix: prefix,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              suffix: suffix ??
                  IconButton(
                    icon: Icons.clear_rounded.icon(size: 16),
                    onPressed: () {
                      textEditingController.text = "";
                      onChange?.call("");
                    },
                  )),
    );
  }
}
