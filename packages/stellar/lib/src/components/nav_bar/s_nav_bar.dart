import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_nav_bar_material.dart';

/// The phone apps' frame: the open tab's page, going on under a bar of
/// tabs that floats over its foot. The dashboard's frame is SShell.
abstract interface class SNavBar implements Widget {
  /// [selected] is the index of the open tab in [items]; [body] is its
  /// page, usually an SScaffold, whose lists keep room to end above the
  /// tabs. [banner] floats above the tabs too (an `SOngoingBar`), the page
  /// scrolling under it; it slides in and out.
  const factory SNavBar({
    required List<NavBarItem> items,
    required int selected,
    required ValueChanged<int> onSelect,
    required Widget body,
    Widget? banner,
    Key? key,
  }) = SNavBarMaterial;
}

/// One tab of the bottom navigation bar.
@immutable
class NavBarItem {
  const NavBarItem({required this.label, required this.icon, this.count = 0});

  final String label;
  final SIcons icon;

  /// How many there are to see there (bookings to pick up), on an orange
  /// dot over the icon; none at 0.
  final int count;
}
