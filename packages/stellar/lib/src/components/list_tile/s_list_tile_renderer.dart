import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';

@immutable
class ListTileSpec {
  const ListTileSpec({
    required this.title,
    this.subtitle,
    this.icon,
    this.leading,
    this.value,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final SIcons? icon;

  /// Takes [icon]'s place, for a picture (`SImage`).
  final Widget? leading;

  /// A short value at the end of the row (the current language).
  final String? value;

  /// Replaces the arrow tappable rows get.
  final Widget? trailing;
  final VoidCallback? onTap;
}

/// One choice of an [SRadioGroup] or a choice sheet (`SSheet.choose`).
@immutable
class RadioOption<T> {
  const RadioOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    this.mark,
  }) : assert(icon == null || mark == null, 'An icon or a mark, not both');

  final T value;
  final String label;

  /// A quieter line under [label] (a branch's address).
  final String? subtitle;

  /// At the start of the row, in a circle.
  final SIcons? icon;

  /// A letter or two in the circle instead of an icon, where no icon fits
  /// ("ع" and "En" for the languages).
  final String? mark;
}

@immutable
class RadioTileSpec {
  const RadioTileSpec({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.mark,
  });

  final String title;
  final String? subtitle;
  final SIcons? icon;
  final String? mark;

  /// The chosen one of its group: outlined, with a check.
  final bool selected;
  final VoidCallback onTap;
}

@immutable
class ListGroupSpec {
  const ListGroupSpec({required this.children, this.title});

  final String? title;
  final List<Widget> children;
}

abstract interface class ListTileRenderer {
  Widget render(BuildContext context, ListTileSpec spec);

  /// Rows in one rounded box under a small title, as on the settings
  /// pages of the big apps.
  Widget group(BuildContext context, ListGroupSpec spec);

  /// One choice of a few, as a card with a check or an empty ring at the
  /// end ([SRadioTile]).
  Widget radio(BuildContext context, RadioTileSpec spec);
}
