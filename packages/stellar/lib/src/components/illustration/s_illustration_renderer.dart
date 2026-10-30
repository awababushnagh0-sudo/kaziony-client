import 'package:flutter/widgets.dart';

/// The brand's pictures, bundled with stellar (`assets/illustrations`, at
/// 1x, 2x and 3x, on a transparent background). Each knows the widest it's
/// shown; it shrinks to fit narrower places, keeping its shape.
enum SIllustrations {
  /// The logo and the brand's name, with "for stores" on a shop sign
  /// hanging from it: the stores' app. It has words, so it's drawn in each
  /// language (`partner_mark_ar.png`, `partner_mark_en.png`).
  partnerMark('partner_mark', Size(164, 71), arabicSize: Size(126, 75)),

  /// Two speech bubbles, "ع" and "A": choosing the app's language.
  languages('languages', Size(140, 104)),

  /// A shop counter with the day's offers and a phone showing a pickup
  /// code, on the stores' sign-in page. Drawn at 400 by 300; shown a little
  /// smaller, so it leaves room for the form on big phones too.
  signInHero('sign_in_hero', Size(340, 255));

  const SIllustrations(this.file, this.size, {this.arabicSize});

  /// The picture's file name, without `.png`.
  final String file;
  final Size size;

  /// The Arabic picture's size, for pictures with words in them. Null when
  /// one picture serves every language.
  final Size? arabicSize;
}

@immutable
class IllustrationSpec {
  const IllustrationSpec({required this.illustration});

  final SIllustrations illustration;
}

abstract interface class IllustrationRenderer {
  Widget render(BuildContext context, IllustrationSpec spec);
}
