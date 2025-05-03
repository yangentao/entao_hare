// ignore_for_file: must_be_immutable
part of 'harepage.dart';

abstract class GroupHarePage extends HarePage {
  GroupHarePage() : super();
  List<HarePage> children = [];
}

abstract class HarePage extends HareWidget with DashSlot, OnMessage {
  //用于tabbar/drawer/bottombar的情况下, 没有设置title的时候,pageLabel用作title
  IconData pageIcon = Icons.home;
  String pageLabel = "Title";

  HarePage() : super() {
    MsgCenter.add(this);
  }

  Widget pageIconWidget() {
    return pageIcon.icon();
  }

  @override
  State<HareWidget> createState() {
    return HareWidgetState();
  }

  @override
  void onDestroy() {
    MsgCenter.remove(this);
    super.onDestroy();
  }

  @override
  void onMsg(Msg msg) {}

  @override
  Widget? buildTitle(BuildContext context) {
    return title ?? pageLabel.text();
  }

  void setTitle(String text) {
    if (title == null) {
      title = HareText(text);
    } else {
      HareText? ht = title as HareText;
      ht.update(text);
    }
  }

  Future<void> loading(Future<void> Function() callback) async {
    await Loading.loading(callback);
  }
}
