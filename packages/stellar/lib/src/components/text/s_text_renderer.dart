import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';

/// The size (and default weight) of a text, from the theme's type scale.
enum TextVariant { display, title, subtitle, body, caption, label }

@immutable
class TextSpec {
  const TextSpec(
    this.text, {
    this.variant = TextVariant.body,
    this.color = SColor.text,
    this.weight,
    this.align,
    this.maxLines,
  });

  final String text;
  final TextVariant variant;
  final SColor color;

  /// Null keeps the variant's own weight.
  final SFontWeight? weight;
  final TextAlign? align;
  final int? maxLines;
}

/// A sentence ending in a tappable [link].
@immutable
class LinkTextSpec {
  const LinkTextSpec({
    required this.text,
    required this.link,
    required this.onTap,
    this.align,
  });

  final String text;
  final String link;
  final VoidCallback onTap;
  final TextAlign? align;
}

abstract interface class TextRenderer {
  Widget render(BuildContext context, TextSpec spec);
  Widget link(BuildContext context, LinkTextSpec spec);
}
