import 'package:flutter/widgets.dart';

import 's_style.dart';

/// The font of every app: IBM Plex Sans Arabic, bundled in stellar.
const stellarFont = 'packages/stellar/IBMPlexSansArabic';

/// The weights of [stellarFont] (the font is bundled in these four).
enum SFontWeight {
  regular(FontWeight.w400),
  medium(FontWeight.w500),
  semibold(FontWeight.w600),
  bold(FontWeight.w700);

  const SFontWeight(this.value);

  final FontWeight value;
}

/// The text sizes of one look ([StellarStyle.text]). Components pick a
/// size by its role, so the phone apps' text grows with the look.
@immutable
class TextSizes {
  const TextSizes({
    required this.code,
    required this.hero,
    required this.display,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.small,
    required this.tiny,
  });

  /// A code held up across the counter to compare (a pickup code).
  final double code;

  /// Figures read from across a counter: the amount to collect.
  final double hero;

  /// The big centered titles of the sign-in pages.
  final double display;

  /// Page titles and the app bar.
  final double title;

  /// Section and group titles.
  final double subtitle;

  /// Body text, buttons and what's typed into fields.
  final double body;

  /// Secondary text: captions, hints, table cells, menus.
  final double small;

  /// The smallest: badges, column titles, tab labels, help under fields.
  final double tiny;
}
