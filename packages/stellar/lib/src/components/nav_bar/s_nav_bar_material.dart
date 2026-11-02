import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon_material.dart';
import 's_nav_bar.dart';

const _barHeight = 64.0;

/// [SNavBar], a white bar like the big apps': the open tab's icon and name
/// in the brand color, the others gray.
class SNavBarMaterial extends StatelessWidget implements SNavBar {
  const SNavBarMaterial({
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
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: body,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: NavigationBar(
          selectedIndex: selected,
          onDestinationSelected: onSelect,
          height: _barHeight,
          elevation: 0,
          backgroundColor: c.surface,
          surfaceTintColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: context.style.text.tiny,
              fontWeight: states.contains(WidgetState.selected)
                  ? SFontWeight.bold.value
                  : SFontWeight.medium.value,
              color: states.contains(WidgetState.selected)
                  ? c.primary
                  : c.textSubtle,
            ),
          ),
          destinations: [
            for (final item in items)
              NavigationDestination(
                label: item.label,
                icon: Icon(
                  materialIcon(item.icon),
                  size: SIconSize.lg.pixels,
                  color: c.textSubtle,
                ),
                selectedIcon: Icon(
                  materialIcon(item.icon),
                  size: SIconSize.lg.pixels,
                  color: c.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
