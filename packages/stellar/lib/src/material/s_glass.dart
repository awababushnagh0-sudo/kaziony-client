import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../foundation/s_scope.dart';

/// The outline of a piece of [SGlass].
enum SGlassShape {
  /// Round ends: a bar.
  pill,

  /// A button's circle.
  circle,
}

/// Liquid glass behind [child], for what floats over the page (the tabs,
/// the buttons on a photo): what's under it blurred and tinted with the
/// look's glass color, a lit rim and a soft shadow.
///
/// Only the standard pass of `liquid_glass_widgets`: one blur of what's
/// behind and a small shader over the glass's own area. Its premium pass
/// copies the page into a texture to bend it, which costs too much on a
/// screen that scrolls under it on every frame. With the device's Increase
/// Contrast on, the package draws plain frosted glass instead.
class SGlass extends StatefulWidget {
  const SGlass({
    required this.shape,
    required this.child,
    this.lift = 1,
    super.key,
  });

  final SGlassShape shape;
  final Widget child;

  /// How much of its shadow shows, 0 to 1: none once it sits on a plain
  /// bar.
  final double lift;

  /// Loads the glass's shader, so the first glass on screen draws with it
  /// instead of a frame or two of a plain tint. [SApp] starts it as the app
  /// opens.
  static Future<void> preload() => _loaded ??= LightweightLiquidGlass.preWarm();

  static Future<void>? _loaded;

  /// Blur of what's behind, and how much its colors are lifted, so the
  /// page shows through as color rather than as shapes.
  static const _blur = 12.0;
  static const _saturation = 1.6;

  /// How deep the rim's light reaches into the glass.
  static const _thickness = 20.0;

  /// The shadow under the glass, in the light look only (the package draws
  /// none on dark).
  static const _shadowBlur = 18.0;
  static const _shadowDrop = 6.0;

  @override
  State<SGlass> createState() => _SGlassState();
}

class _SGlassState extends State<SGlass> {
  @override
  void initState() {
    super.initState();
    // The package paints a plain tint until its shader has loaded, and
    // takes the shader up only when it is built again.
    SGlass.preload().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GlassTheme(
      // The app's own light or dark, not the device's.
      data: GlassThemeData(brightness: c.brightness),
      child: AdaptiveGlass(
        shape: switch (widget.shape) {
          SGlassShape.pill => const LiquidRoundedSuperellipse(
            borderRadius: GlassDefaults.capsuleRadius,
          ),
          SGlassShape.circle => const LiquidOval(),
        },
        settings: LiquidGlassSettings(
          glassColor: c.glass,
          blur: SGlass._blur,
          saturation: SGlass._saturation,
          thickness: SGlass._thickness,
          shadow: [
            if (widget.lift > 0)
              BoxShadow(
                color: c.shadow.withValues(alpha: c.shadow.a * widget.lift),
                blurRadius: SGlass._shadowBlur,
                offset: const Offset(0, SGlass._shadowDrop),
              ),
          ],
        ),
        // Taps ripple over the glass, not on the page under it.
        child: Material(type: MaterialType.transparency, child: widget.child),
      ),
    );
  }
}
