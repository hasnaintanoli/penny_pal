import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Data class representing a category slice in the spending donut chart.
class SpendingCategoryData {
  final String title;
  final double amount;
  final double percentage;
  final Color color;

  const SpendingCategoryData({
    required this.title,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

/// Custom painted interactive donut chart with center total label.
class SpendingDonutChart extends StatelessWidget {
  final List<SpendingCategoryData> categories;
  final double totalAmount;
  final double size;
  final double strokeWidth;

  const SpendingDonutChart({
    super.key,
    required this.categories,
    required this.totalAmount,
    this.size = 120,
    this.strokeWidth = 22,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutChartPainter(
              categories: categories,
              strokeWidth: strokeWidth,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rs. ${_formatAmount(totalAmount.toInt())}',
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Total',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _formatAmount(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(',');
      }
    }
    return buffer.toString().split('').reversed.join('');
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<SpendingCategoryData> categories;
  final double strokeWidth;

  _DonutChartPainter({
    required this.categories,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    if (categories.isEmpty) {
      final emptyPaint = Paint()
        ..color = AppColors.borderLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, radius, emptyPaint);
      return;
    }

    double totalPercentage = categories.fold(0.0, (sum, item) => sum + item.percentage);
    if (totalPercentage <= 0) totalPercentage = 100.0;

    // Start from top (-90 degrees / -pi/2)
    double startAngle = -math.pi / 2;
    const double gapAngle = 0.04; // subtle gap between slices

    for (final category in categories) {
      final sweepAngle = (category.percentage / totalPercentage) * 2 * math.pi;
      final effectiveSweep = sweepAngle > gapAngle ? sweepAngle - gapAngle : sweepAngle;

      final paint = Paint()
        ..color = category.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = true;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + (gapAngle / 2),
        effectiveSweep,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.categories != categories || oldDelegate.strokeWidth != strokeWidth;
  }
}
