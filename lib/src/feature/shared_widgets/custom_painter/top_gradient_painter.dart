import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class TopGradientPainter() extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gradient = ui.Gradient.radial(Offset.zero, size.width * 0.002659574, const [
      Color(0x20C5FF3F),
      Color(0x202AD162),
    ]);
    final paint0Fill = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    canvas.drawCircle(Offset(size.width * 0.5033165, size.height * 0.1111748), size.width * 0.35, paint0Fill);

    final paint1Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0x20FAFF12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    canvas.drawCircle(Offset(size.width * 0.2754601, size.height * 0.18), size.width * 0.2, paint1Fill);

    final paint2Fill = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    canvas.drawCircle(Offset(size.width * 0.7636888, size.height * 0.05553782), size.width * 0.25, paint2Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
