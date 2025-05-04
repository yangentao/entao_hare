// ignore_for_file: must_be_immutable
part of 'dash.dart';

class ContentDashPage extends DashPage {
  DashSlot content;

  ContentDashPage(this.content) : super();

  @override
  Widget buildContent(BuildContext context) {
    return content;
  }

  @override
  bool isTitleCenter() {
    return content.isTitleCenter();
  }

  @override
  void onBackPressed(BuildContext context) {
    content.onBackPressed(context);
  }

  @override
  Widget? buildTitle(BuildContext context) {
    return content.buildTitle(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return content.buildActions(context);
  }

  @override
  Drawer? buildDrawer(BuildContext context) {
    return content.buildDrawer(context);
  }

  @override
  Widget? buildBottomNavigationBar(BuildContext context) {
    return content.buildBottomNavigationBar(context);
  }
}
