import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_nav_bar_material.dart';

/// The phone apps' frame: the open tab's page above a bottom navigation
/// bar. The dashboard's frame is SShell.
abstract interface class SNavBar implements Widget {
  /// [selected] is the index of the open tab in [items]; [body] is its
  /// page, usually an SScaffold.
  const factory SNavBar({
    required List<NavBarItem> items,
    required int selected,
    required ValueChanged<int> onSelect,
    required Widget body,
    Key? key,
  }) = SNavBarMaterial;
}

/// One tab of the bottom navigation bar.
@immutable
class NavBarItem {
  const NavBarItem({required this.label, required this.icon});

  final String label;
  final SIcons icon;
}
