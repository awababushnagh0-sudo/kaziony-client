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
}
