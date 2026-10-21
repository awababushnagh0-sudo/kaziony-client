import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';

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

abstract interface class MenuRenderer {
  /// A button ([builder] draws it and gets the function that opens the
  /// menu) with a menu of [entries]; null entries draw a divider.
  Widget render(
    BuildContext context, {
    required List<MenuEntry?> entries,
    required Widget Function(BuildContext context, VoidCallback toggle) builder,
    bool alignEnd = true,
    double width = 184,
  });
}
