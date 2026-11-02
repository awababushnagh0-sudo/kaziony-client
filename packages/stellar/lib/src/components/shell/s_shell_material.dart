import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon_material.dart';
import '../menu/s_menu_button.dart';
import '../menu/s_menu_material.dart';
import 's_shell.dart';

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

/// [SShell], the ERPNext-style frame: a side menu on the start side (the
/// right, in Arabic) and the page on the other. Below [shellBreakpoint] the
/// menu moves into a drawer.
class SShellMaterial extends StatefulWidget implements SShell {
  const SShellMaterial({
    required this.title,
    required this.items,
    required this.body,
    this.subtitle,
    this.userName,
    this.userDetail,
    this.userActions = const [],
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<NavItemSpec> items;
  final Widget body;
  final String? userName;
  final String? userDetail;
  final List<ShellMenuAction> userActions;

  @override
  State<SShellMaterial> createState() => _SShellMaterialState();
}

class _SShellMaterialState extends State<SShellMaterial> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final wide = MediaQuery.sizeOf(context).width >= shellBreakpoint;
    final menu = _SideMenu(
      shell: widget,
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
            Expanded(key: const ValueKey('shell-body'), child: widget.body),
          ],
        ),
      ),
    );
  }
}

class _SideMenu extends StatelessWidget {
  const _SideMenu({
    required this.shell,
    required this.inDrawer,
    this.beforeNavigate,
  });

  final SShellMaterial shell;
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
                    shell.title,
                    style: TextStyle(
                      fontSize: context.style.text.body,
                      fontWeight: SFontWeight.semibold.value,
                      color: c.text,
                    ),
                  ),
                  if (shell.subtitle != null)
                    Text(
                      shell.subtitle!,
                      style: TextStyle(
                        fontSize: context.style.text.tiny,
                        color: c.textSubtle,
                      ),
                    ),
                ],
              ),
            ),
            const Gap(20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final item in shell.items)
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
            if (shell.userName != null)
              _AccountButton(shell: shell, beforeAction: beforeNavigate),
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
            // Still clickable when selected: on a store's page "Stores" is
            // selected, and it's the way back to the list.
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    materialIcon(item.icon),
                    size: SIconSize.sm.pixels,
                    color: selected ? c.text : c.textMuted,
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: context.style.text.body,
                        color: selected ? c.text : c.textMuted,
                        fontWeight: selected
                            ? SFontWeight.medium.value
                            : SFontWeight.regular.value,
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
/// detail. Opens a menu (above it) with [SShellMaterial.userActions].
class _AccountButton extends StatelessWidget {
  const _AccountButton({required this.shell, this.beforeAction});

  final SShellMaterial shell;
  final VoidCallback? beforeAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final name = shell.userName!;
    return menuAnchor(
      opensUp: true,
      entries: [
        for (final action in shell.userActions)
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
                        fontSize: context.style.text.small,
                        fontWeight: SFontWeight.medium.value,
                        color: c.text,
                      ),
                    ),
                    if (shell.userDetail != null)
                      Text(
                        shell.userDetail!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: context.style.text.tiny,
                          color: c.textSubtle,
                        ),
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
          fontSize: context.style.text.tiny,
          fontWeight: SFontWeight.semibold.value,
          color: c.textMuted,
        ),
      ),
    );
  }
}
