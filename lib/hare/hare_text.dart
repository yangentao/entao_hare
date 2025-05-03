//ignore_for_file: must_be_immutable
part of '../fhare.dart';

enum TipStyle { normal, error, success, hidden }

class HareTip extends HareWidget {
  String text;
  TipStyle tipStyle;
  TextAlign textAlign;

  HareTip(this.text, {this.textAlign = TextAlign.start, this.tipStyle = TipStyle.normal}) : super();

  void update(String? text, TipStyle? style) {
    if (text != null) this.text = text;
    if (style != null) this.tipStyle = style;
    updateState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? style = switch (tipStyle) {
      TipStyle.error => textStyle.bodySmall?.merge(const TextStyle(color: Colors.red)),
      TipStyle.success => textStyle.bodySmall?.merge(const TextStyle(color: Colors.green)),
      TipStyle.hidden => textStyle.bodySmall?.merge(const TextStyle(color: Colors.transparent)),
      _ => textStyle.bodySmall,
    };
    return Text(text, textAlign: textAlign, style: style, overflow: TextOverflow.clip);
  }
}

class HareTimeRow extends HareWidget {
  String title;
  TimeOfDay? time;
  void Function(TimeOfDay dateTime)? onChange;

  HareTimeRow({required this.title, this.time, this.onChange}) : super();

  Future<void> _pickTime() async {
    TimeOfDay? dt = await showTimePicker(context: context, initialTime: time ?? const TimeOfDay(hour: 0, minute: 0));
    if (dt != null) {
      time = dt;
      updateState();
      var cb = onChange;
      if (cb != null) cb(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RowMax([title.text(style: themeData.textTheme.titleMedium), const Spacer(), OutlinedButton(onPressed: _pickTime, child: time == null ? "选择时间".text() : time?.formatTime2.text())]);
  }
}

class HareDateRow extends HareWidget {
  String title;
  DateTime? date;
  DateTime fromDate;
  DateTime toDate;
  void Function(DateTime dateTime)? onChange;

  HareDateRow({required this.title, this.date, required this.fromDate, required this.toDate, this.onChange}) : super();

  Future<void> _pickDate() async {
    DateTime? dt = await showDatePicker(context: context, initialDate: date ?? DateTime.now(), firstDate: fromDate, lastDate: toDate);
    if (dt != null) {
      date = dt;
      updateState();
      var cb = onChange;
      if (cb != null) cb(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RowMax([title.text(style: themeData.textTheme.titleMedium), const Spacer(), OutlinedButton(onPressed: _pickDate, child: date == null ? "选择日期".text() : date?.formatDate.text())]);
  }
}
