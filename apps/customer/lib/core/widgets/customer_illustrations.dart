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

  /// A hand holding up the brand bag among sparkles: on the account tab
  /// when nobody's signed in.
  guest('guest', Size(240, 180)),

  /// The kinds of store on the home page: every offer (the bag), bakeries,
  /// sweets and cafés.
  categoryAll('category_bag', Size(64, 64)),
  categoryBakery('category_croissant', Size(64, 64)),
  categorySweets('category_cake', Size(64, 64)),
  categoryCafe('category_coffee', Size(64, 64));

  const CustomerIllustrations(this.file, this.size);

  @override
  final String file;
  @override
  final Size size;

  @override
  Size? get arabicSize => null;

  @override
  String? get package => null;
}
