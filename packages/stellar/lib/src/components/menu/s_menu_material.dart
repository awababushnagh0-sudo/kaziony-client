import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon_material.dart';
import 's_menu_renderer.dart';

/// Menus in the style of ERPNext.
class MaterialMenuRenderer implements MenuRenderer {
  const MaterialMenuRenderer();

  @override
  Widget render(
    BuildContext context, {
    required List<MenuEntry?> entries,
    required Widget Function(BuildContext context, VoidCallback toggle) builder,
    bool alignEnd = true,
    double width = 184,
  }) => MenuAnchor(
    // The menu's start corner goes to the button's end corner, then moves
    // back by its own width so the two end edges line up.
    alignmentOffset: Offset(alignEnd ? -width : 0, 4),
    style: alignEnd
        ? menuStyle.copyWith(alignment: AlignmentDirectional.bottomEnd)
        : menuStyle,
    menuChildren: [
      MenuPanel(
        opensUp: false,
        alignEnd: alignEnd,
        width: width,
        children: [
          for (final entry in entries)
            entry == null
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Divider(height: 1),
                  )
                : _MenuItem(entry: entry),
        ],
      ),
    ],
    builder: (context, menu, _) =>
        builder(context, () => menu.isOpen ? menu.close() : menu.open()),
  );
}

/// Hides [MenuAnchor]'s own panel, since [MenuPanel] draws (and animates)
/// the box itself. Also used by the select input.
const menuStyle = MenuStyle(
  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
  surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
  shadowColor: WidgetStatePropertyAll(Colors.transparent),
  elevation: WidgetStatePropertyAll(0),
  padding: WidgetStatePropertyAll(EdgeInsets.zero),
  shape: WidgetStatePropertyAll(RoundedRectangleBorder()),
);

/// A menu anchored above or below a button (also used by the side menu's
/// account button).
MenuAnchor menuAnchor({
  required List<MenuEntry?> entries,
  required Widget Function(BuildContext context, MenuController menu) builder,
  bool opensUp = false,
  Widget? header,
}) => MenuAnchor(
  alignmentOffset: const Offset(0, 4),
  style: menuStyle,
  menuChildren: [
    MenuPanel(
      opensUp: opensUp,
      children: [
        ?header,
        for (final entry in entries)
          entry == null
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Divider(height: 1),
                )
              : _MenuItem(entry: entry),
      ],
    ),
  ],
  builder: (context, menu, _) => builder(context, menu),
);

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.entry});

  final MenuEntry entry;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final description = entry.description;
    return MenuItemButton(
      onPressed: entry.onTap,
      style: menuItemStyle(
        context,
        destructive: entry.destructive,
        // A described entry grows to fit its two lines.
        oneLine: description == null,
      ),
      leadingIcon: Icon(materialIcon(entry.icon), size: SIconSize.xs.pixels),
      child: description == null
          ? Text(entry.label)
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(entry.label),
                  Text(
                    description,
                    style: TextStyle(fontSize: 11.5, color: c.textSubtle),
                  ),
                ],
              ),
            ),
    );
  }
}

/// A menu row: 32px ([oneLine]) or more, a flat tint on hover, red when
/// [destructive]. Also used by the select input's options.
ButtonStyle menuItemStyle(
  BuildContext context, {
  bool destructive = false,
  bool oneLine = true,
}) {
  final c = context.colors;
  final color = destructive ? c.danger : c.text;
  return MenuItemButton.styleFrom(
    foregroundColor: color,
    iconColor: color,
    minimumSize: const Size(0, 32),
    fixedSize: oneLine ? const Size.fromHeight(32) : null,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.compact,
    padding: const EdgeInsets.symmetric(horizontal: Space.sm),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Radii.sm),
    ),
    textStyle: const TextStyle(fontFamily: stellarFont, fontSize: 13),
  ).copyWith(
    overlayColor: WidgetStatePropertyAll(
      destructive ? c.dangerSoft : c.primarySoft,
    ),
  );
}

/// The bordered menu box. Fades in and rises a few pixels when the menu
/// opens; only opacity and a transform change, so it stays cheap to draw.
class MenuPanel extends StatelessWidget {
  const MenuPanel({
    required this.children,
    this.opensUp = true,
    this.alignEnd = false,
    this.width = 184,
    super.key,
  });

  final List<Widget> children;

  /// Whether the menu sits above its button; it then grows from the bottom.
  final bool opensUp;

  /// Whether the menu lines up with its button's end edge.
  final bool alignEnd;
  final double width;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Grows from the corner next to its button.
    final rtl = (Directionality.of(context) == TextDirection.rtl) != alignEnd;
    final origin = switch ((opensUp, rtl)) {
      (true, true) => Alignment.bottomRight,
      (true, false) => Alignment.bottomLeft,
      (false, true) => Alignment.topRight,
      (false, false) => Alignment.topLeft,
    };
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (opensUp ? 6 : -6) * (1 - value)),
          child: Transform.scale(
            scale: 0.96 + 0.04 * value,
            alignment: origin,
            child: child,
          ),
        ),
      ),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(Space.xs),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: c.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
