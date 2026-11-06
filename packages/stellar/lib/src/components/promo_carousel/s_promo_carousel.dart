import 'package:flutter/widgets.dart';

import '../illustration/s_illustration.dart';
import 's_promo_carousel_material.dart';

/// A banner's background, soft enough for dark text on it.
enum PromoTone {
  /// The brand's cream.
  cream,

  /// A soft green.
  green,

  /// A soft orange.
  orange,
}

/// A few words from us (or, later, an ad): a bold [title] over a short
/// [message], with a picture at the end.
@immutable
class PromoBanner {
  const PromoBanner({
    required this.title,
    required this.message,
    required this.illustration,
    this.tone = PromoTone.cream,
  });

  /// Two lines at most.
  final String title;

  /// Two lines at most.
  final String message;
  final Illustration illustration;
  final PromoTone tone;
}

/// Banners one at a time across the page, swiped sideways, with a dot for
/// each under them. It moves to the next one by itself every few seconds,
/// round and round, unless the phone asks for less motion.
abstract interface class SPromoCarousel implements Widget {
  /// [banners] in order; one alone shows without dots and stays still.
  const factory SPromoCarousel({required List<PromoBanner> banners, Key? key}) =
      SPromoCarouselMaterial;
}
