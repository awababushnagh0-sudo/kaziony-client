import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_menu_material.dart';

/// One row of a menu.
@immutable
class MenuEntry {
  const MenuEntry({
    required this.label,
    required this.icon,
    required this.onTap,
    this.destructive = false,
    this.description,
  });

  final String label;
  final SIcons icon;
  final VoidCallback onTap;

  /// Red, for removing or disabling.
  final bool destructive;

  /// A smaller line under the label, for actions that need explaining.
  final String? description;
}

/// A button with a menu of [entries]; null entries draw a divider.
/// [builder] draws the button and gets the function that opens the menu.
abstract interface class SMenuButton implements Widget {
  /// [alignEnd] lines the menu up with the button's end edge.
  const factory SMenuButton({
    required List<MenuEntry?> entries,
    required Widget Function(BuildContext context, VoidCallback toggle) builder,
    bool alignEnd,
    double width,
    Key? key,
  }) = SMenuButtonMaterial;
}
