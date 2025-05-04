// ignore_for_file: must_be_immutable

part of '../entao_hare.dart';

TextInputFormatter numberOnlyInpuFormater = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

class HareSwitch extends HareWidget {
  bool value;
  void Function(bool)? onChanged;

  HareSwitch({this.value = false, this.onChanged}) : super();

  @override
  Widget build(BuildContext context) {
    return Switch(
        value: value,
        onChanged: (b) {
          value = b;
          updateState();
          onChanged?.call(b);
        });
  }
}

class HareDate extends HareWidget {
  WidgetStatesController statesController = WidgetStatesController({});
  bool disabled;
  DateTime? value;
  DateTime? firstDate;
  DateTime? lastDate;
  void Function(DateTime newDate)? onChanged;

  HareDate({this.value, this.firstDate, this.lastDate, this.disabled = false, this.onChanged}) : super();

  Widget get preferSizedBox => sizedBox(width: 150, height: 36);

  void _onClick(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: value ?? DateTime.now(),
            firstDate: firstDate ?? DateTime(1970, 1, 1),
            lastDate: lastDate ?? DateTime.now().add(const Duration(days: 10 * 365)))
        .then((value) {
      bool changed = this.value != value;
      if (changed && value != null) {
        this.value = value;
        updateState();
        if (onChanged != null) {
          onChanged!(value);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: disabled
            ? null
            : () {
                _onClick(context);
              },
        statesController: statesController,
        child: Row(children: [
          Icons.calendar_month_rounded.icon(),
          Text(
            value?.dateString ?? "选择日期...",
            style: const TextStyle(fontSize: 16),
          ),
        ]));
  }
}

class HareTime extends HareWidget {
  TextEditingController hourController = TextEditingController();
  TextEditingController minController = TextEditingController();

  void Function(int hour, int minute)? onChanged;

  HareTime({String? value, int? hour, int? minute, this.onChanged}) : super() {
    if (value != null) {
      List<String> lsTo = value.split(":");
      if (lsTo.length >= 2) {
        hour = lsTo[0].toInt;
        minute = lsTo[1].toInt;
      }
    }
    if (hour != null) hourController.text = hour.toString();
    if (minute != null) minController.text = minute.toString();
  }

  Widget get preferSizedBox => this.sizedBox(width: 100, height: 42);

  String? get timeHHMM {
    if (hourController.text.isNotEmpty && minController.text.isNotEmpty) {
      return "${hourController.text}:${minController.text}";
    }
    return null;
  }

  String? get timeHHMMSS {
    if (hourController.text.isNotEmpty && minController.text.isNotEmpty) {
      return "${hourController.text}:${minController.text}:00";
    }
    return null;
  }

  void _onHourChanged(String text) {
    int n = text.toInt ?? 0;
    if (n > 24) {
      hourController.text = "24";
    }
  }

  void _onMinChanged(String text) {
    int n = text.toInt ?? 0;
    if (n >= 60) {
      minController.text = "59";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Focus(
          onFocusChange: (yes) {
            if (yes) {
              hourController.selection = TextSelection(baseOffset: 0, extentOffset: hourController.text.length);
            }
          },
          child: TextField(
            controller: hourController,
            textAlign: TextAlign.center,
            inputFormatters: [numberOnlyInpuFormater],
            decoration: const InputDecoration(hintText: "时", counterText: ""),
            onChanged: _onHourChanged,
            maxLength: 2,
          )).expanded(),
      const Text(":"),
      Focus(
          onFocusChange: (yes) {
            if (yes) {
              minController.selection = TextSelection(baseOffset: 0, extentOffset: minController.text.length);
            }
          },
          child: TextField(
            controller: minController,
            textAlign: TextAlign.center,
            inputFormatters: [numberOnlyInpuFormater],
            decoration: const InputDecoration(hintText: "分", counterText: ""),
            onChanged: _onMinChanged,
            maxLength: 2,
          )).expanded(),
    ]).sizedBox(width: 100, height: 42);
  }
}

class HareListView<T> extends HareWidget {
  List<T> items;
  Widget Function(T item) itemBiulder;
  bool hasSeparator;

  HareListView(this.items, this.itemBiulder, {this.hasSeparator = true}) : super();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: makeSeparatorBuilder(height: 1, color: hasSeparator ? null : Colors.transparent),
      itemBuilder: (c, i) => itemBiulder(items[i]),
    );
  }
}
