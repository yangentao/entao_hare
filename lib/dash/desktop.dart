// ignore_for_file: must_be_immutable
part of '../dash.dart';

class DrawerGroup extends HareWidget {
  final Widget title;
  final List<Widget> children;

  DrawerGroup(this.title, this.children) : super();

  @override
  Widget build(BuildContext context) {
    return title;
  }
}

class DesktopDashPage extends DashPage {
  final List<HarePage> _children = [];
  final List<Widget> actions = [];
  final Drawer? _drawer;
  final List<Widget> drawerItems = [];
  final List<Widget> tailDrawerItems = [];
  final HarePage? homePage;

  DesktopDashPage({Drawer? drawer, this.homePage})
      : _drawer = drawer,
        super() {
    if (this.homePage != null) {
      _children.add(homePage!);
    }
  }

  void addActions(List<Widget> actions) {
    this.actions.addAll(actions);
  }

  void addDrawerGroup(Widget title, List<Widget> subItems) {
    drawerItems.add(DrawerGroup(title, subItems));
  }

  void addTailDrawers(List<Widget> items) {
    tailDrawerItems.addAll(items);
  }

  void addDrawers(List<Widget> items) {
    drawerItems.addAll(items);
  }

  void addDrawerItem(Widget item) {
    drawerItems.add(item);
  }

  Widget _pageToTile(HarePage page, {bool sub = false}) {
    bool checked = _children.contains(page);
    if (sub) {
      return ListTile(title: page.pageLabel.text(), selected: checked, trailing: checked ? Icons.play_arrow_rounded.icon() : null, onTap: () => replace(page));
    }
    return ListTile(title: page.pageLabel.text(), leading: page.pageIcon.icon(), selected: checked, trailing: checked ? Icons.play_arrow_rounded.icon() : null, onTap: () => replace(page));
  }

  bool hasPage(Widget item) {
    if (item is HarePage) return _children.contains(item);
    return false;
  }

  Widget _makeDrawerItem(Widget item) {
    if (item is DrawerGroup) {
      bool checked = item.children.any((e) => hasPage(e));
      Color? color = checked ? null : themeData.textTheme.titleMedium?.color;
      return ExpansionTile(
        title: item.title,
        textColor: color,
        iconColor: color,
        childrenPadding: edges(all: 8, left: 24),
        initiallyExpanded: checked,
        controlAffinity: ListTileControlAffinity.leading,
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: item.children.mapList((e) => e is HarePage ? _pageToTile(e, sub: true) : e),
      );
    }
    if (item is HarePage) {
      return _pageToTile(item);
    }
    return item;
  }

  @override
  Drawer? buildDrawer(BuildContext context) {
    if (_drawer != null) return _drawer;
    if (drawerItems.isEmpty && tailDrawerItems.isEmpty) return null;
    List<Widget> heads = drawerItems.mapList((w) => _makeDrawerItem(w));
    List<Widget> tails = tailDrawerItems.mapList((w) => _makeDrawerItem(w));
    return Drawer(width: 200, child: ColumnMax([ListView(shrinkWrap: true, children: heads), Spacer(), ...tails]));
  }

  @override
  bool isTitleCenter() {
    return true;
  }

  @override
  Widget? buildTitle(BuildContext context) {
    return HareApp.title.text();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return actions;
  }

  Widget defaultWidget() {
    return HareApp.title.text().centered();
  }

  @override
  Widget buildContent(BuildContext context) {
    if (_children.isEmpty) return defaultWidget();
    HarePage page = _children.last;
    // List<Widget> pathList = _children.mapList((e) => TextButton(onPressed: () => popUntil(e), child: e.pageLabel.text()));
    List<BreadItem<HarePage>> breadList = _children.mapList((e) => BreadItem<HarePage>(label: e.pageLabel, icon: e.pageIcon.icon(), value: e, action: () => popUntil(e)));
    List<Widget> pageActions = page.buildActions(context) ?? [];
    return ColumnMaxStretch([
      HareNavBar(
        leading: BreadCrumb<HarePage>(items: breadList),
        trailing: RowMin(pageActions),
        padding: edges(right: 16),
        height: 48,
      ),
      // RowMax([
      //   ...pathList,
      //   Spacer(),
      //   ...pageActions,
      // ]).paddings(hor: 8, ver: 10),
      Divider(height: 1),
      page.expanded(),
    ]);
  }

  void push(HarePage page) {
    _children.add(page);
    updateState();
  }

  void replace(HarePage page) {
    _children.clear();
    if (homePage != null) _children.add(homePage!);
    _children.add(page);
    updateState();
  }

  //not keep this page
  void pop(HarePage p) {
    if (!_children.contains(p)) return;
    while (_children.isNotEmpty && _children.removeLast() != p) {}
    updateState();
  }

  //keep this page
  void popUntil(HarePage p) {
    if (!_children.contains(p)) return;
    while (_children.isNotEmpty && _children.last != p) {
      _children.removeLast();
    }
    updateState();
  }
}
