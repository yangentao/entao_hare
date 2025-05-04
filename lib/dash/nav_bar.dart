part of 'dash.dart';

class HareNavBar extends HareWidget {
  Widget? leading;
  Widget? middle;
  Widget? trailing;
  bool centerMiddle;
  double middleSpacing;
  double height;
  EdgeInsets? padding;

  HareNavBar({this.leading, this.middle, this.trailing, this.centerMiddle = true, this.middleSpacing = 16, this.height = 56, this.padding}) : super();

  @override
  Widget build(BuildContext context) {
    return NavigationToolbar(
      leading: leading,
      trailing: trailing,
      middle: middle,
      centerMiddle: centerMiddle,
      middleSpacing: middleSpacing,
    ).padded(padding!).constrainedBox(minHeight: height, maxHeight: height);
  }
}
