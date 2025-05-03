// ignore_for_file: must_be_immutable
part of '../fhare.dart';

mixin RefreshItemsMixin<T> on HarePage {
  List<T> items = [];

  @override
  void postCreate() {
    super.postCreate();
    onPrepareData().whenComplete(refreshItems);
  }

  Future<void> onPrepareData() async {}

  Future<List<T>> onRequestItems();

  Future<void> afterRequestItems() async {}

  Future<void> refreshItems() async {
    items = await onRequestItems();
    await afterRequestItems(); // no wait
    updateState();
  }

  Future<void> reloadItems() async {
    await loading(() async => await refreshItems());
  }
}
mixin RefreshMixin on HarePage {
  @override
  void postCreate() {
    super.postCreate();
    onPrepareData().whenComplete(refreshItems);
  }

  Future<void> onPrepareData() async {}

  Future<void> onRequestItems();

  Future<void> afterRequestItems() async {}

  Future<void> refreshItems() async {
    await onRequestItems();
    await afterRequestItems(); // no wait
    updateState();
  }

  Future<void> reloadItems() async {
    await loading(() async => await refreshItems());
  }
}
