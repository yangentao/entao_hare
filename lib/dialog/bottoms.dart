import 'package:entao_dutil/entao_dutil.dart';
import 'package:entao_hare/entao_hare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 不能用于很多数据的列表， 或键盘输入。
class bottoms {
  bottoms._();

  static Future<String?> inputText({
    String? message,
    String? initialValue,
    String? label,
    String? hint,
    int? minLength,
    int maxLength = 256,
    bool allowEmpty = true,
    FuncString? onSubmitted,
    Widget? prefixIcon,
    String? helperText,
    String? errorText,
    bool clear = true,
    Widget? suffixIcon,
    Color? cursorColor,
    TextValidator? validator,
    List<TextInputFormatter>? inputFormatters,
    FocusNode? focusNode,
    TextAlign textAlign = TextAlign.start,
    bool autofocus = false,
    int? maxLines,
    int? minLines,
    bool readonly = false,
    InputDecoration? decoration,
  }) async {
    return await bottoms.showBuilder(
      (c) {
        GlobalKey<FormState> formKey = GlobalKey();
        c.onValidate = () {
          if (false == formKey.currentState?.validate()) return false;
          if (c.getResult() == null) return false;
          return true;
        };
        ValueListener<String> vl = ValueListener(value: initialValue ?? "", afterValue: (v) => c.setResult(v));

        return Form(
          key: formKey,
          child: EditText(
            valueListener: vl,
            textInputAction: TextInputAction.done,
            initialValue: initialValue,
            label: label,
            hint: hint,
            clear: clear,
            minLength: minLength,
            maxLength: maxLength,
            allowEmpty: allowEmpty,
            onSubmitted: onSubmitted,
            prefixIcon: prefixIcon,
            helperText: helperText,
            errorText: errorText,
            suffixIcon: suffixIcon,
            cursorColor: cursorColor,
            validator: validator,
            inputFormatters: inputFormatters,
            focusNode: focusNode,
            textAlign: textAlign,
            autofocus: autofocus,
            maxLines: maxLines,
            minLines: minLines,
            readonly: readonly,
            decoration: decoration,
          ),
        );
      },
      message: message,
      ok: true,
      cancel: true,
      hasEdit: true,
    );
  }

  static Future<double?> inputDouble({String? message, double? initialValue, double? minValue, double? maxValue, bool signed = true, String? label, String? hint}) async {
    return await bottoms.showBuilder(
      (c) {
        GlobalKey<FormState> formKey = GlobalKey();
        c.onValidate = () {
          if (false == formKey.currentState?.validate()) return false;
          if (c.getResult() == null) return false;
          return true;
        };
        OptionalValueListener<double> vl = OptionalValueListener(value: initialValue, afterValue: (v) => c.setResult(v));

        return Form(
          key: formKey,
          child: EditDouble(
            valueListener: vl,
            textInputAction: TextInputAction.done,
            initialValue: initialValue,
            minValue: minValue,
            maxValue: maxValue,
            signed: signed,
            label: label,
            hint: hint,
          ),
        );
      },
      message: message,
      ok: true,
      cancel: true,
      hasEdit: true,
    );
  }

  static Future<int?> inputInt({String? message, int? initialValue, int? minValue, int? maxValue, bool signed = true, String? label, String? hint}) async {
    return await bottoms.showBuilder(
      (c) {
        GlobalKey<FormState> formKey = GlobalKey();
        c.onValidate = () {
          if (false == formKey.currentState?.validate()) return false;
          if (c.getResult() == null) return false;
          return true;
        };
        OptionalValueListener<int> vl = OptionalValueListener(value: initialValue, afterValue: (v) => c.setResult(v));

        return Form(
          key: formKey,
          child: EditInt(
            valueListener: vl,
            textInputAction: TextInputAction.done,
            initialValue: initialValue,
            minValue: minValue,
            maxValue: maxValue,
            signed: signed,
            label: label,
            hint: hint,
          ),
        );
      },
      message: message,
      ok: true,
      cancel: true,
      hasEdit: true,
    );
  }

  static Future<T?> showBuilder<T>(
    UpdableBuilder builder, {
    String? message,
    bool cancel = false,
    bool ok = false,
    bool hasEdit = false,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) async {
    return showModalUpdatable((c) {
      return ColumnMinStretch([
        ?(message?.titleMedium().centered()),
        if (message != null) space(height: 12),
        builder(c),
        if (ok || cancel) space(height: 24),
        if (ok || cancel)
          RowMax([
            if (cancel)
              "取消".text().paddings(hor: 12).stadiumOutlinedButton(() {
                c.pop();
              }),
            if (ok)
              "确定".text().paddings(hor: 12).stadiumElevatedButton(() {
                if (c.onValidate()) {
                  c.popResult();
                }
              }),
          ], mainAxisAlignment: MainAxisAlignment.spaceAround),
      ]).padded(padding);
    }, hasEdit: hasEdit);
  }

  static Future<T?> pickSegmentSingle<T>(List<LabelValue<T>> items, {String? message, T? selected, bool allowEmpty = true}) async {
    Set<T>? st = await pickSegment(items, message: message, selected: selected == null ? null : {selected}, allowEmpty: allowEmpty, multi: false);
    return st?.firstOrNull;
  }

  static Future<Set<T>?> pickSegmentMulti<T>(List<LabelValue<T>> items, {String? message, Set<T>? selected, bool allowEmpty = true}) async {
    return await pickSegment(items, message: message, selected: selected, allowEmpty: allowEmpty, multi: true);
  }

  static Future<Set<T>?> pickSegment<T>(List<LabelValue<T>> items, {String? message, Set<T>? selected, bool multi = false, bool allowEmpty = true}) async {
    Set<T> selSet = {...?selected};
    return showModalUpdatable((c) {
      var sb = SegmentedButton<T>(
        multiSelectionEnabled: multi,
        emptySelectionAllowed: allowEmpty,
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: c.themeData.colorScheme.primary,
          selectedForegroundColor: c.themeData.colorScheme.surface,
          side: BorderSide(color: c.themeData.dividerColor),
        ),
        segments: items.mapList((e) => ButtonSegment<T>(value: e.value, label: e.label.text())),
        selected: selSet,
        onSelectionChanged: (newSelection) {
          selSet = newSelection;
          c.updateState();
        },
      );

      return ColumnMin([
        space(height: 24),
        ?(message?.titleMedium()),
        if (message != null) space(height: 12),
        sb,
        space(height: 24),
        "确定".text().paddings(hor: 12).stadiumElevatedButton(() => c.context.maybePop(selSet)),
        space(height: 32),
      ], crossAxisAlignment: CrossAxisAlignment.center);
    });
  }

  static Future<LabelValue<T>?> pickLabelValue<T>(
    List<LabelValue<T>> items, {
    T? selected,
    Widget Function(LabelValue<T>)? onItemView,
    Widget? Function(LabelValue<T>)? onTitle,
    Widget? Function(LabelValue<T>)? onSubtitle,
    Widget? Function(LabelValue<T>)? onLeading,
    Widget? Function(LabelValue<T>)? onTrailing,
    double? itemExtent,
    bool separator = true,
    double separatorIndentStart = 0,
    double separatorIndentEnd = 0,
    double? minTileVerticalPadding,
    double? minTileLeadingWidth,
    double? minTileHeight,
  }) {
    LabelValue<T>? checked = items.firstOr((e) => e.value == selected);

    return pickItem(
      items,
      selected: checked,
      onItemView: onItemView,
      onTitle: onTitle ?? (e) => e.label.text(),
      onSubtitle: onSubtitle,
      onLeading: onLeading,
      onTrailing: onTrailing,
      itemExtent: itemExtent,
      separator: separator,
      separatorIndentStart: separatorIndentStart,
      separatorIndentEnd: separatorIndentEnd,
      minTileVerticalPadding: minTileVerticalPadding,
      minTileLeadingWidth: minTileLeadingWidth,
      minTileHeight: minTileHeight,
    );
  }

  static Future<XAction?> pickAction(
    List<XAction> items, {
    XAction? selected,
    Widget Function(XAction)? onItemView,
    Widget? Function(XAction)? onTitle,
    Widget? Function(XAction)? onSubtitle,
    Widget? Function(XAction)? onLeading,
    Widget? Function(XAction)? onTrailing,
    double? itemExtent,
    bool separator = true,
    double separatorIndentStart = 0,
    double separatorIndentEnd = 0,
    double? minTileVerticalPadding,
    double? minTileLeadingWidth,
    double? minTileHeight,
    bool autoClick = true,
  }) async {
    XAction? sel = selected ?? items.firstOr((e) => e.checked);

    XAction? ac = await pickItem(
      items,
      selected: sel,
      onItemView: onItemView,
      onTitle: onTitle ?? (a) => a.titleWidget,
      onLeading: onLeading ?? (a) => a.iconWidget,
      onSubtitle: onSubtitle,
      onTrailing: onTrailing,
      itemExtent: itemExtent,
      separator: separator,
      separatorIndentStart: separatorIndentStart,
      separatorIndentEnd: separatorIndentEnd,
      minTileVerticalPadding: minTileVerticalPadding,
      minTileLeadingWidth: minTileLeadingWidth,
      minTileHeight: minTileHeight,
    );
    if (autoClick) {
      ac?.onclick();
    }
    return ac;
  }

  static Future<T?> pickItem<T>(
    List<T> items, {
    T? selected,
    Widget Function(T)? onItemView,
    Widget? Function(T)? onTitle,
    Widget? Function(T)? onSubtitle,
    Widget? Function(T)? onLeading,
    Widget? Function(T)? onTrailing,
    double? itemExtent,
    bool separator = true,
    double separatorIndentStart = 0,
    double separatorIndentEnd = 0,
    double? minTileVerticalPadding,
    double? minTileLeadingWidth,
    double? minTileHeight,
  }) {
    return showModal((ctx) {
      return XListView(
        items: items,
        itemView: (cii) {
          T item = cii.item;
          bool check = item == selected;
          Widget cell =
              onItemView?.call(item).inkWell(onTap: () => ctx.maybePop(item)) ??
              ListTile(
                title: onTitle?.call(item) ?? item.toString().text(),
                leading: onLeading?.call(item),
                trailing: onTrailing?.call(item) ?? (check ? Icons.check.icon() : null),
                subtitle: onSubtitle?.call(item),
                onTap: () => ctx.maybePop(item),
                minVerticalPadding: minTileVerticalPadding,
                minLeadingWidth: minTileLeadingWidth,
                minTileHeight: minTileHeight,
                titleAlignment: ListTileTitleAlignment.center,
              );
          return cell;
        },
        shrinkWrap: true,
        itemExtent: itemExtent,
        separator: separator,
        separatorIndentStart: separatorIndentStart,
        separatorIndentEnd: separatorIndentEnd,
      );
    });
  }

  static Future<T?> pickGrid<T>(
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
  }) {
    return showModal((ctx) {
      return ItemsGridView(
        items: items,
        itemView: (c) {
          bool check = selected == c.item;
          Widget cell =
              onItemView?.call(c.item) ??
              GridTile(header: onHeader?.call(c.item), footer: onFooter?.call(c.item), child: onTitle?.call(c.item) ?? c.item!.toString().text().centered());
          if (check) {
            cell = cell.coloredBox(ctx.themeData.colorScheme.secondary.withOpacityX(0.2));
          }
          return cell.inkWell(
            onTap: () {
              ctx.maybePop(c.item);
            },
          );
        },
        shrinkWrap: true,
        crossAxisExtent: itemWidth,
        mainAxisExtent: itemHeight,
        columnCount: columnCount,
        childAspectRatio: aspectRatio,
        mainAxisSpacing: verticalSpacing,
        crossAxisSpacing: horizontalSpacing,
        padding: padding,
      );
    });
  }

  static Future<T?> showModal<T>(
    WidgetBuilder builder, {
    BuildContext? context,
    Color? backgroundColor,
    String? barrierLabel,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    // double scrollControlDisabledMaxHeightRatio = _defaultScrollControlDisabledMaxHeightRatio,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? showDragHandle,
    bool useSafeArea = false,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
    AnimationStyle? sheetAnimationStyle,
    bool? requestFocus,
    AnyMap? propMap,
  }) {
    return showModalBottomSheet(
      context: context ?? globalContext,
      builder: builder,
      backgroundColor: backgroundColor,
      barrierLabel: barrierLabel,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      sheetAnimationStyle: sheetAnimationStyle,
      requestFocus: requestFocus,
    );
  }

  static Future<T?> showModalUpdatable<T>(
    UpdableBuilder builder, {
    BuildContext? context,
    Color? backgroundColor,
    String? barrierLabel,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool? showDragHandle,
    bool useSafeArea = false,
    bool hasEdit = false,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
    AnimationStyle? sheetAnimationStyle,
    bool? requestFocus,
  }) {
    HareBuilder hb = HareBuilder();
    hb.builder = (c) => builder(UpdatableContext(context: c, updatable: hb));
    return showModalBottomSheet(
      context: context ?? globalContext,
      builder: (c) => !hasEdit
          ? hb
          : AnimatedPadding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom),
              duration: Duration(milliseconds: 50),
              child: hb,
            ),
      backgroundColor: backgroundColor,
      barrierLabel: barrierLabel,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: hasEdit || isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      sheetAnimationStyle: sheetAnimationStyle,
      requestFocus: requestFocus,
    );
  }
}
