import 's_radii.dart';
import 's_typography.dart';

/// The two looks stellar draws. The same widgets take either look, so
/// apps only pick one in SApp.
enum StellarStyle {
  /// Phone apps, like the big consumer apps (DoorDash, Too Good To Go):
  /// big bold titles, white fields with a thin border, pill buttons and
  /// big touch targets.
  app(
    controlHeight: 48,
    radius: Radii.lg,
    text: TextSizes(
      code: 52,
      hero: 44,
      display: 28,
      title: 22,
      subtitle: 17,
      body: 16,
      small: 15,
      tiny: 12,
    ),
  ),

  /// The web dashboard, in the style of ERPNext: neutral grays, small
  /// controls for a mouse and more on screen.
  dashboard(
    controlHeight: 36,
    radius: Radii.md,
    text: TextSizes(
      code: 40,
      hero: 36,
      display: 26,
      title: 20,
      subtitle: 15,
      body: 14,
      small: 13,
      tiny: 12,
    ),
  );

  const StellarStyle({
    required this.controlHeight,
    required this.radius,
    required this.text,
  });

  final double controlHeight;

  /// Corners of fields. Buttons are always pills.
  final double radius;

  final TextSizes text;
}
