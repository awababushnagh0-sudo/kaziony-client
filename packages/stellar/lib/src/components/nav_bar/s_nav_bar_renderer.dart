import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';

/// One tab of the bottom navigation bar.
@immutable
class NavBarItem {
  const NavBarItem({required this.label, required this.icon});

  final String label;
  final SIcons icon;
}

@immutable
class NavBarSpec {
  const NavBarSpec({
    required this.items,
    required this.selected,
    required this.onSelect,
    required this.body,
  });

  final List<NavBarItem> items;

  /// The index of the open tab in [items].
  final int selected;
  final ValueChanged<int> onSelect;

  /// The open tab's page, usually an SScaffold.
  final Widget body;
}

abstract interface class NavBarRenderer {
  Widget render(BuildContext context, NavBarSpec spec);
}
