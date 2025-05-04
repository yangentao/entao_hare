// ignore_for_file: must_be_immutable

part of '../entao_hare.dart';

class TabListPage extends HarePage {
  int tabCount = 3;
  Color labelColor = Colors.lightBlue;

  TabListPage() : super();

  Widget buildTab(BuildContext context, int index) {
    return Tab(text: "tab $index");
  }

  Widget buildTabView(BuildContext context, int index) {
    return "TabView $index".text().centered();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabCount,
      child: ColumnMinStretch([
        TabBar(labelColor: labelColor, tabs: [for (var i in tabCount.indexes) buildTab(context, i)]),
        separator(height: 1),
        TabBarView(children: [for (var i in tabCount.indexes) buildTabView(context, i)]).expanded()
      ]),
    );
  }
}

class HareTabWidget extends HareWidget with SingleTickerProviderMixin {
  int length;
  Color? labelColor;
  TabController? tabController;
  int initialIndex;

  late IndexedWidgetBuilder onTab;
  late IndexedWidgetBuilder onTabView;

  HareTabWidget({required this.length, required this.onTab, required this.onTabView, this.initialIndex = 0, this.labelColor}) : super();

  HareTabWidget.fromPages(List<HarePage> pages, {IndexedWidgetBuilder? onTab, this.initialIndex = 0, this.labelColor})
      : length = pages.length,
        super() {
    this.onTab = onTab ?? (c, i) => Tab(text: pages[i].pageLabel);
    onTabView = (c, i) => pages[i];
  }

  HareTabWidget.fromItems({required List<String> labels, required List<Widget> pages, this.initialIndex = 0, this.labelColor})
      : length = pages.length,
        super() {
    assert(pages.isNotEmpty && pages.length == labels.length);
    this.onTab = (c, i) => Tab(text: labels[i]);
    onTabView = (c, i) => pages[i];
  }

  HareTabWidget.fromPairs(List<LabelValue<Widget>> pairs, { this.initialIndex = 0, this.labelColor})
      : length = pairs.length,
        super() {
    this.onTab = (c, i) => Tab(text: pairs[i].label);
    onTabView = (c, i) => pairs[i].value;
  }

  int get index => tabController?.index ?? 0;

  set index(int value) {
    tabController?.index = value;
  }

  @override
  void onDestroy() {
    tabController?.dispose();
    tabController = null;
    super.onDestroy();
  }

  @override
  Widget build(BuildContext context) {
    late TabController tc;
    if (tabController == null) {
      tc = TabController(length: length, vsync: this, initialIndex: initialIndex);
    } else {
      tc = tabController!;
    }
    return ColumnMinStretch([
      TabBar(controller: tc, labelColor: labelColor, tabs: [for (var i in length.indexes) onTab(context, i)]),
      separator(height: 1),
      TabBarView(controller: tc, children: [for (var i in length.indexes) onTabView(context, i)]).expanded()
    ]);
  }
}
