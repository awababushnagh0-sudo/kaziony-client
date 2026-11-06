import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import 's_rating.dart';
import 's_star_input.dart';

/// [SRating], drawn as a star in the brand's orange before the figures.
class SRatingMaterial extends StatelessWidget implements SRating {
  const SRatingMaterial({
    required this.average,
    this.count,
    required this.label,
    this.small = false,
    super.key,
  });

  final double average;
  final int? count;
  final String label;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = small ? context.style.text.small : context.style.text.body;
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // Beside body text, as far from the star as rows of facts keep
        // from their icons.
        spacing: small ? Space.xs : Space.sm,
        children: [
          _Star(size: small ? SIconSize.xs : SIconSize.sm, filled: true),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: Space.xs,
            children: [
              Text(
                average.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: size,
                  fontWeight: SFontWeight.semibold.value,
                  color: c.text,
                ),
              ),
              if (count != null)
                Text(
                  '($count)',
                  style: TextStyle(fontSize: size, color: c.textMuted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// [SStarInput], drawn as a row of Material [IconButton]s, or of plain
/// stars when read-only.
class SStarInputMaterial extends StatelessWidget implements SStarInput {
  const SStarInputMaterial({
    required this.value,
    required this.starLabel,
    this.onChanged,
    super.key,
  });

  final int value;
  final String Function(int stars) starLabel;
  final ValueChanged<int>? onChanged;

  static const _stars = 5;

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;
    if (onChanged == null) {
      return Semantics(
        label: starLabel(value),
        excludeSemantics: true,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Space.xs,
          children: [
            for (var star = 1; star <= _stars; star++)
              _Star(size: SIconSize.lg, filled: star <= value),
          ],
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var star = 1; star <= _stars; star++)
          IconButton(
            tooltip: starLabel(star),
            isSelected: star <= value,
            onPressed: () => onChanged(star),
            icon: _Star(size: SIconSize.lg, filled: star <= value),
          ),
      ],
    );
  }
}

/// A five-pointed star with soft corners: filled in the brand's orange, or
/// its outline in a quiet gray. Drawn rather than taken from the icon
/// font, whose stars are outlines only.
class _Star extends StatelessWidget {
  const _Star({required this.size, required this.filled});

  final SIconSize size;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return CustomPaint(
      size: Size.square(size.pixels),
      painter: _StarPainter(
        fill: filled ? c.accent : null,
        line: filled ? c.accent : c.textSubtle,
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  const _StarPainter({required this.fill, required this.line});

  final Color? fill;
  final Color line;

  static const _points = 5;

  /// How far the inner corners are from the middle, as a share of how far
  /// the points are.
  static const _inner = 0.45;

  /// The line's width against the star's size: thin, like the icons.
  static const _lineWidth = 1 / 12;

  /// A star's middle sits below its box's: moved down by this much of
  /// the radius, it looks centred.
  static const _drop = 0.1;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * _lineWidth;
    final outer = (size.width - stroke) / 2;
    final middle = size.center(Offset(0, outer * _drop));
    final path = Path();
    for (var corner = 0; corner < _points * 2; corner++) {
      final angle = -math.pi / 2 + corner * math.pi / _points;
      final radius = corner.isEven ? outer : outer * _inner;
      final point =
          middle + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
      corner == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    path.close();
    if (fill case final fill?) {
      canvas.drawPath(path, Paint()..color = fill);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.fill != fill || old.line != line;
}
