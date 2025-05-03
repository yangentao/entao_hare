// ignore_for_file: must_be_immutable
part of '../fhare.dart';

extension BuildContextDashEx on BuildContext {
  void popDash<T extends Object>(HarePage page, [T? result]) {
    DesktopDashPage? ddp = this.findAncestorWidgetOfExactType();
    if (ddp != null) {
      ddp.pop(page);
      return;
    }
    this.maybePop(result);
  }

  @Deprecated("use pushDash instead")
  Future<T?> pushScaffold<T extends Object>(HarePage page, {bool? backButton, PropMap? data}) {
    return pushDash(page);
  }

  Future<T?> pushDash<T extends Object>(HarePage page) {
    DesktopDashPage? ddp = this.findAncestorWidgetOfExactType();
    if (ddp != null) {
      ddp.push(page);
      return Future.value(null);
    }
    return this.pushPage(page.toDash());
  }

  Future<T?> replaceDash<T extends Object>(HarePage page) {
    DesktopDashPage? ddp = this.findAncestorWidgetOfExactType();
    if (ddp != null) {
      ddp.replace(page);
      return Future.value(null);
    }
    return this.replacePage(page.toDash());
  }

  DashPage? findDash() {
    MobileDashPage? mp = findAncestorWidgetOfExactType();
    if (mp != null) return mp;
    DesktopDashPage? ddp = findAncestorWidgetOfExactType();
    if (ddp != null) return ddp;
    ContentDashPage? cp = findAncestorWidgetOfExactType();
    return cp;
  }

  void updateBody() {
    findDash()?.updateBody();
  }

  void updateAppBar() {
    findDash()?.updateAppBar();
  }

  void updateDashPage() {
    findDash()?.updateState();
  }
}

extension HarePageDashExt on HarePage {
  Future<T?> replaceDash<T extends Object>(HarePage page) {
    return context.replaceDash(page);
  }

  Future<T?> pushDash<T extends Object>(HarePage page) {
    return context.pushDash(page);
  }

  @Deprecated("use popDash instead")
  void pop<T extends Object>([T? result]) {
    context.popDash<T>(this, result);
  }

  void popDash<T extends Object>([T? result]) {
    context.popDash<T>(this, result);
  }

  @Deprecated("use updateDash instead")
  void updateScaffold() {
    updateDash();
  }

  void updateDash() {
    if (!mounted) return;
    context.updateDashPage();
  }

  void updateAppBar() {
    if (!mounted) return;
    context.updateAppBar();
  }

  void updateBody() {
    if (!mounted) return;
    context.updateBody();
  }
}

extension DashSlotExt<T extends DashSlot> on T {
  ContentDashPage toDash() {
    return ContentDashPage(this);
  }
}
