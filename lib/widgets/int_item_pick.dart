// ignore_for_file: must_be_immutable
part of 'widgets.dart';

enum HorAlign { left, center, right }

class ItemsPickInt extends HareWidget {
  final String? emptyText;
  final IntOptions options;
  final Widget? label;
  final bool clearable;
  final HorAlign align;
  final void Function(int?)? onChange;
  int? value;

  ItemsPickInt({required this.options, this.value, this.label, this.emptyText, this.clearable = false, this.align = HorAlign.center, this.onChange}) : super();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      initialValue: value,
      itemBuilder: (c) => options.menuItems(),
      position: PopupMenuPosition.under,
      onSelected: (v) {
        value = v;
        updateState();
        onChange?.call(v);
      },
      child: RowMax([
        if (label != null) label!,
        if (align == HorAlign.center || align == HorAlign.right) const Spacer(),
        options.toWidgetOr(value, emptyText),
        if (align == HorAlign.center || align == HorAlign.left) const Spacer(),
        Icons.arrow_drop_down_outlined.icon(),
        if (clearable)
          IconButton(
              onPressed: () {
                value = null;
                updateState();
                onChange?.call(null);
              },
              icon: Icons.clear_rounded.icon(size: 16)),
      ]).padded(xy(0, 10)).sizedBox(height: 56).underLine(),
    );
  }
}
