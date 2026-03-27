import 'package:flutter/material.dart';

class WaveformWidget extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color activeColor;
  final Color inactiveColor;
  final int barCount;

  const WaveformWidget({
    super.key,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    this.barCount = 35,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 40),
      painter: WaveformPainter(
        progress: progress,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        barCount: barCount,
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final int barCount;

  // Fixed sample heights to ensure consistency
  static const List<double> _heights = [
    0.3,
    0.5,
    0.8,
    0.4,
    0.6,
    0.9,
    0.3,
    0.5,
    0.7,
    0.4,
    0.6,
    0.8,
    0.5,
    0.3,
    0.6,
    0.9,
    0.4,
    0.7,
    0.3,
    0.5,
    0.8,
    0.4,
    0.6,
    0.9,
    0.3,
    0.5,
    0.7,
    0.4,
    0.6,
    0.8,
    0.5,
    0.3,
    0.6,
    0.9,
    0.4,
    0.7,
    0.3,
    0.5,
    0.8,
    0.4,
  ];

  WaveformPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.barCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final totalBarWidth = size.width / barCount;
    final barWidth = totalBarWidth * 0.54;

    for (int i = 0; i < barCount; i++) {
      final barHeight = size.height * _heights[i % _heights.length];
      final x = i * totalBarWidth;
      final y = (size.height - barHeight) / 2;

      final barProgress = i / barCount;
      paint.color = barProgress <= progress ? activeColor : inactiveColor;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          Radius.circular(barWidth / 2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor;
  }
}
