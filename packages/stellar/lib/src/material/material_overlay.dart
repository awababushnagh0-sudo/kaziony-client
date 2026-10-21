import 'package:flutter/material.dart';

import '../components/app_icon.dart';
import '../kit/contracts.dart';
import '../kit/stellar_kit.dart';
import '../tokens/tokens.dart';
import 'icons.dart';

/// Dialogs, confirmations and menus in the style of ERPNext.
class MaterialOverlayRenderer implements OverlayRenderer {
  const MaterialOverlayRenderer();

  @override
  Future<T?> show<T>(
    BuildContext context,
    WidgetBuilder builder, {
    bool dismissible = true,
  }) => showDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    builder: builder,
  );

  @override
  Widget dialog(BuildContext context, DialogSpec spec) => _Dialog(spec: spec);

  @override
  Future<bool> confirm(BuildContext context, ConfirmSpec spec) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final c = context.colors;
        return AlertDialog(
          title: Text(
            spec.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Text(spec.message),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(spec.cancelLabel),
            ),
            FilledButton(
              style: spec.destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: c.danger,
                      foregroundColor: c.onDanger,
                    )
                  : null,
              onPressed: () => Navigator.pop(context, true),
              child: Text(spec.confirmLabel),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget menu(
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
        ? _menuStyle.copyWith(alignment: AlignmentDirectional.bottomEnd)
        : _menuStyle,
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
/// the box itself.
const _menuStyle = MenuStyle(
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
  style: _menuStyle,
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
    final color = entry.destructive ? c.danger : c.text;
    final description = entry.description;
    return MenuItemButton(
      onPressed: entry.onTap,
      style:
          MenuItemButton.styleFrom(
            foregroundColor: color,
            iconColor: color,
            minimumSize: const Size(0, 32),
            fixedSize: description == null ? const Size.fromHeight(32) : null,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: Space.sm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            textStyle: const TextStyle(fontFamily: stellarFont, fontSize: 13),
          ).copyWith(
            // A flat tint on hover, red for the destructive item.
            overlayColor: WidgetStatePropertyAll(
              entry.destructive ? c.dangerSoft : c.primarySoft,
            ),
          ),
      leadingIcon: Icon(materialIcon(entry.icon), size: 16),
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

class _Dialog extends StatelessWidget {
  const _Dialog({required this.spec});

  final DialogSpec spec;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final busy = spec.busy;
    return PopScope(
      canPop: !busy,
      child: Dialog(
        clipBehavior: Clip.antiAlias,
        insetPadding: const EdgeInsets.all(Space.lg),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: spec.width),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 14, 12, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        spec.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: spec.closeLabel,
                      icon: Icon(materialIcon(AppIcon.close), size: 20),
                      onPressed: busy ? null : () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: c.border),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Space.xl),
                  child: spec.body,
                ),
              ),
              if (spec.primaryLabel != null) ...[
                Divider(height: 1, color: c.border),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.xl,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: Space.sm,
                    children: [
                      if (spec.cancelLabel != null)
                        TextButton(
                          onPressed: busy ? null : () => Navigator.pop(context),
                          child: Text(spec.cancelLabel!),
                        ),
                      FilledButton(
                        onPressed: busy ? null : spec.onPrimary,
                        child: busy
                            ? SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: c.textSubtle,
                                ),
                              )
                            : Text(spec.primaryLabel!),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
