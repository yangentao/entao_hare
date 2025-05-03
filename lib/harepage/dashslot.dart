part of '../entao_harepage.dart';


mixin DashSlot on Widget {
  bool centerTitle = true;
  Widget? title;
  List<Widget> actions = [];

  bool isTitleCenter() {
    return centerTitle;
  }

  List<Widget>? buildActions(BuildContext context) {
    return actions;
  }

  Widget? buildTitle(BuildContext context) {
    return title;
  }

  BottomNavigationBar? buildBottomNavigationBar(BuildContext context) {
    return null;
  }

  Drawer? buildDrawer(BuildContext context) {
    return null;
  }

  Future<void> onBackPressed(BuildContext context) async {
    Navigator.of(context).maybePop();
  }
}
