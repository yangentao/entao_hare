part of 'widgets.dart';

/// [-160, 0]
class AmplitudeWidget extends HareWidget {
  final double area;
  final double minRatio;
  final double lineWidth;
  final double spaceWidth;
  final Color lineColor;
  final Color horLineColor;
  final double horLineWidth;
  final bool hasHorLine;
  final int maxLength;
  List<double> data = [];
  int _preTime = 0;

  // ignore: use_key_in_widget_constructors
  AmplitudeWidget({
    this.maxLength = 600,
    this.area = 0.9,
    this.minRatio = 0.1,
    this.lineWidth = 1,
    this.spaceWidth = 1,
    this.lineColor = Colors.amber,
    this.horLineWidth = 0.2,
    this.horLineColor = Colors.grey,
    this.hasHorLine = true,
  });

  void clear() {
    data.clear();
    updateState();
  }

  void flush() {
    updateState();
  }

  void _tryFlush() {
    int now = millsNow;
    if (now - _preTime >= 100) {
      _preTime = now;
      updateState();
    }
  }

  void add(double a) {
    data.add(a);
    if (data.length > maxLength + 10) {
      data.removeRange(0, data.length - maxLength);
    }
    _tryFlush();
  }

  void addAll(List<double> ls) {
    data.addAll(ls);
    if (data.length > maxLength + 10) {
      data.removeRange(0, data.length - maxLength);
    }
    _tryFlush();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AmpPainter(
        data: List<double>.from(data),
        area: area,
        minRatio: minRatio,
        lineWidth: lineWidth,
        lineColor: lineColor,
        spaceWidth: spaceWidth,
        horLineColor: horLineColor,
        horLineWidth: horLineWidth,
        hasHorLine: hasHorLine,
      ),
    );
  }
}

class AmpPainter extends CustomPainter {
  final double area;
  final double minRatio;
  final double lineWidth;
  final double spaceWidth;
  final Color lineColor;
  final Color horLineColor;
  final double horLineWidth;
  final bool hasHorLine;
  final List<double> data;

  AmpPainter({
    required this.data,
    this.area = 0.9,
    this.minRatio = 0.1,
    this.lineWidth = 1,
    this.spaceWidth = 1,
    this.lineColor = Colors.amber,
    this.horLineWidth = 0.2,
    this.horLineColor = Colors.white30,
    this.hasHorLine = true,
  });

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    double wItem = lineWidth + spaceWidth;
    int itemCount = (size.width / wItem).round();
    int fromIndex = data.length < itemCount ? 0 : data.length - itemCount;
    List<double> ls = fromIndex == 0 ? data : data.sublist(fromIndex);
    double maxValue = ls.maxValue() ?? 0;
    double minValue = ls.minValue() ?? 0;

    minValue -= (maxValue - minValue) * minRatio;

    double valueRange = maxValue - minValue;
    double scale = valueRange == 0 ? 0.1 : size.height * area / valueRange;

    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    if (hasHorLine) {
      paint.color = horLineColor;
      paint.strokeWidth = horLineWidth;
      canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    }
    paint.strokeWidth = lineWidth;
    paint.color = lineColor;

    for (int i = 0; i < ls.length; ++i) {
      double value = ls[i];
      double x = i * wItem;
      double h = (value - minValue) * scale;
      canvas.drawLine(Offset(x, (size.height - h) / 2), Offset(x, (size.height + h) / 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
