// ignore_for_file: must_be_immutable, non_constant_identifier_names
part of '../entao_hare.dart';

class PreparePage extends HarePage {
  Future<DataResult<Widget>> Function() prepare;
  String _msg = "加载中...";
  WidgetBuilder back;
  String? backLabel;
  bool? success;

  PreparePage({required this.back, required this.prepare, this.backLabel}) : super();

  Future<void> doPrepare() async {
    try {
      DataResult<Widget> br = await prepare();
      success = br.success;
      if (br.success) {
        if (context.mounted) context.replacePage(br.data!);
      } else {
        _msg = br.message ?? "加载失败";
        updateState();
      }
    } catch (e) {
      success = false;
      _msg = "加载失败: $e";
      updateState();
    }
  }

  Future<void> loadPrepare() async {
    return loading(doPrepare);
  }

  @override
  void onCreate() {
    super.onCreate();
    // delayMillSeconds(10, () {
    loadPrepare();
    // });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> ls = [
      _msg.titleMedium().centered(),
      IconButton(
        onPressed: loadPrepare,
        icon: Icons.refresh_rounded.icon(),
        iconSize: 32,
      ),
    ];
    if (success == false) {
      Widget w = back(context);
      String label = backLabel ?? w.castTo<HarePage>()?.pageLabel ?? "后退";
      ls.add(ElevatedButton(
        child: label.text(),
        onPressed: () {
          context.replacePage(w);
        },
      ).constrainedBox(minWidth: 70));
    }
    return ColumnMax(ls, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center).material();
  }
}
