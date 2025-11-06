// ignore_for_file: must_be_immutable
part of 'table.dart';

extension PaginationListResultExt on XPagination {
  void updateByItemsResult(ItemsResult lr) {
    this.update(total: lr.totalOrSize, offset: lr.offset);
  }
}

class PaginationInfo {
  final int offset;
  final int total;
  final int pageSize;

  PaginationInfo({required this.pageSize, required this.total, required this.offset});

  @override
  String toString() {
    return "PaginationInfo{ pageSize:$pageSize, total:$total, offset:$offset }";
  }
}

class XPagination extends HareWidget {
  static final List<int> pageSizeList = const [10, 15, 20, 30, 50];
  final IntAttribute _localPageSize;
  int offset = 0;
  int total = 0;
  void Function(PaginationInfo)? onChange;

  XPagination({String pageId = "global", this.onChange})
    : _localPageSize = IntAttribute(key: "pagesize_$pageId", missValue: 15, provider: PreferProvider.instance),
      super();

  int get pageSize => _localPageSize.value;

  int get pageCount {
    return (total + pageSize - 1) ~/ pageSize;
  }

  /// from 0
  int get currentPage {
    return (offset + pageSize - 1) ~/ pageSize;
  }

  PaginationInfo get paginationInfo => PaginationInfo(pageSize: pageSize, total: total, offset: offset);

  void fireChange() {
    updateState();
    onChange?.call(paginationInfo);
  }

  void update({int? total, int? offset}) {
    if (total != null) this.total = total;
    if (offset != null) this.offset = offset;
    this.updateState();
  }

  @override
  Widget build(BuildContext context) {
    int start = (currentPage - 20).GE(0);
    int end = (currentPage + 21).LE(pageCount);
    IntRange pageRange = start.until(end);
    return Container(
      height: 48,
      padding: edges(left: 16, right: 10),
      child: WrapRow([
        IconButton(onPressed: offset <= 0 ? null : _first, iconSize: 16, icon: Icons.keyboard_double_arrow_left.icon()),
        IconButton(onPressed: offset <= 0 ? null : _pre, iconSize: 16, icon: Icons.keyboard_arrow_left.icon()),
        IconButton(onPressed: (offset + pageSize) >= total ? null : _next, iconSize: 16, icon: Icons.keyboard_arrow_right.icon()),
        IconButton(onPressed: (offset + pageSize) >= total ? null : _last, iconSize: 16, icon: Icons.keyboard_double_arrow_right.icon()),
        space(width: 4),
        DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: currentPage,
            items: pageRange.mapList((e) => DropdownMenuItem<int>(value: e, child: "第${e + 1}页".text())),
            focusColor: Colors.transparent,
            style: themeData.textTheme.bodySmall,
            onChanged: _onPageChange,
          ),
        ),
        space(width: 4),
        DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: pageSize,
            items: pageSizeList.mapList((e) => DropdownMenuItem<int>(value: e, child: "每页$e条".text())),
            focusColor: Colors.transparent,
            style: themeData.textTheme.bodySmall,
            onChanged: _onSizeChange,
          ),
        ),
        space(width: 4),
        "共$pageCount页 共$total条".text(style: themeData.textTheme.bodySmall),
      ], spacing: 0),
    );
  }

  void _onPageChange(int? page) {
    if (page != null && page >= 0) offset = (page * pageSize).limitOpen(0, total);
    fireChange();
  }

  void _onSizeChange(int? size) {
    if (size != null && size > 0) _localPageSize.value = size;
    fireChange();
  }

  void _first() {
    offset = 0;
    fireChange();
  }

  void _last() {
    int modValue = total % pageSize;
    if (modValue > 0) {
      offset = total - modValue;
    } else {
      offset = total - pageSize;
    }
    if (offset < 0) offset = 0;
    fireChange();
  }

  void _pre() {
    offset -= pageSize;
    if (offset < 0) offset = 0;
    fireChange();
  }

  void _next() {
    offset += pageSize;
    if (offset > total - 1) offset = total - 1;
    fireChange();
  }
}
