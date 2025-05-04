// ignore_for_file: must_be_immutable

part of '../entao_hare.dart';

class BottomBarPage extends HarePage {
  int _selectedIndex = 0;
  List<HarePage> items;

  BottomBarPage(this.items)
      : assert(items.isNotEmpty),
        super();

  HarePage get currentItem => items[_selectedIndex];

  @override
  bool isTitleCenter() {
    return currentItem.isTitleCenter();
  }

  @override
  Widget? buildTitle(BuildContext context) {
    var item = currentItem;
    return item.buildTitle(context) ?? Text(item.pageLabel);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return currentItem.buildActions(context);
  }

  @override
  BottomNavigationBar? buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: items.mapList((e) => BottomNavigationBarItem(icon: e.pageIcon.icon(), label: e.pageLabel)),
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (i) {
        _selectedIndex = i;
        updateState();
        updateDash();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return currentItem;
  }
}
