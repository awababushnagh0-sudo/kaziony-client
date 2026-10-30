import 'package:flutter/widgets.dart';

/// A thin dashed line across the width it's given: a receipt's rule, the
/// span of an offer's run.
class DashedLine extends StatelessWidget {
  const DashedLine({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(double.infinity, 1),
    painter: _DashesPainter(color),
  );
}

class _DashesPainter extends CustomPainter {
  const _DashesPainter(this.color);

  final Color color;

  static const _dash = 6.0;
  static const _gap = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += _dash + _gap) {
      canvas.drawLine(Offset(x, 0), Offset(x + _dash, 0), paint);
    }
  }

  @override
  bool shouldRepaint(_DashesPainter old) => old.color != color;
}
