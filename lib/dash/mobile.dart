// ignore_for_file: must_be_immutable
part of '../dash.dart';

class MobileDashPage extends DashPage {
  int _selectedIndex = 0;
  List<HarePage> bottomItems;
  final Drawer? _drawer;
  TypeWidgetBuilder<Drawer>? drawerBuilder;

  MobileDashPage(this.bottomItems, {Drawer? drawer, this.drawerBuilder})
      : assert(bottomItems.isNotEmpty),
        _drawer = drawer,
        super();

  HarePage get currentItem => bottomItems[_selectedIndex];

  @override
  bool isTitleCenter() {
    return currentItem.isTitleCenter();
  }

  @override
  Drawer? buildDrawer(BuildContext context) {
    return drawerBuilder?.call(context) ?? _drawer;
  }

  @override
  Widget buildContent(BuildContext context) {
    return currentItem;
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
      items: bottomItems.mapList((e) => BottomNavigationBarItem(icon: e.pageIconWidget(), label: e.pageLabel)),
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (i) {
        _selectedIndex = i;
        updateState();
      },
    );
  }
}
