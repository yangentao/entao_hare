// ignore_for_file: must_be_immutable
part of '../entao_harewidget.dart';

class HareText extends HareWidget {
  String text;
  TextStyle? style;
  TextAlign? textAlign;

  HareText(this.text, {this.textAlign, this.style}) : super();

  void message(String text, {bool success = false, error = false}) {
    this.text = text;
    if (success) {
      this.success();
    } else if (error) {
      this.error();
    } else {
      this.normal();
    }
    updateState();
  }

  HareText error({TextStyle? style}) {
    this.style = style ?? const TextStyle(color: Colors.red);
    return this;
  }

  HareText success({TextStyle? style}) {
    this.style = style ?? const TextStyle(color: Colors.green);
    return this;
  }

  HareText tips({TextStyle? style}) {
    this.style = style ?? const TextStyle(fontSize: 12);
    return this;
  }

  HareText normal({TextStyle? style}) {
    this.style = style;
    return this;
  }

  HareText update(String? newText) {
    if (newText != null) {
      text = newText;
    }
    updateState();
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: textAlign, style: style, overflow: TextOverflow.clip);
  }
}
