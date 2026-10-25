/// Sizes of pictures: product photos, store logos.
enum SImageSize {
  /// In list rows.
  thumb(56),

  /// A record's own photo, on its page (a product's).
  large(160);

  const SImageSize(this.pixels);

  final double pixels;
}
