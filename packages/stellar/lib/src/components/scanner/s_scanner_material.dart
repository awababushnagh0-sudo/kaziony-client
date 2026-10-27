import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_scanner_renderer.dart';

class MaterialScannerRenderer implements ScannerRenderer {
  const MaterialScannerRenderer();

  /// The square's side, as a share of the narrower side of the area.
  static const _frameShare = 0.68;

  @override
  Widget view(BuildContext context, ScannerViewSpec spec) {
    final c = context.colors;
    final s = StellarLocalizations.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final area = constraints.biggest;
        final side = math.min(area.width, area.height) * _frameShare;
        // A little above the middle, leaving room for the hint and the
        // light's button under it.
        final frame = Rect.fromCenter(
          center: area.center(Offset.zero).translate(0, -Space.xxl),
          width: side,
          height: side,
        );
        return ColoredBox(
          color: c.cameraBackdrop,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // First, so it stays the same camera when the cover comes
              // and goes.
              ClipRect(child: spec.camera),
              if (spec.cover case final cover?)
                ColoredBox(color: c.background, child: cover)
              else ...[
                IgnorePointer(
                  child: CustomPaint(
                    painter: _FramePainter(
                      frame: frame,
                      scrim: c.cameraBackdrop.withValues(alpha: 0.55),
                      corners: c.onCamera,
                    ),
                  ),
                ),
                if (spec.starting)
                  Positioned.fromRect(
                    rect: frame,
                    child: Center(
                      child: CircularProgressIndicator(color: c.onCamera),
                    ),
                  ),
                PositionedDirectional(
                  top: frame.bottom + Space.xl,
                  start: Space.lg,
                  end: Space.lg,
                  child: Text(
                    spec.hint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: c.onCamera,
                      fontSize: context.style.text.body,
                      fontWeight: SFontWeight.medium.value,
                    ),
                  ),
                ),
                if (spec.onTorch case final onTorch?)
                  PositionedDirectional(
                    start: 0,
                    end: 0,
                    bottom: Space.xl,
                    child: Center(
                      child: IconButton(
                        onPressed: onTorch,
                        tooltip: spec.torchOn ? s.torchOff : s.torchOn,
                        isSelected: spec.torchOn,
                        padding: const EdgeInsets.all(Space.lg),
                        style: IconButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: spec.torchOn
                              ? c.onCamera
                              : c.onCamera.withValues(alpha: 0.2),
                          foregroundColor: spec.torchOn
                              ? c.cameraBackdrop
                              : c.onCamera,
                        ),
                        icon: Icon(
                          materialIcon(
                            spec.torchOn ? SIcons.torch : SIcons.torchOff,
                          ),
                          size: SIconSize.lg.pixels,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Dims everything but [frame], and marks its corners.
class _FramePainter extends CustomPainter {
  const _FramePainter({
    required this.frame,
    required this.scrim,
    required this.corners,
  });

  final Rect frame;
  final Color scrim;
  final Color corners;

  static const _stroke = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final hole = RRect.fromRectAndRadius(
      frame,
      const Radius.circular(Radii.lg),
    );
    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(Offset.zero & size)
        ..addRRect(hole),
      Paint()..color = scrim,
    );

    // Each corner: a quarter of the side along both edges, rounded like
    // the hole.
    final arm = frame.width / 4;
    final paint = Paint()
      ..color = corners
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round;
    const r = Radii.lg;
    final corner = Path()
      ..moveTo(0, arm)
      ..lineTo(0, r)
      ..arcToPoint(const Offset(r, 0), radius: const Radius.circular(r))
      ..lineTo(arm, 0);
    for (final (origin, turns) in [
      (frame.topLeft, 0),
      (frame.topRight, 1),
      (frame.bottomRight, 2),
      (frame.bottomLeft, 3),
    ]) {
      canvas
        ..save()
        ..translate(origin.dx, origin.dy)
        ..rotate(turns * math.pi / 2)
        ..drawPath(corner, paint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_FramePainter old) =>
      old.frame != frame || old.scrim != scrim || old.corners != corners;
}
