import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_scanner_view.dart';

/// [SScannerView], drawn with Material.
class SScannerViewMaterial extends StatelessWidget implements SScannerView {
  const SScannerViewMaterial({
    required this.camera,
    required this.hint,
    this.starting = false,
    this.torchOn = false,
    this.onTorch,
    this.cover,
    this.actions = const [],
    super.key,
  });

  final Widget camera;
  final String hint;
  final bool starting;
  final bool torchOn;
  final VoidCallback? onTorch;
  final Widget? cover;
  final List<ScannerAction> actions;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final cover = this.cover;
    final onCamera = cover == null;
    final bar = _TopBar(torchOn: torchOn, onTorch: onTorch);
    final actions = _Actions(actions: this.actions, onCamera: onCamera);
    return ColoredBox(
      color: c.cameraBackdrop,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // First, so it stays the same camera when the cover comes and
          // goes.
          ClipRect(child: camera),
          if (cover != null)
            ColoredBox(
              color: c.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  bar,
                  Expanded(child: cover),
                  actions,
                ],
              ),
            )
          else
            // The picture is dark under the status bar in both looks.
            AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ColoredBox(color: c.cameraDim, child: bar),
                  Expanded(
                    child: _Aim(hint: hint, starting: starting),
                  ),
                  ColoredBox(color: c.cameraDim, child: actions),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// The square to aim at, the line sweeping it and the hint under it.
class _Aim extends StatelessWidget {
  const _Aim({required this.hint, required this.starting});

  final String hint;
  final bool starting;

  /// The square's side, as a share of the area's width, and at most of
  /// its height, leaving room for the hint on short phones.
  static const _widthShare = 0.68;
  static const _heightShare = 0.62;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final area = constraints.biggest;
        final side = math.min(
          area.width * _widthShare,
          area.height * _heightShare,
        );
        // A little above the middle, balancing the hint under it.
        final frame = Rect.fromCenter(
          center: area.center(Offset.zero).translate(0, -Space.lg),
          width: side,
          height: side,
        );
        return Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(
              child: CustomPaint(
                painter: _FramePainter(
                  frame: frame,
                  dim: c.cameraDim,
                  corners: c.onCamera,
                ),
              ),
            ),
            Positioned.fromRect(
              rect: frame,
              child: starting
                  ? Center(child: CircularProgressIndicator(color: c.onCamera))
                  : const _ScanLine(),
            ),
            PositionedDirectional(
              top: frame.bottom + Space.xl,
              start: Space.lg,
              end: Space.lg,
              child: Text(
                hint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.onCamera,
                  fontSize: context.style.text.body,
                  fontWeight: SFontWeight.semibold.value,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Sweeps the square up and down while the camera looks for a code.
class _ScanLine extends StatefulWidget {
  const _ScanLine();

  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  static const _sweep = Duration(milliseconds: 1800);
  static const _thickness = 3.0;

  late final _controller = AnimationController(vsync: this, duration: _sweep);
  late final _position = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Still, across the middle, for those who turned motion down.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller
        ..stop()
        ..value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _position.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.xl,
          vertical: Space.lg,
        ),
        child: AnimatedBuilder(
          animation: _position,
          builder: (context, line) => Align(
            alignment: Alignment(0, _position.value * 2 - 1),
            child: line,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: c.scanLine,
              borderRadius: BorderRadius.circular(Radii.pill),
              boxShadow: [BoxShadow(color: c.scanGlow, blurRadius: Space.md)],
            ),
            child: const SizedBox(height: _thickness, width: double.infinity),
          ),
        ),
      ),
    );
  }
}

/// The light at the end, under the status bar.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.torchOn, required this.onTorch});

  final bool torchOn;
  final VoidCallback? onTorch;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final height = context.style.controlHeight;
    final onTorch = this.onTorch;
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: MediaQuery.paddingOf(context).top + Space.sm,
        start: Space.lg,
        end: Space.lg,
        bottom: Space.sm,
      ),
      // Always as tall, so the square doesn't move when the light's
      // button comes.
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            const Spacer(),
            if (onTorch != null)
              IconButton(
                onPressed: onTorch,
                tooltip: torchOn
                    ? StellarLocalizations.of(context).torchOff
                    : StellarLocalizations.of(context).torchOn,
                isSelected: torchOn,
                constraints: BoxConstraints.tight(Size.square(height)),
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: torchOn ? c.onCamera : c.cameraGlass,
                  foregroundColor: torchOn ? c.cameraBackdrop : c.onCamera,
                ),
                icon: Icon(
                  materialIcon(torchOn ? SIcons.torch : SIcons.torchOff),
                  size: SIconSize.md.pixels,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.actions, required this.onCamera});

  final List<ScannerAction> actions;
  final bool onCamera;

  @override
  Widget build(BuildContext context) {
    // Above what floats over the page's foot (the tabs), the dimmed
    // picture going on under it.
    final room = MediaQuery.paddingOf(context).bottom;
    if (actions.isEmpty) return SizedBox(height: Space.lg + room);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Space.lg,
        Space.lg,
        Space.lg,
        Space.lg + room,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, action) in actions.indexed) ...[
            if (i > 0) const SizedBox(height: Space.sm),
            _ActionButton(action: action, main: i == 0, onCamera: onCamera),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.action,
    required this.main,
    required this.onCamera,
  });

  final ScannerAction action;

  /// Solid: white over the camera, the brand's color on the page.
  final bool main;
  final bool onCamera;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (fill, ink) = switch ((main, onCamera)) {
      (true, true) => (c.onCamera, c.cameraBackdrop),
      (true, false) => (c.primary, c.onPrimary),
      (false, true) => (c.cameraGlass, c.onCamera),
      (false, false) => (c.fieldFill, c.text),
    };
    final icon = action.icon;
    final count = action.count ?? 0;
    return _Pill(
      fill: fill,
      frosted: onCamera && !main,
      onTap: action.onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(materialIcon(icon), size: SIconSize.md.pixels, color: ink),
            const SizedBox(width: Space.sm),
          ],
          Flexible(
            child: Text(
              action.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ink,
                fontSize: context.style.text.body,
                fontWeight: SFontWeight.bold.value,
              ),
            ),
          ),
          if (count > 0) ...[const SizedBox(width: Space.sm), _Count(count)],
        ],
      ),
    );
  }
}

/// How many, in the accent color, after a button's label.
class _Count extends StatelessWidget {
  const _Count(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final side = SIconSize.lg.pixels;
    return Container(
      constraints: BoxConstraints(minWidth: side, minHeight: side),
      padding: const EdgeInsets.symmetric(horizontal: Space.sm),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: c.accent,
        shape: const StadiumBorder(),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: c.onAccent,
          fontSize: context.style.text.small,
          fontWeight: SFontWeight.bold.value,
          height: 1,
        ),
      ),
    );
  }
}

/// A control's height, round at the ends. [frosted] blurs the camera's
/// picture behind it.
class _Pill extends StatelessWidget {
  const _Pill({
    required this.fill,
    required this.onTap,
    required this.child,
    this.frosted = false,
  });

  final Color fill;
  final VoidCallback onTap;
  final Widget child;
  final bool frosted;

  static const _blur = 8.0;

  @override
  Widget build(BuildContext context) {
    final pill = Material(
      color: fill,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.style.controlHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: child,
          ),
        ),
      ),
    );
    if (!frosted) return pill;
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.pill),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
        child: pill,
      ),
    );
  }
}

/// Dims everything but [frame], and marks its corners.
class _FramePainter extends CustomPainter {
  const _FramePainter({
    required this.frame,
    required this.dim,
    required this.corners,
  });

  final Rect frame;
  final Color dim;
  final Color corners;

  static const _stroke = 5.0;

  /// Each corner's arms, as a share of the side.
  static const _armShare = 0.18;

  @override
  void paint(Canvas canvas, Size size) {
    const r = Radii.xxl;
    final hole = RRect.fromRectAndRadius(frame, const Radius.circular(r));
    canvas.drawPath(
      Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(Offset.zero & size)
        ..addRRect(hole),
      Paint()..color = dim,
    );

    // Each corner: an arm along both edges, rounded like the hole.
    final arm = frame.width * _armShare;
    final paint = Paint()
      ..color = corners
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round;
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
      old.frame != frame || old.dim != dim || old.corners != corners;
}
