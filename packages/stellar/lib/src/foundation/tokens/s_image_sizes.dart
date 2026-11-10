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

  /// A store's logo over an offer's photo ([SLogo]): round.
  logoOnPhoto(48, Radii.pill),

  /// A store's logo in a row of stores ([SLogoTile]): round.
  logoInRow(64, Radii.pill),

  /// A store's logo heading a card in a list (a past booking): round.
  logoInCard(56, Radii.pill),

  /// An offer's photo beside its words, in a list of tiles.
  tile(88, Radii.lg),

  /// A record's own photo, on its page (a product's).
  large(160, Radii.lg);

  const SImageSize(this.pixels, this.radius);

  final double pixels;
  final double radius;
}

/// A picture's width to its height, for pictures that fill the width given
/// ([SImage.wide]): banners, and photos on cards in a grid.
enum SImageRatio {
  /// A banner on a card (an offer's), in a row that scrolls sideways or a
  /// list.
  banner(2.6),

  /// The photo on a card two of which sit side by side (a product's in a
  /// grid): square, as the card is narrow, with room for a button on its
  /// corner below the words asking for a photo when there's none.
  card(1);

  const SImageRatio(this.value);

  final double value;
}
