import 's_radii.dart';

/// Sizes of pictures: product photos, store logos. Bigger pictures get
/// rounder corners, so they look alike side by side.
enum SImageSize {
  /// In list rows.
  thumb(56, Radii.md),

  /// Offers in lists: room for the discount on the photo.
  deal(64, Radii.lg),

  /// A store's logo on its page, over the cover photo: round.
  logo(88, Radii.pill),

  /// A record's own photo, on its page (a product's).
  large(160, Radii.lg);

  const SImageSize(this.pixels, this.radius);

  final double pixels;
  final double radius;
}
