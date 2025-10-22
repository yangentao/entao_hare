// ignore_for_file: must_be_immutable
part of 'dash.dart';

abstract class DashPage extends HareWidget {
  bool _showDrawer = !Plat.isMobile;
  HareAppBar? appBar;
  HareBuilder? bodyBuilder;
  bool safeArea = true;

  DashPage() : super();

  void updateBody() {
    bodyBuilder?.updateState();
  }

  void updateAppBar() {
    if (!mounted) return;
    appBar?.title = buildTitle(context);
    appBar?.actions = buildActions(context);
    appBar?.centerTitle = isTitleCenter();
    appBar?.updateState();
  }

  void setTitle(Widget title) {
    appBar?.title = title;
    appBar?.updateState();
  }

  bool isTitleCenter() {
    return false;
  }

  void onBackPressed(BuildContext context) {
    context.maybePop();
  }

  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  Widget? buildTitle(BuildContext context) {
    return null;
  }

  Drawer? buildDrawer(BuildContext context) {
    return null;
  }

  Widget? buildBottomNavigationBar(BuildContext context) {
    return null;
  }

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    bool showBack = Navigator.of(context).canPop();

    Drawer? thisDrawer = buildDrawer(context);
    // bool largeScreen = context.largeScreen;
    // 调用MediaQuery.of(context) 会导致输入法打开又关闭.
    bool largeScreen = !Plat.isMobile;

    Widget? leadButton;
    if (thisDrawer != null) {
      leadButton = Builder(
        builder: (ctx) {
          return IconButton(
            onPressed: () {
              if (largeScreen) {
                _showDrawer = !_showDrawer;
                updateState();
              } else {
                Scaffold.of(ctx).openDrawer();
              }
            },
            icon: Icons.menu.icon(size: 32),
          );
        },
      );
    } else if (showBack) {
      leadButton = IconButton(
        onPressed: () {
          onBackPressed(context);
        },
        icon: Icons.keyboard_arrow_left.icon(size: 32),
      );
    }

    HareAppBar bar = HareAppBar(
      leading: leadButton,
      leadingWidth: (leadButton != null) ? 48 : null,
      titleSpacing: (leadButton != null) ? 0 : null,
      title: buildTitle(context),
      actions: buildActions(context),
      centerTitle: isTitleCenter(),
    ).also((e) => appBar = e);

    HareBuilder bBuilder = HareBuilder((c) => buildBody(c, thisDrawer, largeScreen) ?? Container());
    bodyBuilder = bBuilder;
    return buildScaffold(
      appBar: bar,
      bottomBar: buildBottomNavigationBar(context),
      drawer: largeScreen ? null : thisDrawer,
      body: safeArea ? Container(child: bBuilder).safeArea() : Container(child: bBuilder),
    );
  }

  Widget buildScaffold({PreferredSizeWidget? appBar, Widget? bottomBar, Widget? drawer, required Widget body}) {
    return Scaffold(key: UniqueKey(), appBar: appBar, bottomNavigationBar: bottomBar, drawer: drawer, body: body);
  }

  Widget? buildBody(BuildContext context, Drawer? drawer, bool largeScreen) {
    var content = buildContent(context);
    if (largeScreen && drawer != null && _showDrawer) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        verticalDirection: VerticalDirection.up,
        children: [
          drawer,
          Container(color: themeData.dividerColor, width: 1),
          content.expanded(),
        ],
      );
    } else {
      return content;
    }
  }
}
