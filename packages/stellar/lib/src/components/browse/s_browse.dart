import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_browse_renderer.dart';

/// Where offers are shown from, at the top of a home page: a quiet
/// [caption] over the [place] in bold, with an arrow that says it changes
/// ([onTap]), and [trailing] at the other end.
class SPlaceHeader extends StatelessWidget {
  const SPlaceHeader({
    required this.caption,
    required this.place,
    required this.onTap,
    this.trailing,
    super.key,
  });

  final String caption;
  final String place;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).browse.place(
    context,
    PlaceHeaderSpec(
      caption: caption,
      place: place,
      onTap: onTap,
      trailing: trailing,
    ),
  );
}

/// The kinds of store, each a picture over its name, in a row that
/// scrolls sideways; the [selected] one's name in the brand's green and
/// underlined.
class SCategoryStrip extends StatelessWidget {
  const SCategoryStrip({
    required this.choices,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<CategoryChoice> choices;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).browse.categories(
        context,
        CategoryStripSpec(
          choices: choices,
          selected: selected,
          onSelected: onSelected,
        ),
      );
}

/// A few words from us between a page's offers, on the brand's green:
/// the [title] big, a [message] and a [tag] on an orange pill.
class SPromoBanner extends StatelessWidget {
  const SPromoBanner({
    required this.title,
    required this.message,
    this.tag,
    super.key,
  });

  final String title;
  final String message;
  final String? tag;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).browse.banner(
    context,
    PromoBannerSpec(title: title, message: message, tag: tag),
  );
}
