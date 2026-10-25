import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon_material.dart';
import 's_nav_bar_renderer.dart';

const _barHeight = 64.0;

/// A white bar like the big apps': the open tab's icon and name in the
/// brand color, the others gray.
class MaterialNavBarRenderer implements NavBarRenderer {
  const MaterialNavBarRenderer();

  @override
  Widget render(BuildContext context, NavBarSpec spec) {
    final c = context.colors;
    return Scaffold(
      body: spec.body,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: NavigationBar(
          selectedIndex: spec.selected,
          onDestinationSelected: spec.onSelect,
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
            for (final item in spec.items)
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
