import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../material/s_color_above.dart';
import 's_band.dart';

/// [SBand], its color drawn behind what's on it, so [foot] can hang off the
/// bottom whatever its height.
class SBandMaterial extends StatelessWidget implements SBand {
  const SBandMaterial({
    required this.child,
    this.foot,
    this.color = SColor.cream,
    this.onTap,
    super.key,
  });

  /// How far [foot] reaches below the band.
  static const _footHang = 44.0;
  static const _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(bottom: Radius.circular(Radii.band)),
  );

  final Widget child;
  final Widget? foot;
  final SColor color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final foot = this.foot;
    final color = context.colors.resolve(this.color);
    // The clock and battery in white on a deep band, dark on a soft one.
    final dark = ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: ColorAbove(
        color: color,
        child: Stack(
          children: [
            Positioned.fill(
              bottom: foot == null ? 0 : _footHang,
              child: DecoratedBox(
                decoration: ShapeDecoration(color: color, shape: _shape),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  type: MaterialType.transparency,
                  shape: _shape,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onTap,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        Space.lg,
                        MediaQuery.paddingOf(context).top + Space.sm,
                        Space.lg,
                        foot == null ? Space.lg : Space.md,
                      ),
                      child: child,
                    ),
                  ),
                ),
                if (foot != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Space.lg),
                    child: foot,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
