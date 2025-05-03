// ignore_for_file: must_be_immutable, non_constant_identifier_names
part of '../fhare.dart';

class AnimPage extends HarePage with SingleTickerProviderMixin {
  late AnimationController controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

  AnimPage() : super() {
    pageLabel = "Anim";
  }

  bool expand = false;

  @override
  Widget build(BuildContext context) {
    late Animation<double> anim = Tween(begin: 0.0, end: 0.25).animate(controller);
    return ColumnMaxStretch(
      [
        RotationTransition(turns: anim, child: Icons.arrow_downward_outlined.icon()),
        AnimatedRotation(turns: expand ? 0 : 0.25, duration: const Duration(milliseconds: 300), child: Icons.arrow_downward_outlined.icon()),
        space(height: 24),
        AnimatedSlide(
          offset: expand ? const Offset(0, 100) : const Offset(0, -100),
          duration: const Duration(milliseconds: 1000),
          child: "Hello".text().centered().sizedBox(width: 150, height: 100).coloredBox(Colors.orange).centered(),
        ),
        space(height: 24),
        "Click".button(() {
          expand = !expand;
          if (expand) {
            controller.forward();
          } else {
            controller.reverse();
          }
          updateState();
        }),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ).coloredBox(Colors.cyan);
  }
}
