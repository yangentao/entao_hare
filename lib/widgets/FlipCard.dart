part of 'widgets.dart';

enum RotateFrom { left, right, top, bottom }

class FlipCardController {
  FlipCardState? state;

  Future flip() async => state?.flipCard();
}

class FlipCard extends StatefulWidget {
  final FlipCardController? controller;
  final Widget frontCard;
  final Widget backCard;
  final bool tapToFlipping;

  final RotateFrom rotateFrom;
  final Duration duration;
  final bool disableSplashEffect;
  final Color? splashColor;
  final Color? focusColor;

  const FlipCard({
    super.key,
    required this.frontCard,
    required this.backCard,
    this.controller,
    this.rotateFrom = RotateFrom.left,
    this.duration = const Duration(milliseconds: 500),
    this.tapToFlipping = false,
    this.focusColor,
    this.splashColor,
    this.disableSplashEffect = false,
  });

  @override
  FlipCardState createState() => FlipCardState();
}

class FlipCardState extends State<FlipCard> with TickerProviderStateMixin {
  late AnimationController animationController;
  bool isFront = true;
  double anglePlus = 0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: widget.duration, vsync: this);
    widget.controller?.state = this;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future flipCard() async {
    if (animationController.isAnimating) return;
    isFront = !isFront;
    await animationController.forward(from: 0).then((value) => anglePlus = math.pi);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animationController,
    builder: (context, child) {
      double piValue = (widget.rotateFrom == RotateFrom.top || widget.rotateFrom == RotateFrom.right) ? math.pi : -math.pi;
      double angle = animationController.value * piValue;
      late Matrix4 transform;
      late Matrix4 transformForBack;
      if (isFront) angle += anglePlus;
      bool rotateY = widget.rotateFrom == RotateFrom.right || widget.rotateFrom == RotateFrom.left;
      if (rotateY) {
        transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(angle);
        transformForBack = Matrix4.identity()..rotateY(math.pi);
      } else {
        transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(angle);
        transformForBack = Matrix4.identity()..rotateX(math.pi);
      }

      return InkWell(
        onTap: !widget.tapToFlipping ? null : () => flipCard(),
        splashColor: widget.splashColor,
        focusColor: widget.focusColor,
        overlayColor: widget.disableSplashEffect ? null : WidgetStateProperty.all(Colors.transparent),
        child: Transform(
          alignment: Alignment.center,
          transform: transform,
          child: _isFront(angle.abs()) ? widget.frontCard : Transform(transform: transformForBack, alignment: Alignment.center, child: widget.backCard),
        ),
      );
    },
  );

  bool _isFront(double angle) {
    return angle <= _degrees90 || angle >= _degrees270;
  }
}

const _degrees90 = math.pi / 2;
const _degrees270 = 3 * math.pi / 2;
