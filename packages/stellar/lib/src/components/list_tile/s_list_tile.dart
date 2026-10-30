import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../icon/s_icon.dart';
import 's_list_tile_renderer.dart';

/// A row with an icon, a title and an optional subtitle. Tappable rows get
/// an arrow at the end.
class SListTile extends StatelessWidget {
  const SListTile({
    required this.title,
    this.subtitle,
    this.code,
    this.icon,
    this.leading,
    this.value,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;

  /// A code under [subtitle] (a pickup code), read left to right in
  /// Arabic too.
  final String? code;
  final SIcons? icon;

  /// Takes [icon]'s place, for a picture (`SImage`).
  final Widget? leading;

  /// A short value at the end of the row (the current language).
  final String? value;

  /// Replaces the arrow tappable rows get.
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).listTile.render(
    context,
    ListTileSpec(
      title: title,
      subtitle: subtitle,
      code: code,
      icon: icon,
      leading: leading,
      value: value,
      trailing: trailing,
      onTap: onTap,
    ),
  );
}
