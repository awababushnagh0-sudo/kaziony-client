import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_list_tile_material.dart';

/// A row with an icon, a title and an optional subtitle. Tappable rows get
/// an arrow at the end.
abstract interface class SListTile implements Widget {
  /// [code] goes under [subtitle] (a pickup code), read left to right in
  /// Arabic too. [leading] takes [icon]'s place, for a picture (`SImage`).
  /// [value] is a short value at the end of the row (the current language),
  /// and [trailing] replaces the arrow tappable rows get.
  const factory SListTile({
    required String title,
    String? subtitle,
    String? code,
    SIcons? icon,
    Widget? leading,
    String? value,
    Widget? trailing,
    VoidCallback? onTap,
    Key? key,
  }) = SListTileMaterial;
}
