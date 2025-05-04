part of 'dialog.dart';

class dialogs {
  dialogs._();

  static void pop<T>([T? result]) {
    Navigator.of(globalContext).pop<T>(result);
  }

  static Future<T?> pickSegmentSingle<T>(List<LabelValue<T>> items, {String? title, String? message, T? selected, bool allowEmpty = false}) async {
    Set<T>? st = await pickSegmentValue(items, title: title, message: message, selected: selected == null ? null : {selected}, allowEmpty: allowEmpty, multi: false);
    return st?.firstOrNull;
  }

  static Future<Set<T>?> pickSegmentMulti<T>(List<LabelValue<T>> items, {String? title, String? message, Set<T>? selected, bool allowEmpty = false}) async {
    return await pickSegmentValue(items, title: title, message: message, selected: selected, allowEmpty: allowEmpty, multi: true);
  }

  static Future<Set<T>?> pickSegmentValue<T>(List<LabelValue<T>> items,
      {String? title, String? message, Set<T>? selected, bool multi = false, bool allowEmpty = false}) async {
    Set<T> selSet = {...?selected};
    return await showDialogX((b) {
      b.init(result: selSet);
      b.dialogWidth = DialogWidth.instrict;
      b.title(title?.text());
      b.actions(ok: true, cancel: true);
      List<Widget> ls = [];
      if (message != null) {
        ls << b.messageText(message, minHeight: 32, textAlign: TextAlign.start);
      }

      ls <<
          SegmentedButton<T>(
              multiSelectionEnabled: multi,
              emptySelectionAllowed: allowEmpty,
              showSelectedIcon: false,
              style: SegStyle,
              segments: items.mapList((e) => ButtonSegment<T>(value: e.value, label: e.label.text())),
              selected: selSet,
              onSelectionChanged: (newSelection) {
                selSet = newSelection;
                b.setResult(selSet);
                b.updateState();
              });
      return b.buildColumn(ls);
    });
  }

  static String? _rangeTip(num? minValue, num? maxValue) {
    if (minValue != null && maxValue != null) {
      return "介于$minValue和$maxValue之间";
    } else if (minValue != null) {
      return "大于等于$minValue";
    } else if (maxValue != null) {
      return "小于等于$maxValue";
    }
    return null;
  }

  static Future<double?> inputDouble({double? value, required String title, String? label, String? message, double? minValue, double? maxValue}) async {
    String? s = await inputText(
      value: value?.toString(),
      title: title,
      label: label,
      message: message,
      allowExp: Regs.reals,
      maxLength: 64,
      tips: _rangeTip(minValue, maxValue),
      validator: NumValidator(minValue: minValue, maxValue: maxValue).call,
      width: DialogWidth.small,
    );
    return s?.trim().toDouble;
  }

  static Future<int?> inputInt({
    int? value,
    required String title,
    String? label,
    String? message,
    int? minValue,
    int? maxValue,
  }) async {
    String? s = await inputText(
      value: value?.toString(),
      title: title,
      label: label,
      message: message,
      maxLength: 64,
      allowExp: Regs.integers,
      tips: _rangeTip(minValue, maxValue),
      validator: NumValidator(minValue: minValue, maxValue: maxValue).call,
      width: DialogWidth.small,
    );
    return s?.trim().toInt;
  }

  static Future<String?> inputText({
    String? value,
    required String title,
    String? label,
    String? message,
    String? tips,
    RegExp? allowExp,
    RegExp? denyExp,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormaters,
    TextValidator? validator,
    int? maxLines = 1,
    int minLength = 1,
    int maxLength = 255,
    bool allowEmpty = false,
    bool trim = false,
    bool? password,
    DialogWidth? width,
  }) {
    TextValidator lenValid = Valids.length(minLength, maxLength, allowEmpty: allowEmpty, trim: trim);
    TextValidator vs = validator == null ? lenValid : Valids.list([validator, lenValid]);
    return showDialogX((b) {
      if (width != null) b.dialogWidth = width;
      b.title(title.text());
      bool multiLines = maxLines != null && maxLines > 1;
      ListWidget ls = [];
      HareEdit edit = HareEdit(
          value: value?.toString() ?? "",
          helpText: tips,
          label: label,
          allowExp: allowExp,
          denyExp: denyExp,
          keyboardType: keyboardType,
          inputFormaters: inputFormaters,
          validator: vs,
          maxLength: maxLength,
          maxLines: maxLines,
          password: password,
          autofucus: true,
          noClear: multiLines,
          border: !multiLines ? null : OutlineInputBorder(),
          onSubmit: (s) {
            b.setResult(s);
            b.clickOK();
          });
      ls << edit;
      if (multiLines) {
        Widget btn = b.makeAction("清除", () {
          edit.value = "";
        });
        b.actions(ok: true, cancel: true, items: [btn]);
      } else {
        b.actions(ok: true, cancel: true);
      }
      b.okCallback = () {
        if (!edit.validate()) return false;
        String s = trim ? edit.value.trim() : edit.value;
        b.setResult(s);
        return true;
      };
      return b.buildColumn(ls, message: message);
    });
  }

  static Future<({String first, String second})?> input2(
    HareEdit edit,
    HareEdit secondEdit, {
    required String title,
    String? message,
    TextValidator? validator,
    TextValidator? secondValidator,
    DialogWidth? dialogWidth,
  }) async {
    return await showDialogX((b) {
      b.okCallback = () {
        bool ok1 = edit.validate(validator);
        bool ok2 = secondEdit.validate(secondValidator);
        if (!ok1 || !ok2) return false;
        String s = edit.value;
        String s2 = secondEdit.value;
        b.setResult((first: s, second: s2));
        return true;
      };
      return b.buildColumn([edit, secondEdit], title: title, ok: true, cancel: true, message: message, dialogWidth: dialogWidth);
    });
  }

  static Future<String?> input(
    HareEdit edit, {
    required String title,
    String? message,
    TextValidator? validator,
    DialogWidth? dialogWidth,
  }) async {
    return await showDialogX((b) {
      b.okCallback = () {
        if (!edit.validate(validator)) return false;
        String s = edit.value;
        b.setResult(s);
        return true;
      };
      return b.buildColumn([edit], title: title, ok: true, cancel: true, dialogWidth: dialogWidth, message: message, messageAlign: TextAlign.start, messageMinHeight: 32);
    });
  }

  static Future<bool?> alert({required String title, required String message, TextAlign? align}) async {
    return await showDialogX((b) {
      if (message.length < 60) {
        b.dialogWidth = DialogWidth.small;
      }
      b.centerActions = true;
      b.okCallback = () {
        b.setResult(true);
        return true;
      };
      return b.buildColumn([], title: title, message: message, messageAlign: align, ok: true);
    });
  }

  static Future<bool?> confirm({required String title, required String message, TextAlign? align}) async {
    return await showDialogX((b) {
      if (message.length < 60) {
        b.dialogWidth = DialogWidth.small;
      }
      b.okCallback = () {
        b.setResult(true);
        return true;
      };
      return b.buildColumn([], title: title, message: message, messageAlign: align, ok: true, cancel: true);
    });
  }

  static Future<XAction?> pickAction(
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
    DialogWidth? width,
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
      width: width,
      withOKCancel: withOKCancel,
    );
    ac?.onclick();
    return ac;
  }

  static Future<LabelValue<T>?> pickLabelValue<T>(
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
    DialogWidth? width,
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
      width: width,
      withOKCancel: withOKCancel,
    );
  }

  static Future<T?> pickValue<T>(
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
    DialogWidth? width,
    bool withOKCancel = false,
  }) async {
    return await showDialogX((b) {
      b.init(result: selected);
      return b.buildList(items, builder: (iic) {
        T item = iic.item;
        bool checked = b.result == item;
        if (onItemView != null) {
          return onItemView(item).inkWell(onTap: () {
            b.setResult(item);
            if (withOKCancel) {
              b.updateState();
            } else {
              b.clickOK();
            }
          });
        }
        return ListTile(
            title: onTitle?.call(item) ?? item.toString().text(),
            subtitle: onSubtitle?.call(item),
            leading: onLeading?.call(item),
            trailing: onTrailing?.call(item) ?? (checked ? Icons.check.icon() : null),
            onTap: () {
              b.setResult(item);
              if (withOKCancel) {
                b.updateState();
              } else {
                b.clickOK();
              }
            });
      }, aboveWidgets: aboveWidgets, belowWidgets: belowWidgets, dialogWidth: width, title: title, ok: withOKCancel, cancel: withOKCancel);
    });
  }

  static Future<Set<LabelValue<T>>?> pickLabelValueSet<T>(
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
    DialogWidth? width,
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
      dialogWidth: width,
    );
  }

  static Future<Set<T>?> pickValueSet<T>(
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
    DialogWidth? dialogWidth,
  }) async {
    Set<T> resultSet = {};
    if (selected != null) resultSet.addAll(selected);
    return await showDialogX((b) {
      b.init(result: resultSet);
      return b.buildList(
        items,
        builder: (iic) {
          T item = iic.item;
          Widget cell;
          if (onItemView != null) {
            cell = onItemView(item, b.result ?? {}).inkWell(onTap: () {
              if (resultSet.contains(item)) {
                resultSet.remove(item);
              } else {
                resultSet.add(item);
              }
              b.updateState();
            });
          } else {
            bool checked = resultSet.contains(item);
            cell = ListTile(
                key: UniqueKey(),
                title: onTitle?.call(item) ?? item.toString().text(),
                subtitle: onSubtitle?.call(item),
                leading: onLeading?.call(item),
                trailing: onTrailing?.call(item) ?? (checked ? Icons.check.icon() : null),
                onTap: () {
                  if (resultSet.contains(item)) {
                    resultSet.remove(item);
                  } else {
                    resultSet.add(item);
                  }
                  b.updateState();
                });
          }
          return cell;
        },
        dialogWidth: dialogWidth,
        title: title,
        ok: true,
        cancel: true,
        aboveWidgets: aboveWidgets,
        belowWidgets: belowWidgets,
      );
    });
  }

  static Future<T?> pickGridValue<T>(
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
    DialogWidth? dialogWidth,
    List<Widget>? aboveWidgets,
    List<Widget>? belowWidgets,
    Alignment? dialogAlignment,
    EdgeInsets? dialogInsets,
  }) async {
    return await showDialogX((b) {
      b.init(result: selected);
      return b.buildGrid(
        items,
        columnCount: columnCount,
        itemWidth: itemWidth,
        itemHeight: itemHeight,
        aspectRatio: aspectRatio,
        verticalSpacing: verticalSpacing,
        horizontalSpacing: horizontalSpacing,
        padding: padding,
        builder: (iic) {
          T item = iic.item;
          Widget cell;
          if (onItemView != null) {
            cell = onItemView(item);
          } else {
            bool checked = b.result == item;
            cell = GridTile(
              header: onHeader?.call(item),
              footer: onFooter?.call(item),
              child: onTitle?.call(item) ?? item.toString().text(style: b.context.themeData.textTheme.titleMedium).centered(),
            ).let((e) {
              if (!checked) return e;
              return e.coloredBox(b.gridSelectedBackground).clipRoundRect(3);
            });
          }
          return cell.inkWell(onTap: () {
            b.setResult(item);
            if (ok == true) {
              b.updateState();
            } else {
              b.clickOK();
            }
          });
        },
        title: title,
        ok: ok,
        cancel: cancel,
        dialogWidth: dialogWidth,
        aboveWidgets: aboveWidgets,
        belowWidgets: belowWidgets,
      );
    }, alignment: dialogAlignment, insetPadding: dialogInsets);
  }

  static Future<Set<T>?> pickGridValueSet<T>(
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
    DialogWidth? dialogWidth,
  }) async {
    Set<T> resultSet = {};
    if (selected != null) resultSet.addAll(selected);
    return await showDialogX((b) {
      b.init(result: resultSet);
      return b.buildGrid(items,
          aboveWidgets: aboveWidgets,
          belowWidgets: belowWidgets,
          columnCount: columnCount,
          itemWidth: itemWidth,
          itemHeight: itemHeight,
          aspectRatio: aspectRatio,
          verticalSpacing: verticalSpacing,
          horizontalSpacing: horizontalSpacing,
          padding: padding, builder: (iic) {
        T item = iic.item;
        Widget cell;
        if (onItemView != null) {
          cell = onItemView.call(item, resultSet);
        } else {
          bool checked = resultSet.contains(item);
          cell = GridTile(
            header: onHeader?.call(item),
            footer: onFooter?.call(item),
            child: onTitle?.call(item) ?? item.toString().titleMedium().centered(),
          ).let((e) {
            if (!checked) return e;
            return e.coloredBox(b.gridSelectedBackground).clipRoundRect(3);
          });
        }
        return cell.inkWell(onTap: () {
          if (resultSet.contains(item)) {
            resultSet.remove(item);
          } else {
            resultSet.add(item);
          }
          b.updateState();
        });
      }, title: title, ok: true, cancel: true, dialogWidth: dialogWidth);
    });
  }

  static Future<T?> showPage<T>(HarePage page, {bool flex = true, bool closable = false, DialogWidth? dialogWidth}) {
    return showDialogX((b) {
      b.titleX(
          left: IconButton(onPressed: () => page.onBackPressed(b.context), icon: Icons.adaptive.arrow_back.icon(size: 18)),
          title: page.pageLabel.text(),
          right: page.actions.isEmpty ? null : RowMin(page.actions),
          closable: closable);
      return b.build(page, flex: flex, dialogWidth: dialogWidth);
    });
  }

  static Future<Set<T>?> showChips<T>({
    required List<LabelValue<T>> items,
    Set<T>? selected,
    Widget? title,
    bool allowEmpty = true,
    bool multiSelect = false,
    Widget? above,
    Widget? below,
  }) async {
    ChipChoiceGroup<T> group = ChipChoiceGroup(
      items: items,
      selected: selected,
      allowEmpty: allowEmpty,
      multiSelect: multiSelect,
      alignment: WrapAlignment.center,
    );

    return await showDialogX((b) {
      b.title(title);
      b.okCallback = () {
        b.setResult(group.selected);
        return true;
      };
      return b.buildColumn([if (above != null) above, group.centered(), if (below != null) below], ok: true, cancel: true);
    });
  }

  static Future<T?> columns<T>(
    List<Widget> children, {
    required RFunc<DataResult<T>> validator,
    String? title,
    String? message,
    bool? ok = true,
    bool? cancel = true,
    DialogWidth? dialogWidth,
  }) async {
    return await showDialogX((b) {
      b.okCallback = () {
        DataResult<T> r = validator.call();
        if (r.success) {
          b.setResult(r.data);
        } else if (r.message != null) {
          Toast.error(r.message);
        }
        return r.success;
      };
      return b.buildColumn(children, title: title, message: message, ok: ok, cancel: cancel, dialogWidth: dialogWidth);
    });
  }
}
