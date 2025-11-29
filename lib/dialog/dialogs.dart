library;

import 'package:entao_dutil/entao_dutil.dart';
import 'package:entao_hare/basic/basic.dart';
import 'package:entao_range/entao_range.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../harepage/harepage.dart';
import '../harewidget/harewidget.dart';
import '../widgets/widgets.dart';


final dialogs = Dialogs();


class Dialogs {
  double ACTION_MIN_WIDTH = 80;
  double CONTENT_MIN_WIDTH = 200;
  double CONTENT_MIN_HEIGHT = 64;
  Color ACTION_DANGER_COLOR = Colors.redAccent;
  Color GRID_SELECTED_BACKGROUND = Colors.blue.withOpacityX(0.2);
  final DialogOptions options;

  Dialogs({DialogOptions? options}) : options = options ?? DialogOptions();

  void pop<T>([T? result]) {
    Navigator.of(globalContext).pop<T>(result);
  }

  String? _rangeTip(num? minValue, num? maxValue) {
    if (minValue != null && maxValue != null) {
      return "介于$minValue和$maxValue之间";
    } else if (minValue != null) {
      return "大于等于$minValue";
    } else if (maxValue != null) {
      return "小于等于$maxValue";
    }
    return null;
  }

  Future<double?> inputDouble({double? value, required String title, String? label, String? message, double? minValue, double? maxValue, bool signed = true}) async {
    String? s = await inputText(
      value: value?.toString(),
      title: title,
      label: label,
      message: message,
      allowExp: Regs.reals,
      maxLength: 64,
      tips: _rangeTip(minValue, maxValue),
      validator: NumValidator(minValue: minValue, maxValue: maxValue).call,
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: signed),
    );
    return s?.trim().toDouble;
  }

  Future<int?> inputInt({int? value, required String title, String? label, String? message, int? minValue, int? maxValue, bool signed = true}) async {
    String? s = await inputText(
      value: value?.toString(),
      title: title,
      label: label,
      message: message,
      maxLength: 64,
      allowExp: Regs.integers,
      tips: _rangeTip(minValue, maxValue),
      validator: NumValidator(minValue: minValue, maxValue: maxValue).call,
      keyboardType: TextInputType.numberWithOptions(decimal: false, signed: signed),
    );
    return s?.trim().toInt;
  }

  Future<String?> inputText({
    required String title,
    String? value,
    String? label,
    String? message,
    String? hint,
    String? tips,
    RegExp? allowExp,
    RegExp? denyExp,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormaters,
    TextValidator? validator,
    int? maxLines = 1,
    int? minLines,
    int minLength = 1,
    int maxLength = 255,
    bool allowEmpty = false,
    bool trim = false,
    bool? password,
    bool clearButton = false,
    InputBorder? border,
    bool? outlineBorder,
  }) {
    TextValidator lenValid = LengthValidator(minLength: minLength, maxLength: maxLength, allowEmpty: allowEmpty, trim: trim);
    TextValidator vs = validator == null ? lenValid : ListValidator([validator, lenValid]);

    GlobalKey<FormState> formKey = GlobalKey();
    return showColumn(
      onActions: (uc) {
        return actionPanel(uc, [
          cancelAction("取消"),
          makeAction("清除", () {
            uc.fireAction("clear");
          }),
          okAction(uc, "确定"),
        ]);
      },
      onContent: (uc) {
        bool multiLines = (maxLines != null && maxLines > 1) || (minLines != null && minLines > 1);
        HareEdit edit = HareEdit(
          value: value?.toString() ?? "",
          hint: hint,
          helpText: tips,
          label: label,
          allowExp: allowExp,
          denyExp: denyExp,
          keyboardType: keyboardType,
          inputFormaters: inputFormaters,
          validator: vs,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          password: password,
          autofucus: true,
          noClear: multiLines || clearButton,
          border: border ?? (outlineBorder == true || multiLines ? const OutlineInputBorder() : null),
          onSubmit: (s) {
            uc.setResult(s);
            if (uc.onValidate()) {
              uc.popResult();
            }
          },
        );
        uc.onValidate = () {
          if (formKey.currentState?.validate() != true) return false;
          if (!edit.validate()) return false;
          String s = trim ? edit.value.trim() : edit.value;
          uc.setResult(s);
          return true;
        };
        uc.onAction("clear", () => edit.clear());
        return Form(key: formKey, child: ColumnMinStretch([if (message != null) messageWidget(message), edit]));
      },
      title: title,
    );
  }

  Future<({String first, String second})?> input2(
    HareEdit edit,
    HareEdit secondEdit, {
    required String title,
    String? message,
    TextValidator? validator,
    TextValidator? secondValidator,
  }) async {
    GlobalKey<FormState> formKey = GlobalKey();
    return showColumn(
      onContent: (uc) {
        uc.onValidate = () {
          if (formKey.currentState?.validate() != true) return false;
          if (!edit.validate(validator)) return false;
          if (!secondEdit.validate(secondValidator)) return false;
          String s = edit.value;
          String s2 = secondEdit.value;
          uc.setResult((first: s, second: s2));
          return true;
        };
        return Form(key: formKey, child: ColumnMinStretch([if (message != null) messageWidget(message), edit, secondEdit]));
      },
      title: title,
      ok: true,
      cancel: true,
    );
  }

  Future<String?> input(HareEdit edit, {required String title, String? message, TextValidator? validator, double spacing = 8}) async {
    GlobalKey<FormState> formKey = GlobalKey();
    return showColumn(
      onContent: (uc) {
        uc.onValidate = () {
          if (formKey.currentState?.validate() != true) return false;
          if (!edit.validate(validator)) return false;
          String s = edit.value;
          uc.setResult(s);
          return true;
        };
        return Form(
          key: formKey,
          child: ColumnMinStretch([if (message != null) messageWidget(message), edit], spacing: spacing),
        );
      },
      title: title,
      ok: true,
      cancel: true,
    );
  }

  Future<T?> pickSegmentSingle<T>(List<LabelValue<T>> items, {String? title, String? message, T? selected, bool allowEmpty = false}) async {
    if (!allowEmpty && selected == null) selected = items.first.value;
    Set<T>? st = await pickSegmentValue(items, title: title, message: message, selected: selected == null ? null : {selected}, allowEmpty: allowEmpty, multi: false);
    return st?.firstOrNull;
  }

  Future<Set<T>?> pickSegmentMulti<T>(List<LabelValue<T>> items, {String? title, String? message, Set<T>? selected, bool allowEmpty = false}) async {
    if (!allowEmpty && (selected == null || selected.isEmpty)) selected = {items.first.value};
    return await pickSegmentValue(items, title: title, message: message, selected: selected, allowEmpty: allowEmpty, multi: true);
  }

  Future<Set<T>?> pickSegmentValue<T>(List<LabelValue<T>> items, {String? title, String? message, Set<T>? selected, bool multi = false, bool allowEmpty = true}) async {
    if (!allowEmpty && (selected == null || selected.isEmpty)) selected = {items.first.value};
    return showColumn(
      title: title,
      ok: true,
      cancel: true,
      onContent: (uc) {
        if (!uc.hasResult) {
          uc.setResult({...?selected});
        }
        return ColumnMinStretch([
          if (message != null) messageWidget(message),
          SegmentedButton<T>(
            multiSelectionEnabled: multi,
            emptySelectionAllowed: allowEmpty,
            showSelectedIcon: false,
            style: SegStyle,
            segments: items.mapList((e) => ButtonSegment<T>(value: e.value, label: e.label.text())),
            selected: uc.getResult()!,
            onSelectionChanged: (newSelection) {
              uc.setResult(newSelection);
              uc.updateState();
            },
          ),
        ], spacing: 16);
      },
    );
  }

  Future<CloseRange?> pickIntRanges({
    required CloseRange value,
    required int minValue,
    required int maxValue,
    required String label,
    required String title,
    int? divisions,
  }) async {
    assert(maxValue > minValue);
    return showColumn(
      title: title,
      ok: true,
      cancel: true,
      onContent: (uc) {
        if (!uc.hasResult) {
          uc.setResult(value);
        }
        CloseRange range = uc.getResult()!;
        return ColumnMin([
          RowMin([label.titleMedium(), space(width: 8), range.start.round().toString().titleMedium(), "-".text(), range.end.round().toString().titleMedium()]),
          RangeSlider(
            values: RangeValues(range.start.clamp(minValue, maxValue).toDouble(), range.end.clamp(minValue, maxValue).toDouble()),
            min: minValue.toDouble(),
            max: maxValue.toDouble(),
            divisions: divisions ?? (maxValue - minValue),
            onChanged: (v) {
              uc.setResult(CloseRange(v.start.toInt(), v.end.toInt()));
              uc.updateState();
            },
            labels: RangeLabels(range.start.round().toString(), range.end.round().toString()),
            padding: xy(0, 8),
          ),
          space(height: 8),
        ], crossAxisAlignment: CrossAxisAlignment.center);
      },
    );
  }

  Future<int?> pickInt({required int value, required int minValue, required int maxValue, required String label, required String title, int? divisions}) async {
    return showColumn(
      title: title,
      ok: true,
      cancel: true,
      padding: edges(hor: 16, ver: 16),
      onContent: (uc) {
        value = value.clamp(minValue, maxValue);
        if (!uc.hasResult) {
          uc.setResult(value);
        }
        int v = uc.getResult()!;
        return ColumnMin([
          RowMin([label.titleMedium(), space(width: 8), v.toString().titleMedium()]),
          Slider(
            value: v.toDouble(),
            min: minValue.toDouble(),
            max: maxValue.toDouble(),
            divisions: divisions ?? (maxValue - minValue),
            onChanged: (r) {
              uc.setResult(r.toInt());
              uc.updateState();
            },
            label: v.toString(),
            padding: xy(0, 8),
          ),
          space(height: 8),
        ], crossAxisAlignment: CrossAxisAlignment.center);
      },
    );
  }

  Future<XAction?> pickAction(
    List<XAction> items, {
    String? title,
    XAction? selected,
    Widget Function(XAction)? onItemView,
    Widget? Function(XAction)? onTitle,
    Widget? Function(XAction)? onSubtitle,
    Widget? Function(XAction)? onLeading,
    Widget? Function(XAction)? onTrailing,
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
    bool withOKCancel = false,
  }) async {
    XAction? sel = selected ?? items.firstOr((e) => e.checked);

    XAction? ac = await pickValue(
      items,
      title: title,
      selected: sel,
      onItemView: onItemView,
      onTitle: onTitle ?? (a) => a.titleWidget,
      onLeading: onLeading ?? (a) => a.iconWidget,
      onSubtitle: onSubtitle,
      onTrailing: onTrailing,
      aboveWidgets: aboveWidgets,
      belowWidgets: belowWidgets,
      ok: withOKCancel,
      cancel: withOKCancel,
    );
    ac?.onclick();
    return ac;
  }

  Future<LabelValue<T>?> pickLabelValue<T>(
    List<LabelValue<T>> items, {
    T? selected,
    String? title,
    Widget Function(LabelValue<T>)? onItemView,
    Widget? Function(LabelValue<T>)? onTitle,
    Widget? Function(LabelValue<T>)? onSubtitle,
    Widget? Function(LabelValue<T>)? onLeading,
    Widget? Function(LabelValue<T>)? onTrailing,
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
    bool withOKCancel = false,
  }) async {
    LabelValue<T>? checked = items.firstOr((e) => e.value == selected);
    return await pickValue<LabelValue<T>>(
      items,
      selected: checked,
      title: title,
      onItemView: onItemView,
      onTitle: onTitle ?? (e) => e.label.text(),
      onSubtitle: onSubtitle,
      onLeading: onLeading,
      onTrailing: onTrailing,
      aboveWidgets: aboveWidgets,
      belowWidgets: belowWidgets,
      ok: withOKCancel,
      cancel: withOKCancel,
    );
  }

  Future<Set<LabelValue<T>>?> pickLabelValueSet<T>(
    List<LabelValue<T>> items, {
    Iterable<T>? selected,
    String? title,
    Widget Function(LabelValue<T>)? onItemView,
    Widget? Function(LabelValue<T>)? onTitle,
    Widget? Function(LabelValue<T>)? onSubtitle,
    Widget? Function(LabelValue<T>)? onLeading,
    Widget? Function(LabelValue<T>)? onTrailing,
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
    bool separated = true,
  }) async {
    List<LabelValue<T>> checked = items.filter((e) => selected?.contains(e.value) ?? false);
    return await pickValueSet<LabelValue<T>>(
      items,
      selected: checked,
      title: title,
      onTitle: onTitle ?? (e) => e.label.text(),
      onSubtitle: onSubtitle,
      onLeading: onLeading,
      onTrailing: onTrailing,
      aboveWidgets: aboveWidgets,
      belowWidgets: belowWidgets,
      separated: separated,
    );
  }

  Future<T?> pickGridValue<T>(
    List<T> items, {
    T? selected,
    Widget Function(T)? onItemView,
    Widget? Function(T)? onTitle,
    Widget? Function(T)? onHeader,
    Widget? Function(T)? onFooter,
    int columnCount = 0,
    double itemWidth = 80,
    double? itemHeight,
    double aspectRatio = 1.0,
    double verticalSpacing = 0.0,
    double horizontalSpacing = 0.0,
    EdgeInsets? padding,
    String? title,
    bool ok = false,
    bool cancel = false,
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
  }) async {
    return showColumn(
      isContentScrollable: true,
      title: title,
      cancel: cancel,
      ok: ok,
      aboveWidgets: aboveWidgets,
      belowWidgets: belowWidgets,
      padding: EdgeInsets.all(0),
      onContent: (uc) {
        if (!uc.hasResult) {
          uc.setResult(selected);
        }
        return EnGridView(
          columnCount: columnCount,
          crossAxisExtent: itemWidth,
          mainAxisExtent: itemHeight,
          childAspectRatio: aspectRatio,
          mainAxisSpacing: verticalSpacing,
          crossAxisSpacing: horizontalSpacing,
          padding: padding,
          shrinkWrap: true,
          items: items,
          itemView: (iic) {
            T item = iic.item;
            Widget cell;
            if (onItemView != null) {
              cell = onItemView(item);
            } else {
              bool checked = uc.getResult() == item;
              cell = GridTile(
                header: onHeader?.call(item),
                footer: onFooter?.call(item),
                child: onTitle?.call(item) ?? item.toString().text(style: uc.themeData.textTheme.titleMedium).centered(),
              );
              if (checked) {
                cell = cell.coloredBox(GRID_SELECTED_BACKGROUND).clipRoundRect(3);
              }
            }
            return cell.inkWell(
              onTap: () {
                uc.setResult(item);
                if (ok) {
                  uc.updateState();
                } else {
                  uc.pop(item);
                }
              },
            );
          },
        );
      },
    );
  }

  Future<Set<T>?> pickGridValueSet<T>(
    List<T> items, {
    Iterable<T>? selected,
    String? title,
    Widget Function(T, Set<T>)? onItemView,
    Widget? Function(T)? onTitle,
    Widget? Function(T)? onHeader,
    Widget? Function(T)? onFooter,
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
    int columnCount = 0,
    double itemWidth = 80,
    double? itemHeight,
    double aspectRatio = 1.0,
    double verticalSpacing = 0.0,
    double horizontalSpacing = 0.0,
    EdgeInsets? padding,
  }) async {
    Set<T> resultSet = {};
    if (selected != null) resultSet.addAll(selected);
    return showColumn(
      isContentScrollable: true,
      title: title,
      cancel: true,
      ok: true,
      aboveWidgets: aboveWidgets,
      belowWidgets: belowWidgets,
      padding: EdgeInsets.all(0),
      onContent: (uc) {
        bool isCheck(T item) {
          Set<T> ls = uc.getResult() ?? {};
          return ls.contains(item);
        }

        void toggole(T item) {
          Set<T> ls = uc.getResult() ?? {};
          if (ls.contains(item)) {
            ls.remove(item);
          } else {
            ls.add(item);
          }
        }

        if (!uc.hasResult) uc.setResult(resultSet);
        return EnGridView(
          columnCount: columnCount,
          crossAxisExtent: itemWidth,
          mainAxisExtent: itemHeight,
          childAspectRatio: aspectRatio,
          mainAxisSpacing: verticalSpacing,
          crossAxisSpacing: horizontalSpacing,
          padding: padding,
          shrinkWrap: true,
          items: items,
          itemView: (iic) {
            T item = iic.item;
            Widget cell;
            if (onItemView != null) {
              Set<T> ls = uc.getResult() ?? {};
              cell = onItemView(item, ls);
            } else {
              cell = GridTile(
                header: onHeader?.call(item),
                footer: onFooter?.call(item),
                child: onTitle?.call(item) ?? item.toString().text(style: uc.themeData.textTheme.titleMedium).centered(),
              );
              if (isCheck(item)) {
                cell = cell.coloredBox(GRID_SELECTED_BACKGROUND).clipRoundRect(3);
              }
            }
            return cell.inkWell(
              onTap: () {
                toggole(item);
                uc.updateState();
              },
            );
          },
        );
      },
    );
  }

  Future<T?> pickValue<T>(
    List<T> items, {
    T? selected,
    String? title,
    Widget Function(T)? onItemView,
    Widget? Function(T)? onTitle,
    Widget? Function(T)? onSubtitle,
    Widget? Function(T)? onLeading,
    Widget? Function(T)? onTrailing,
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
    EdgeInsets? padding,
    bool separated = true,
    bool cancel = false,
    bool ok = false,
  }) async {
    return showColumn(
      isContentScrollable: true,
      title: title,
      cancel: cancel,
      ok: ok,
      aboveWidgets: aboveWidgets,
      belowWidgets: belowWidgets,
      padding: EdgeInsets.all(0),
      onContent: (uc) {
        if (!uc.hasResult) uc.setResult(selected);
        return EnListView(
          items: items,
          shrinkWrap: true,
          padding: padding,
          separator: separated,
          itemView: (cii) {
            var item = cii.item;
            if (onItemView != null) return onItemView(item);
            return ListTile(
              title: onTitle?.call(item) ?? item.toString().titleMedium(),
              subtitle: onSubtitle?.call(item),
              leading: onLeading?.call(item),
              trailing: onTrailing?.call(item) ?? (uc.getResult() == item ? Icons.check.icon() : null),
              onTap: () {
                uc.setResult(item);
                if (ok) {
                  uc.updateState();
                } else {
                  uc.pop(item);
                }
              },
            );
          },
        );
      },
    );
  }

  Future<Set<T>?> pickValueSet<T>(
    List<T> items, {
    Iterable<T>? selected,
    String? title,
    Widget Function(T, Set<T>)? onItemView,
    Widget? Function(T)? onTitle,
    Widget? Function(T)? onSubtitle,
    Widget? Function(T)? onLeading,
    Widget? Function(T)? onTrailing,
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
    EdgeInsets? padding,
    bool separated = true,
  }) async {
    Set<T> resultSet = {};
    if (selected != null) resultSet.addAll(selected);
    return showColumn(
      isContentScrollable: true,
      title: title,
      cancel: true,
      ok: true,
      aboveWidgets: aboveWidgets,
      belowWidgets: belowWidgets,
      padding: EdgeInsets.all(0),
      onContent: (uc) {
        bool isCheck(T item) {
          Set<T> ls = uc.getResult() ?? {};
          return ls.contains(item);
        }

        void toggole(T item) {
          Set<T> ls = uc.getResult() ?? {};
          if (ls.contains(item)) {
            ls.remove(item);
          } else {
            ls.add(item);
          }
        }

        if (!uc.hasResult) uc.setResult(resultSet);
        return EnListView(
          items: items,
          shrinkWrap: true,
          padding: padding,
          separator: separated,
          itemView: (cii) {
            var item = cii.item;
            if (onItemView != null) {
              Set<T> ls = uc.getResult() ?? {};
              return onItemView(item, ls);
            }
            return ListTile(
              title: onTitle?.call(item) ?? item.toString().titleMedium(),
              subtitle: onSubtitle?.call(item),
              leading: onLeading?.call(item),
              trailing: onTrailing?.call(item) ?? (isCheck(item) ? Icons.check.icon() : null),
              onTap: () {
                toggole(item);
                uc.updateState();
              },
            );
          },
        );
      },
    );
  }

  Future<T?> showPage<T>(HarePage page, {bool flex = true, double minHeight = 120}) {
    return showBuilder((uc) {
      ListWidget ls = [
        titlePanel(
          uc,
          left: IconButton(onPressed: () => page.onBackPressed(uc.context), icon: Icons.adaptive.arrow_back.icon(size: 18), color: uc.colorScheme.onPrimary),
          title: page.pageLabel.text(),
          right: page.actions.isEmpty ? null : RowMin(page.actions),
          closable: false,
        ),
        if (flex) page.expanded() else page,
      ];
      if (flex) {
        return ColumnMaxStretch(ls).constrainedBox(minHeight: minHeight);
      } else {
        return ColumnMinStretch(ls).constrainedBox(minHeight: minHeight);
      }
    });
  }

  Future<Set<T>?> showChips<T>({
    required List<LabelValue<T>> items,
    Set<T>? selected,
    String? title,
    bool allowEmpty = true,
    bool multiSelect = false,
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
  }) async {
    ChipChoiceGroup<T> group = ChipChoiceGroup(items: items, selected: selected, allowEmpty: allowEmpty, multiSelect: multiSelect, alignment: WrapAlignment.center);

    return showColumn(
      onContent: (uc) {
        uc.onValidate = () {
          uc.setResult(group.selected);
          return true;
        };
        return group;
      },
      title: title,
      ok: true,
      cancel: true,
      aboveWidgets: aboveWidgets,
      belowWidgets: belowWidgets,
    );
  }

  Future<bool?> confirm({required String title, required String message, TextAlign? align = TextAlign.center}) async {
    return showColumn(
      onContent: (uc) => message.titleMedium(align: align).centered(),
      title: title,
      ok: true,
      cancel: true,
      onOK: (uc) {
        uc.setResult(true);
        return true;
      },
    );
  }

  Future<bool?> alert({required String title, required String message, TextAlign? align = TextAlign.center}) async {
    return showColumn(
      onContent: (uc) => message.titleMedium(align: align).centered(),
      title: title,
      ok: true,
      onOK: (uc) {
        uc.setResult(true);
        return true;
      },
    );
  }

  Future<T?> showColumn<T>({
    required UpdableBuilder onContent,
    UpdableBuilder? onTitle,
    UpdableBuilder? onActions,
    bool Function(UpdatableContext)? onOK,
    String? title,
    bool ok = false,
    bool cancel = false,
    bool isContentScrollable = false,
    EdgeInsets padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
  }) {
    return showBuilder((uc) {
      uc.onValidate = () {
        return onOK?.call(uc) ?? true;
      };
      Widget c = onContent(uc).padded(padding).constrainedBox(minWidth: CONTENT_MIN_WIDTH, minHeight: CONTENT_MIN_HEIGHT);
      return ColumnMinStretch([
        if (onTitle != null) onTitle(uc),
        if (onTitle == null && title != null) titlePanel(uc, title: title.text()),
        ...?aboveWidgets,
        if (isContentScrollable) c.flexible() else c,
        ...?belowWidgets,
        if (onActions != null) onActions(uc),
        if (onActions == null && (ok || cancel)) actionPanel(uc, [if (cancel) cancelAction("取消"), if (ok) okAction(uc, "确定")]),
      ]).constrainedBox(minHeight: 80);
    });
  }

  Widget messageWidget(String message, {TextAlign? align = TextAlign.center}) {
    return message.titleMedium(align: align).centered();
  }

  Widget cancelAction(String label, {Color? color}) {
    return makeAction(label, () => globalContext.maybePop(), color: color);
  }

  Widget okAction(UpdatableContext updatableContext, String label, {Color? color}) {
    return primaryAction(label, () {
      if (updatableContext.onValidate()) {
        updatableContext.popResult();
      }
    }, color: color);
  }

  Widget dangerAction(String label, VoidCallback onTap, {Color? color}) {
    return makeAction(label, onTap, color: color ?? ACTION_DANGER_COLOR);
  }

  Widget primaryAction(String label, VoidCallback onTap, {Color? color}) {
    return makeAction(label, onTap, color: color ?? globalContext.themeData.primaryColor);
  }

  Widget makeAction(String label, VoidCallback onTap, {Color? color}) {
    if (color != null) {
      return StadiumElevatedButton(child: label.text(), onPressed: onTap, fillColor: color).constrainedBox(minWidth: ACTION_MIN_WIDTH);
    }
    return StadiumOutlinedButton(child: label.text(), onPressed: onTap).constrainedBox(minWidth: ACTION_MIN_WIDTH);
  }

  Widget actionPanel(UpdatableContext uc, List<Widget> items) {
    return RowMax(items, mainAxisAlignment: MainAxisAlignment.spaceAround)
        .padded(xy(10, 8))
        .shapeDecorated(
          shape: Border(top: BorderSide(color: uc.themeData.dividerColor)),
        );
  }

  Widget titlePanel(UpdatableContext uc, {Widget? left, Widget? title, Widget? right, bool closable = true}) {
    var w = RowMax([
      ?left,
      ?title,
      Spacer(),
      ?right,
      if (closable)
        IconButton(
          onPressed: () => uc.pop(),
          icon: Icons.close.icon(size: 16, color: uc.themeData.colorScheme.onPrimary),
        ),
    ]).padded(edges(left: 16, right: 8, top: 4, bottom: 4)).coloredBox(uc.themeData.colorScheme.primary);
    return DefaultTextStyle(
      textAlign: TextAlign.left,
      style: uc.themeData.textTheme.titleMedium!.copyWith(color: uc.themeData.colorScheme.onPrimary),
      child: w,
    );
  }

  Future<T?> showBuilder<T>(
    Widget Function(UpdatableContext uc) builder, {
    EdgeInsets? insetPadding,
    AlignmentGeometry? alignment,
    clipBehavior = Clip.hardEdge,
    Color? backgroundColor,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    Duration? insetAnimationDuration,
    Curve? insetAnimationCurve,
    ShapeBorder? shape,
    BoxConstraints? constraints,
  }) {
    HareBuilder hb = HareBuilder();
    hb.builder = (c) => builder(UpdatableContext(context: c, updatable: hb));
    return showDialog<T>(
      context: globalContext,
      builder: (c) => Dialog(
        insetPadding: insetPadding ?? options.insetPadding,
        alignment: alignment ?? options.alignment,
        clipBehavior: clipBehavior ?? options.clipBehavior,
        backgroundColor: backgroundColor ?? options.backgroundColor,
        elevation: elevation ?? options.elevation,
        shadowColor: shadowColor ?? options.shadowColor,
        surfaceTintColor: surfaceTintColor ?? options.surfaceTintColor,
        insetAnimationDuration: insetAnimationDuration ?? options.insetAnimationDuration,
        insetAnimationCurve: insetAnimationCurve ?? options.insetAnimationCurve,
        shape: shape ?? options.shape,
        constraints: constraints ?? options.constraints,
        child: hb,
      ),
    );
  }
}

class DialogOptions {
  Color? backgroundColor;
  double? elevation;
  Color? shadowColor;
  Color? surfaceTintColor;
  Duration insetAnimationDuration = const Duration(milliseconds: 100);
  Curve insetAnimationCurve = Curves.decelerate;
  EdgeInsets? insetPadding;
  Clip? clipBehavior;
  ShapeBorder? shape;
  AlignmentGeometry? alignment;
  Widget? child;
  BoxConstraints? constraints;
}
