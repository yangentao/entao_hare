part of 'widgets.dart';

class TipText extends HareWidget {
  final TextAlign? _align;
  final TextStyle? _style;
  final bool? _mono;
  final double? _fontSize;
  final FontWeight? _weight;
  final int? _maxLines;
  final bool? _softWrap;
  final TextOverflow? _overflow;

  final Locale? _locale;
  TipMessage? _tip;

  // ignore: use_key_in_widget_constructors
  TipText(
    this._tip, {
    TextAlign? align,
    TextStyle? style,
    bool? mono,
    double? fontSize,
    Color? color,
    FontWeight? weight,
    int? maxLines,
    bool? softWrap,
    TextOverflow? overflow = TextOverflow.clip,
    Locale? locale,
  }) : _align = align,
       _style = style,
       _mono = mono,
       _fontSize = fontSize,
       _weight = weight,
       _maxLines = maxLines,
       _softWrap = softWrap,
       _overflow = overflow ?? TextOverflow.clip,
       _locale = locale;

  void clear() {
    _tip = null;
    updateState();
  }

  void error(String message) => update(TipMessage(level: .error, message: message));

  void warning(String message) => update(TipMessage(level: .warning, message: message));

  void info(String message) => update(TipMessage(level: .info, message: message));

  void tip(String message) => update(TipMessage(level: .tip, message: message));

  void update(TipMessage? message) {
    this._tip = message;
    updateState();
  }

  @override
  Widget build(BuildContext context) {
    TipMessage? t = _tip;
    if (t != null && t.message.isNotEmpty) {
      return t.message.text(
        color: t.level.textColor(context),
        align: _align,
        style: _style,
        mono: _mono,
        fontSize: _fontSize,
        maxLines: _maxLines,
        weight: _weight,
        softWrap: _softWrap,
        overflow: _overflow,
        locale: _locale,
      );
    }
    return "".text();
  }
}
