import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_divider.dart';

/// [SDivider], drawn as a Material [Divider]: a line in the border color,
/// or a band in the fields' gray.
class SDividerMaterial extends StatelessWidget implements SDivider {
  const SDividerMaterial({this.inset = false, super.key}) : _band = false;

  const SDividerMaterial.band({super.key}) : inset = false, _band = true;

  final bool inset;
  final bool _band;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _band
        ? Divider(height: Space.sm, thickness: Space.sm, color: c.fieldFill)
        : Divider(
            height: 1,
            thickness: 1,
            color: c.border,
            indent: inset ? Space.lg : 0,
            endIndent: inset ? Space.lg : 0,
          );
  }
}

/// [SDivider.dashed], painted.
class SDashedDividerMaterial extends StatelessWidget implements SDivider {
  const SDashedDividerMaterial({super.key});

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size.fromHeight(1),
    painter: _DashesPainter(context.colors.border),
  );
}

class _DashesPainter extends CustomPainter {
  const _DashesPainter(this.color);

  final Color color;

  static const _dash = 5.0;
  static const _gap = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height;
    final y = size.height / 2;
    for (var x = 0.0; x < size.width; x += _dash + _gap) {
      canvas.drawLine(
        Offset(x, y),
        Offset((x + _dash).clamp(0, size.width), y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashesPainter old) => old.color != color;
}
