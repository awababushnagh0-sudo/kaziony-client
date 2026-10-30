import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../icon/s_icon.dart';
import 's_list_tile_renderer.dart';

/// One choice of a few, as a card: an icon or a short [mark] in a circle,
/// the [title] and [subtitle], and a check when [selected] or an empty ring
/// when not. [SRadioGroup] lays out a set of them and keeps one chosen.
class SRadioTile extends StatelessWidget {
  const SRadioTile({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.mark,
    super.key,
  }) : assert(icon == null || mark == null, 'An icon or a mark, not both');

  final String title;
  final String? subtitle;
  final SIcons? icon;

  /// A letter or two in the circle instead of an icon ("ع", "En").
  final String? mark;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).listTile.radio(
    context,
    RadioTileSpec(
      title: title,
      subtitle: subtitle,
      icon: icon,
      mark: mark,
      selected: selected,
      onTap: onTap,
    ),
  );
}
