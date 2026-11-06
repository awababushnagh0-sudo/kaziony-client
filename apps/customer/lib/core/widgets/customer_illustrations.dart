import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// The pictures only this app shows, in its own `assets/illustrations`.
/// Shown with `SIllustration`, like stellar's own.
enum CustomerIllustrations implements Illustration {
  /// The brand bag smiling, with orange rays: on the welcome and sign-in
  /// pages.
  logo('logo', Size(192, 130)),

  /// A green pin with the bag in it, on a folded map: on the location page.
  location('location', Size(160, 130)),

  /// A little street map with a red pin, in a map app's own colors: a
  /// store's branches and the way to them.
  map('map', Size(56, 56)),

  /// A hand holding up the brand bag among sparkles: on the account tab
  /// when nobody's signed in.
  guest('guest', Size(240, 180)),

  /// The brand bag with a pink heart on its corner, among little hearts:
  /// the Favorites tab before any store is saved. Pink, not the brand's
  /// green, as people know a favorite by.
  favorites('favorites', Size(240, 180)),

  /// The bag asleep under the moon: food saved as stores close, on a home
  /// banner.
  bagSleep('bag_sleep', Size(140, 120)),

  /// A paper bag full of bread, with the brand's bag on it: every offer
  /// around, on the home page.
  kraftBag('kraft_bag', Size(96, 96)),

  /// The kinds of store on the home page: every offer (the bag), bakeries,
  /// sweets and cafés.
  categoryAll('category_bag', Size(64, 64)),
  categoryBakery('category_croissant', Size(64, 64)),
  categorySweets('category_cupcake', Size(64, 64)),
  categoryCafe('category_coffee', Size(64, 64));

  const CustomerIllustrations(this.file, this.size);

  /// The picture for a kind of store, by its slug; null for kinds the app
  /// has none for (they show the admins' icon).
  static CustomerIllustrations? forCategory(String slug) => switch (slug) {
    'bakery' => categoryBakery,
    'sweet' => categorySweets,
    'cafe' => categoryCafe,
    _ => null,
  };

  @override
  final String file;
  @override
  final Size size;

  @override
  Size? get arabicSize => null;

  @override
  String? get package => null;
}
