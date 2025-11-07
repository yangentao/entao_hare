part of 'pages.dart';

class LogPage extends ListPage<LogItem> {
  MemLogPrinter memLog;
  late ToggleIcon dirIcon = ToggleIcon(
    value: true,
    onPrimary: true,
    on: Icons.arrow_upward_outlined.icon(),
    off: Icons.arrow_downward_outlined.icon(),
    onChanged: (e) => refreshItems(),
  );
  late ToggleIcon loadIcon = ToggleIcon(value: true, onPrimary: true, on: Icons.auto_mode.icon(), off: Icons.block.icon(), onChanged: (e) => refreshItems());

  // ignore: use_key_in_widget_constructors
  LogPage({int maxSize = 1000}) : memLog = MemLogPrinter(maxSize) {
    this.pageIcon = Icons.list;
    this.pageLabel = "日志";

    actions = [loadIcon, dirIcon];
    memLog.onChanged = () {
      if (loadIcon.value) {
        this.refreshItems();
      }
    };
    XLog.addPrinter(memLog);
  }

  @override
  void onMsg(Msg msg) {
    if (msg.msg == "msg.tab_double_Tap") {
      scrollController.jumpTo(0);
      return;
    }
    super.onMsg(msg);
  }

  @override
  void onDestroy() {
    XLog.removePrinter((e) => e == memLog);
    super.onDestroy();
  }

  @override
  Widget onItemView(ContextIndexItem<LogItem> item) {
    return ListTile(
      title: item.item.message.text(color: item.item.level >= LogLevel.error ? Colors.redAccent : (item.item.level >= LogLevel.warning ? Colors.amber : null)),
      subtitle: RowMax([("${item.item.level.name[0].toUpperCase()} ${item.item.tag}").text(), Spacer(), item.item.time.formatTimeX.text()]),
    );
  }

  @override
  Future<List<LogItem>> onRequestItems() async {
    var ls = memLog.items;
    if (dirIcon.value) return ls.reversed.toList();
    return ls;
  }
}

extension on DateTime {
  String get formatTimeX => "${hour.formated("00")}:${minute.formated("00")}:${second.formated("00")}.${millisecond.formated("000")}";
}

class MemLogPrinter extends LogPrinter {
  final List<LogItem> items = [];
  final int maxLength;
  final int overSize;

  VoidCallback? onChanged;

  MemLogPrinter(this.maxLength) : overSize = (maxLength ~/ 10).GE(1) {
    assert(maxLength >= 2);
  }

  @override
  void printItem(LogItem item) {
    items.add(item);
    if (items.length > maxLength + overSize) {
      items.removeRange(0, overSize);
    }
    onChanged?.call();
  }

  void clear() {
    items.clear();
  }
}
