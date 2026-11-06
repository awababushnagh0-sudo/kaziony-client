import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';

/// A heart: the icon set's outline, or filled in the favorites' pink-red
/// once saved. Drawn when filled, as the icon set's hearts are outlines only.
class HeartMaterial extends StatelessWidget {
  const HeartMaterial({required this.filled, super.key});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = SIconSize.md.pixels;
    if (!filled) {
      return Icon(materialIcon(SIcons.favorites), size: size, color: c.text);
    }
    return CustomPaint(
      size: Size.square(size),
      painter: _HeartPainter(c.favorite),
    );
  }
}

/// The icon set's heart, on its 24-point grid, filled.
class _HeartPainter extends CustomPainter {
  const _HeartPainter(this.color);

  final Color color;

  static const _grid = 24.0;

  /// The outline's width on that grid: as thin as the icons.
  static const _line = 1.5;
  static const _lobe = Radius.circular(5.5);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / _grid);
    final path = Path()
      ..moveTo(19, 14)
      ..cubicTo(20.49, 12.54, 22, 10.79, 22, 8.5)
      ..arcToPoint(const Offset(16.5, 3), radius: _lobe, clockwise: false)
      ..cubicTo(14.74, 3, 13.5, 3.5, 12, 5)
      ..cubicTo(10.5, 3.5, 9.26, 3, 7.5, 3)
      ..arcToPoint(const Offset(2, 8.5), radius: _lobe, clockwise: false)
      ..cubicTo(2, 10.8, 3.5, 12.55, 5, 14)
      ..lineTo(12, 21)
      ..close();
    canvas
      ..drawPath(path, Paint()..color = color)
      ..drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = _line
          ..strokeJoin = StrokeJoin.round,
      );
  }

  @override
  bool shouldRepaint(_HeartPainter old) => old.color != color;
}
