// ignore_for_file: must_be_immutable
part of 'dash.dart';

class MobileDashPage extends DashPage {
  int selectedIndex = 0;
  List<HarePage> bottomItems;
  final Drawer? drawer;
  TypeWidgetBuilder<Drawer>? drawerBuilder;

  MobileDashPage(this.bottomItems, {this.drawer, this.drawerBuilder}) : assert(bottomItems.isNotEmpty), super();

  HarePage get currentItem => bottomItems[selectedIndex];

  int get pageCount => bottomItems.length;

  void updateIndex(int n) {
    selectedIndex = n;
    updateState();
  }

  @override
  bool isTitleCenter() {
    return currentItem.isTitleCenter();
  }

  @override
  Drawer? buildDrawer(BuildContext context) {
    return drawerBuilder?.call(context) ?? drawer;
  }

  @override
  PreferredSizeWidget? buildAppBarBottom(BuildContext context) {
    return currentItem.buildAppBarBottom(context);
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
  Widget? buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: bottomItems.mapList((e) => BottomNavigationBarItem(icon: e.pageIconWidget(), label: e.pageLabel)),
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: updateIndex,
    );
  }
}
