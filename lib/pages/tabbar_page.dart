// ignore_for_file: must_be_immutable
part of '../entao_hare.dart';

class TabbarPage extends GroupHarePage with TickerProviderMixin {
  Color labelColor;
  bool hideBarWhenOne;
  bool allowClose;
  bool showIcon;
  bool tabOnTop;
  int _index;

  TabController? controller;

  TabbarPage({List<HarePage>? pages, int index = 0, this.hideBarWhenOne = false, this.allowClose = false, this.tabOnTop = true, this.showIcon = false, Color? color})
      : _index = index,
        labelColor = color ?? Colors.lightBlue,
        super() {
    children = pages ?? [];
  }

  int get tabCount => children.length;

  int get currentIndex => controller?.index ?? _index;

  set currentIndex(int idx) {
    if (controller != null) {
      controller!.index = idx;
    } else {
      _index = idx;
    }
  }

  @override
  void onCreate() {
    controller = TabController(initialIndex: _index, length: children.length, vsync: this);
    controller?.addListener(() {
      _index = currentIndex;
    });
    super.onCreate();
  }

  void selectTab({HarePage? page, int? index}) {
    if (index != null) {
      currentIndex = index.limitOpen(0, tabCount);
    } else if (page != null) {
      currentIndex = children.indexOf(page).limitOpen(0, tabCount);
    }
  }

  void selectLastTab() {
    currentIndex = (tabCount - 1).GE(0);
  }

  void addTab(HarePage tabPage) {
    if (children.contains(tabPage)) return;
    children.add(tabPage);
    _index = currentIndex;
    controller = TabController(initialIndex: _index, length: children.length, vsync: this);
    updateState();
  }

  void removeTab({HarePage? page, int? index}) {
    if (index != null && index >= 0 && index < tabCount) {
      children.removeAt(index);
    } else if (page != null) {
      children.remove(page);
    }
    _index = (currentIndex - 1).GE(0);
    controller = TabController(initialIndex: _index, length: children.length, vsync: this);
    updateState();
  }

  Widget onBuildTab(BuildContext context, HarePage tabPage) {
    bool isFirst = tabPage == children.firstOrNull;
    return Stack(
      children: [
        RowMin([
          if (showIcon) tabPage.pageIcon.icon(size: 24),
          if (showIcon) space(width: 8),
          tabPage.pageLabel.text(),
        ]).centered(),
        if (allowClose && !isFirst)
          IconButton(
                  onPressed: () {
                    removeTab(page: tabPage);
                  },
                  icon: Icons.close.icon(size: 16))
              .align(Alignment.centerRight),
      ],
    ).tab();
  }

  Widget onBuildTabView(BuildContext context, Widget tabPage) {
    return tabPage;
  }

  Widget onEmptyContent(BuildContext context) {
    return "没有内容".text().centered();
  }

  @override
  Widget build(BuildContext context) {
    if (tabCount == 0) return onEmptyContent(context);
    if (tabCount == 1 && hideBarWhenOne) return onBuildTabView(context, children.first).centered();
    return ColumnMaxStretch([
      if (tabOnTop) TabBar(controller: controller, labelColor: labelColor, tabs: [for (var p in children) onBuildTab(context, p)], onTap: (e) => currentIndex = e),
      if (tabOnTop) separator(height: 1),
      TabBarView(controller: controller, children: [for (var p in children) onBuildTabView(context, p)]).expanded(),
      if (!tabOnTop) separator(height: 1),
      if (!tabOnTop) TabBar(controller: controller, labelColor: labelColor, tabs: [for (var p in children) onBuildTab(context, p)], onTap: (e) => currentIndex = e),
    ]);
  }
}
