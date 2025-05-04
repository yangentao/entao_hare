// ignore_for_file: must_be_immutable, non_constant_identifier_names
part of 'widgets.dart';

class HareOutlinedButton extends HareWidget {
  WidgetStatesController statesController = WidgetStatesController({});

  // MaterialStatesController deleteButtonController = MaterialStatesController({MaterialState.disabled});
  Widget child;
  void Function()? onPressed;

  bool _disabled;

  bool get disabled => _disabled;

  set disabled(bool value) {
    _disabled = value;
    updateState();
  }

  bool get selected => statesController.value.contains(WidgetState.selected);

  set selected(bool value) {
    if (value) {
      statesController.value.add(WidgetState.selected);
    } else {
      statesController.value.remove(WidgetState.selected);
    }
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    statesController.notifyListeners();
  }

  HareOutlinedButton(this.child, {bool disabled = false, this.onPressed})
      : _disabled = disabled,
        super();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: disabled ? null : onPressed, statesController: statesController, child: child);
  }
}

class HareDropdown<T> extends HareWidget {
  List<LabelValue<T>> items;
  T? value;
  void Function(T?)? onChanged;
  Widget? hint;

  HareDropdown(this.items, {this.value, this.onChanged, this.hint = const Text("选择...")}) : super();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var ls = items.mapList((e) => DropdownMenuItem<T>(value: e.value, child: Center(child: Text(e.label.toString()))));
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      style: TextStyle(fontSize: 14, color: theme.textTheme.labelMedium?.color ?? Colors.black87),
      alignment: AlignmentDirectional.centerEnd,
      items: ls,
      hint: hint,
      onChanged: (e) {
        value = e;
        updateState();
        if (onChanged != null) {
          onChanged!(value);
        }
      },
    );
  }
}

class HareDropdownX<T> extends HareWidget {
  List<LabelValue<T>> items;
  T? value;
  void Function(T?)? onChanged;

  HareDropdownX(this.items, {this.value, this.onChanged}) : super();

  @override
  Widget build(BuildContext context) {
    var ls = items.mapList((e) => DropdownMenuItem<T>(value: e.value, child: Text(e.label)));
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      items: ls,
      onChanged: (e) {
        value = e;
        updateState();
        onChanged?.call(value);
      },
    );
  }
}
