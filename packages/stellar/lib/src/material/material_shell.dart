import 'package:flutter/material.dart';

import '../kit/contracts.dart';
import '../kit/stellar_kit.dart';
import '../tokens/tokens.dart';
import 'icons.dart';
import 'material_overlay.dart';

/// Wider than this, the side menu stays open next to the page.
const shellBreakpoint = 900.0;
const _menuWidth = 232.0;

/// Lets pages inside a narrow shell show a button that opens the menu.
class ShellScope extends InheritedWidget {
  const ShellScope({required this.openMenu, required super.child, super.key});

  /// Null when the menu is always visible (wide screens).
  final VoidCallback? openMenu;

  static ShellScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShellScope>();

  @override
  bool updateShouldNotify(ShellScope oldWidget) =>
      (openMenu == null) != (oldWidget.openMenu == null);
}

/// The ERPNext-style frame: a side menu on the start side (the right, in
/// Arabic) and the page on the other. Below [shellBreakpoint] the menu
/// moves into a drawer.
class MaterialShellRenderer implements ShellRenderer {
  const MaterialShellRenderer();

  @override
  Widget render(BuildContext context, ShellSpec spec) =>
      _MaterialShell(spec: spec);
}

class _MaterialShell extends StatefulWidget {
  const _MaterialShell({required this.spec});

  final ShellSpec spec;

  @override
  State<_MaterialShell> createState() => _MaterialShellState();
}

class _MaterialShellState extends State<_MaterialShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final wide = MediaQuery.sizeOf(context).width >= shellBreakpoint;
    final menu = _SideMenu(
      spec: widget.spec,
      inDrawer: !wide,
      // In the drawer, picking a page also closes the menu.
      beforeNavigate: wide
          ? null
          : () => _scaffoldKey.currentState?.closeDrawer(),
    );

    return ShellScope(
      openMenu: wide ? null : () => _scaffoldKey.currentState?.openDrawer(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: wide ? null : Drawer(width: 260, child: menu),
        body: Row(
          children: [
            if (wide) ...[
              menu,
              VerticalDivider(width: 1, color: colors.border),
            ],
            // Keyed so the page keeps its state when the window is resized
            // across the breakpoint.
            Expanded(
              key: const ValueKey('shell-body'),
              child: widget.spec.body,
            ),
          ],
        ),
      ),
    );
  }
}

class _SideMenu extends StatelessWidget {
  const _SideMenu({
    required this.spec,
    required this.inDrawer,
    this.beforeNavigate,
  });

  final ShellSpec spec;
  final bool inDrawer;
  final VoidCallback? beforeNavigate;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: inDrawer ? null : _menuWidth,
      color: c.surfaceMuted,
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 12),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spec.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: c.text,
                    ),
                  ),
                  if (spec.subtitle != null)
                    Text(
                      spec.subtitle!,
                      style: TextStyle(fontSize: 12, color: c.textSubtle),
                    ),
                ],
              ),
            ),
            const Gap(20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final item in spec.items)
                    _NavItem(
                      item: item,
                      onTap: () {
                        beforeNavigate?.call();
                        item.onTap();
                      },
                    ),
                ],
              ),
            ),
            if (spec.userName != null)
              _AccountButton(spec: spec, beforeAction: beforeNavigate),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.item, required this.onTap});

  final NavItemSpec item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(Radii.md);
    final selected = item.selected;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? c.surface : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: selected ? BorderSide(color: c.border) : BorderSide.none,
          ),
          child: InkWell(
            borderRadius: radius,
            hoverColor: c.primarySoft,
            // No ripple or dark press highlight, as in ERPNext.
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            onTap: selected ? null : onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    materialIcon(item.icon),
                    size: 18,
                    color: selected ? c.text : c.textMuted,
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: selected ? c.text : c.textMuted,
                        fontWeight: selected
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The signed-in user at the bottom of the side menu: initials, name and
/// detail. Opens a menu (above it) with [ShellSpec.userActions].
class _AccountButton extends StatelessWidget {
  const _AccountButton({required this.spec, this.beforeAction});

  final ShellSpec spec;
  final VoidCallback? beforeAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final name = spec.userName!;
    return menuAnchor(
      opensUp: true,
      entries: [
        for (final action in spec.userActions)
          MenuEntry(
            label: action.label,
            icon: action.icon,
            destructive: action.destructive,
            onTap: () {
              beforeAction?.call();
              action.onTap();
            },
          ),
      ],
      builder: (context, menu) => InkWell(
        borderRadius: BorderRadius.circular(Radii.md),
        hoverColor: c.primarySoft,
        onTap: () => menu.isOpen ? menu.close() : menu.open(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            spacing: 10,
            children: [
              _Initials(name: name),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: c.text,
                      ),
                    ),
                    if (spec.userDetail != null)
                      Text(
                        spec.userDetail!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: c.textSubtle),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Up to two initials in a soft circle.
class _Initials extends StatelessWidget {
  const _Initials({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word.characters.first.toUpperCase())
        .join();
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: c.border, shape: BoxShape.circle),
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: c.textMuted,
        ),
      ),
    );
  }
}
