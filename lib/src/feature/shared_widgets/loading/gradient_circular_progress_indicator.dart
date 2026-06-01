import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Creates the static Loading Spinner. Requires the [radius], [gradientColors]
/// and [strokeWidth]
class const GradientCircularProgressIndicator({
  /// The radius size of the spinner
  required final double radius,

  /// It requires a list of colors to create the gradient
  required final List<Color> gradientColors,

  /// The width of the loading wheel
  required final double strokeWidth,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size.fromRadius(radius),
        painter: _GradientCircularProgressPainter(
          radius: radius,
          gradientColors: gradientColors,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

/// Draws the loading wheel through the paint method. Must provide [radius],
/// [gradientColors]
class _GradientCircularProgressPainter({
  /// The radius size of the spinner
  required final double radius,

  /// Requires a list of colors to create the gradient
  required final List<Color> gradientColors,

  /// The width of the loading wheel
  required final double strokeWidth,
}) extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double centerPoint = size.height / 2;

    // double strokeWidth = 30;
    const double percentValue = 100 / 100;
    final radius = centerPoint;

    final paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = SweepGradient(
        colors: gradientColors,
        tileMode: TileMode.repeated,
        startAngle: _degreeToRad(270),
        endAngle: _degreeToRad(270 + 360.0),
      ).createShader(Rect.fromCircle(center: Offset(centerPoint, centerPoint), radius: 0));

    final rect = Rect.fromCircle(center: Offset(centerPoint, centerPoint), radius: radius);

    final double scapSize = strokeWidth / 2;
    final double scapToDegree = scapSize / radius;

    final double startAngle = _degreeToRad(270) + scapToDegree;
    final double sweepAngle = _degreeToRad(360) - (2 * scapToDegree);

    canvas.drawArc(rect, startAngle, percentValue * sweepAngle, false, paint);
  }

  double _degreeToRad(double degree) => degree * math.pi / 180;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
