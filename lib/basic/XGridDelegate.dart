part of 'basic.dart';

class XGridDelegate extends SliverGridDelegate {
  const XGridDelegate({
    this.crossAxisExtent = 0,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.mainAxisExtent,
    this.columnCount = 0,
    double flexPercent = 0.15, //剩余空间 > (1-flexPercent)时, column += 1
  })  : assert(crossAxisExtent > 0 || columnCount > 0),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing >= 0),
        assert(childAspectRatio > 0),
        flexPercent = flexPercent < 0 ? 0 : (flexPercent > 0.5 ? 0.5 : flexPercent);

  final double flexPercent;
  final double crossAxisExtent;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double childAspectRatio;

  final double? mainAxisExtent;
  final int columnCount;

  bool _debugAssertIsValid(double crossAxisExtent) {
    assert(crossAxisExtent > 0.0 || columnCount > 0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    assert(childAspectRatio > 0.0);
    assert(flexPercent >= 0 && flexPercent < 1);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid(constraints.crossAxisExtent));
    if (columnCount > 0) {
      final double usableCrossAxisExtent = math.max(
        0.0,
        constraints.crossAxisExtent - crossAxisSpacing * (columnCount - 1),
      );
      final double childCrossAxisExtent = usableCrossAxisExtent / columnCount;
      final double childMainAxisExtent = mainAxisExtent ?? childCrossAxisExtent / childAspectRatio;
      return SliverGridRegularTileLayout(
        crossAxisCount: columnCount,
        mainAxisStride: childMainAxisExtent + mainAxisSpacing,
        crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
        childMainAxisExtent: childMainAxisExtent,
        childCrossAxisExtent: childCrossAxisExtent,
        reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
      );
    } else {
      int crossAxisCount = (constraints.crossAxisExtent + crossAxisSpacing) ~/ (crossAxisExtent + crossAxisSpacing);
      crossAxisCount = crossAxisCount.GE(1);
      double leftSize = (constraints.crossAxisExtent + crossAxisSpacing) - (crossAxisExtent + crossAxisSpacing) * crossAxisCount;
      if (leftSize > 0 && (leftSize - crossAxisSpacing) >= crossAxisExtent * (1 - flexPercent)) {
        crossAxisCount += 1;
      }
      final double usableCrossAxisExtent = (constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1)).GE(0);
      final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
      final double childMainAxisExtent = mainAxisExtent ?? childCrossAxisExtent / childAspectRatio;
      return SliverGridRegularTileLayout(
        crossAxisCount: crossAxisCount,
        mainAxisStride: childMainAxisExtent + mainAxisSpacing,
        crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
        childMainAxisExtent: childMainAxisExtent,
        childCrossAxisExtent: childCrossAxisExtent,
        reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
      );
    }
  }

  @override
  bool shouldRelayout(XGridDelegate oldDelegate) {
    return oldDelegate.crossAxisExtent != crossAxisExtent ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.childAspectRatio != childAspectRatio ||
        oldDelegate.mainAxisExtent != mainAxisExtent ||
        oldDelegate.flexPercent != flexPercent ||
        oldDelegate.columnCount != columnCount;
  }
}
