import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_nav_bar_renderer.dart';

/// The phone apps' frame: the open tab's page above a bottom navigation
/// bar. The dashboard's frame is SShell.
class SNavBar extends StatelessWidget {
  const SNavBar({
    required this.items,
    required this.selected,
    required this.onSelect,
    required this.body,
    super.key,
  });

  final List<NavBarItem> items;
  final int selected;
  final ValueChanged<int> onSelect;
  final Widget body;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).navBar.render(
    context,
    NavBarSpec(
      items: items,
      selected: selected,
      onSelect: onSelect,
      body: body,
    ),
  );
}
