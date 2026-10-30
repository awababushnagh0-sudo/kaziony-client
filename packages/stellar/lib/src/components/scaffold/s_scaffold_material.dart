import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../shell/s_shell_material.dart';
import 's_scaffold_renderer.dart';

class MaterialScaffoldRenderer implements ScaffoldRenderer {
  const MaterialScaffoldRenderer();

  @override
  Widget render(BuildContext context, ScaffoldSpec spec) {
    // Phones keep the usual 16 at the sides, as the big apps do.
    final sides = context.style == StellarStyle.app ? Space.lg : Space.xl;
    Widget body = spec.body;
    if (spec.padded) {
      body = Padding(
        padding: EdgeInsets.symmetric(horizontal: sides, vertical: Space.lg),
        child: body,
      );
    }
    if (spec.maxWidth != null) {
      body = Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: spec.maxWidth!),
          child: body,
        ),
      );
    }
    if (spec.centered) {
      // Centered when it fits, scrollable when it doesn't (small windows,
      // open keyboard).
      final content = body;
      body = LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: content),
          ),
        ),
      );
    } else if (spec.scrollable) {
      final onRefresh = spec.onRefresh;
      body = SingleChildScrollView(
        // Short pages can still be pulled down to reload.
        physics: onRefresh == null
            ? null
            : const AlwaysScrollableScrollPhysics(),
        child: body,
      );
      if (onRefresh != null) {
        body = RefreshIndicator(
          onRefresh: onRefresh,
          color: context.colors.primary,
          backgroundColor: context.colors.surface,
          child: body,
        );
      }
    }

    // Inside a narrow dashboard shell, top-level pages open the side menu.
    // A breadcrumb is the way back, so pages with one get no back arrow.
    final openMenu = ShellScope.maybeOf(context)?.openMenu;
    final canPop = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
    final hasParent = spec.parent != null;
    final scaffold = Scaffold(
      appBar: spec.showAppBar
          ? AppBar(
              automaticallyImplyLeading: !hasParent,
              leading: openMenu != null && (hasParent || !canPop)
                  ? IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                      icon: Icon(materialIcon(SIcons.menu)),
                      onPressed: openMenu,
                    )
                  // Stellar's own arrow, not Material's, so it matches
                  // the other icons. It points the other way in Arabic.
                  : canPop && !hasParent
                  ? IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .backButtonTooltip,
                      icon: Icon(materialIcon(SIcons.chevronBack)),
                      onPressed: () => Navigator.maybePop(context),
                    )
                  : null,
              title: _title(context, spec),
              actions: [...spec.actions, const Gap(Space.sm)],
            )
          : null,
      body: SafeArea(
        top: !spec.underStatusBar,
        child: spec.floating == null ? body : _RoomForFloating(child: body),
      ),
      floatingActionButton: spec.floating == null
          ? null
          : DecoratedBox(
              // Lifted off the list it floats over.
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Radii.pill),
                boxShadow: [
                  BoxShadow(
                    color: context.colors.shadow,
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: spec.floating,
            ),
      bottomNavigationBar: spec.bottom == null
          ? null
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(sides, Space.sm, sides, Space.lg),
                child: spec.bottom,
              ),
            ),
    );
    if (!spec.underStatusBar) return scaffold;
    // Without an app bar to set them, the status bar's clock and icons
    // take the page's colors.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.colors.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: scaffold,
    );
  }
}

/// Asks lists for room at their end, so the floating button never hides
/// the last row.
class _RoomForFloating extends StatelessWidget {
  const _RoomForFloating({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        padding: media.padding.copyWith(
          bottom: context.style.controlHeight + Space.lg,
        ),
      ),
      child: child,
    );
  }
}

/// "Stores / Sweet Coast [Active]", as in ERPNext: the parent is a quiet
/// link, the title stays on one line and gives way to the status.
Widget? _title(BuildContext context, ScaffoldSpec spec) {
  final title = spec.title;
  final parent = spec.parent;
  if (title == null) return null;
  if (parent == null && spec.status == null) return Text(title);
  final c = context.colors;
  return Row(
    children: [
      if (parent != null) ...[
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: parent.onTap,
            child: Semantics(
              link: true,
              child: Text(parent.label, style: TextStyle(color: c.textSubtle)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.sm),
          child: Text('/', style: TextStyle(color: c.textSubtle)),
        ),
      ],
      Flexible(child: Text(title, overflow: TextOverflow.ellipsis)),
      if (spec.status case final status?) ...[const Gap(Space.md), status],
    ],
  );
}
