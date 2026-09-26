import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A pixel-perfect vector representation of the official 4-color Google "G" logo.
class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(radius, radius);
    final double strokeWidth = size.width * 0.22;
    final double innerRadius = radius - strokeWidth / 2;

    final Rect rect = Rect.fromCircle(center: center, radius: innerRadius);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Red: Top arc (~215 deg to 345 deg)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, _degToRad(215), _degToRad(110), false, paint);

    // Yellow: Left bottom arc (~135 deg to 215 deg)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, _degToRad(135), _degToRad(80), false, paint);

    // Green: Bottom arc (~35 deg to 135 deg)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, _degToRad(35), _degToRad(100), false, paint);

    // Blue: Right arc (~325 deg to 35 deg)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, _degToRad(325), _degToRad(70), false, paint);

    // Blue Crossbar (Horizontal bar from center to right edge)
    final Paint fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF4285F4);

    final double barHeight = strokeWidth;
    final double barWidth = radius * 1.05;
    final Rect barRect = Rect.fromLTWH(
      center.dx - (strokeWidth * 0.1),
      center.dy - (barHeight / 2),
      barWidth,
      barHeight,
    );
    canvas.drawRect(barRect, fillPaint);
  }

  double _degToRad(double deg) => deg * (math.pi / 180.0);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
