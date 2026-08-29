import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FoxtrotLogo extends StatelessWidget {
  final double size;

  const FoxtrotLogo({super.key, this.size = 112});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.square(size),
        painter: _FoxtrotLogoPainter(context.palette),
      ),
    );
  }
}

class _FoxtrotLogoPainter extends CustomPainter {
  const _FoxtrotLogoPainter(this.palette);

  final FoxtrotPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = s / 2;

    Offset p(double x, double y) => Offset(x * s, y * s);

    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [palette.card, palette.surface],
      ).createShader(Offset.zero & size);
    canvas.drawCircle(center, radius, backgroundPaint);

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          palette.accent.withValues(alpha: 0.16),
          palette.accent.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.85));
    canvas.drawCircle(center, radius * 0.85, glowPaint);

    final outerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.02
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        transform: const GradientRotation(-math.pi / 3),
        colors: [
          palette.accent.withValues(alpha: 0.9),
          palette.accentSoft,
          palette.accent.withValues(alpha: 0.35),
          palette.accent.withValues(alpha: 0.9),
        ],
        stops: const [0.0, 0.25, 0.65, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawCircle(center, radius - s * 0.012, outerRingPaint);

    final innerRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.008
      ..color = palette.accent.withValues(alpha: 0.35);
    canvas.drawCircle(center, radius * 0.86, innerRingPaint);

    final tickPaint = Paint()
      ..strokeWidth = s * 0.008
      ..strokeCap = StrokeCap.round
      ..color = palette.accent.withValues(alpha: 0.5);
    for (var i = 0; i < 4; i++) {
      final angle = math.pi / 4 + i * math.pi / 2;
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + direction * radius * 0.86,
        center + direction * radius * 0.92,
        tickPaint,
      );
    }

    final strokeShader = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [palette.accentSoft, palette.accent],
    ).createShader(Offset.zero & size);

    final fPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.052
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = strokeShader;

    final stem = Path()
      ..moveTo(p(0.655, 0.245).dx, p(0.655, 0.245).dy)
      ..cubicTo(
        p(0.645, 0.165).dx,
        p(0.645, 0.165).dy,
        p(0.535, 0.150).dx,
        p(0.535, 0.150).dy,
        p(0.495, 0.235).dx,
        p(0.495, 0.235).dy,
      )
      ..cubicTo(
        p(0.460, 0.310).dx,
        p(0.460, 0.310).dy,
        p(0.445, 0.430).dx,
        p(0.445, 0.430).dy,
        p(0.430, 0.520).dx,
        p(0.430, 0.520).dy,
      )
      ..cubicTo(
        p(0.415, 0.610).dx,
        p(0.415, 0.610).dy,
        p(0.400, 0.700).dx,
        p(0.400, 0.700).dy,
        p(0.365, 0.760).dx,
        p(0.365, 0.760).dy,
      )
      ..cubicTo(
        p(0.325, 0.830).dx,
        p(0.325, 0.830).dy,
        p(0.245, 0.825).dx,
        p(0.245, 0.825).dy,
        p(0.235, 0.755).dx,
        p(0.235, 0.755).dy,
      );
    canvas.drawPath(stem, fPaint);

    final crossbar = Path()
      ..moveTo(p(0.335, 0.475).dx, p(0.335, 0.475).dy)
      ..lineTo(p(0.590, 0.455).dx, p(0.590, 0.455).dy);
    canvas.drawPath(crossbar, fPaint);

    final dotPaint = Paint()..shader = strokeShader;
    canvas.drawCircle(p(0.665, 0.745), s * 0.036, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _FoxtrotLogoPainter oldDelegate) =>
      oldDelegate.palette != palette;
}
