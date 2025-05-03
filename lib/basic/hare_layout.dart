part of '../basic.dart';

enum LastRow { keep, row, lastItem }

class HareLayout extends MultiChildRenderObjectWidget {
  final LastRow lastRow;
  final EdgeInsets padding;
  final double itemWidth;
  final double spaceX;
  final double spaceY;

  const HareLayout({
    super.key,
    required super.children,
    this.itemWidth = 240,
    this.lastRow = LastRow.lastItem,
    this.padding = const EdgeInsets.all(0),
    this.spaceX = 8,
    this.spaceY = 8,
  });

  @override
  HareRenderBox createRenderObject(BuildContext context) {
    return HareRenderBox(itemWidth: itemWidth, lastRow: lastRow, padding: padding, spaceX: spaceX, spaceY: spaceY);
  }
}

class HareRenderBox extends RenderBox with ContainerRenderObjectMixin<RenderBox, HareParentData>, RenderBoxContainerDefaultsMixin<RenderBox, HareParentData> {
  final LastRow lastRow;
  final EdgeInsets padding;
  final double itemWidth;
  final double spaceX;
  final double spaceY;

  HareRenderBox({required this.itemWidth, required this.lastRow, required this.padding, required this.spaceX, required this.spaceY});

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! HareParentData) {
      child.parentData = HareParentData();
    }
  }

  List<RenderBox> _childList() {
    List<RenderBox> ls = [];
    RenderBox? child = firstChild;
    while (child != null) {
      ls << child;
      child = child.parentDataHare.nextSibling;
    }
    return ls;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    println("h: ", height);
    return _childList().map((ch) {
          return ch.getMinIntrinsicWidth(height);
        }).maxValue() ??
        0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    println("h2: ", height);
    return _childList().map((ch) {
          return ch.getMaxIntrinsicWidth(height);
        }).maxValue() ??
        0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    println("w: ", width);
    return _childList().map((ch) {
          return ch.getMinIntrinsicHeight(width);
        }).maxValue() ??
        0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    println("w2: ", width);
    return _childList().map((ch) {
          return ch.getMaxIntrinsicHeight(width);
        }).maxValue() ??
        0;
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.biggest;
      assert(size.isFinite);
      return;
    }
    List<RenderBox> chList = _childList();

    int count = chList.length;

    double calcWidth(double widthParent, int colCount) {
      assert(colCount > 0);
      double w = widthParent - padding.left - padding.right - (colCount - 1) * spaceX;
      return (w / colCount).GE(0.0);
    }

    double widthParent = constraints.maxWidth;

    int colCount = 1;
    double cellWidth = calcWidth(widthParent, colCount);
    if (widthParent > itemWidth) {
      colCount = (widthParent / itemWidth).floor();
      cellWidth = calcWidth(widthParent, colCount);
    }
    if (count < colCount) {
      colCount = count;
      cellWidth = calcWidth(widthParent, colCount);
    }
    double x = 0;
    double y = padding.top;
    double rowHeight = 0;

    for (int i = 0; i < count; ++i) {
      if (i % colCount == 0) {
        y += rowHeight;
        if (i != 0) {
          y += spaceY;
        }
        rowHeight = 0;
        x = padding.left;
        if (lastRow == LastRow.row) {
          if (count - i < colCount) {
            cellWidth = calcWidth(widthParent, count - i);
          }
        }
      }
      if (lastRow == LastRow.lastItem) {
        if (i == count - 1) {
          cellWidth = (widthParent - x - padding.right).GE(0);
        }
      }
      RenderBox child = chList[i];
      child.layout(BoxConstraints.tightFor(width: cellWidth), parentUsesSize: true);
      Size sz = child.size;
      child.parentDataHare.offset = Offset(x, y);
      x += sz.width + spaceX;
      rowHeight = math.max(sz.height, rowHeight);
    }
    y += rowHeight + padding.bottom;
    size = Size(widthParent, y);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(HitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(
      result as BoxHitTestResult,
      position: position,
    );
  }
}

class HareParentData extends ContainerBoxParentData<RenderBox> {}

extension _CustomParentData on RenderBox {
  HareParentData get parentDataHare {
    return this.parentData as HareParentData;
  }
}
