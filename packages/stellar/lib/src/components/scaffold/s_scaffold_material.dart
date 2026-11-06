import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../nav_bar/s_nav_bar_material.dart';
import '../shell/s_shell_material.dart';
import 's_scaffold.dart';

/// [SScaffold], drawn with Material's [Scaffold] and [AppBar].
class SScaffoldMaterial extends StatelessWidget implements SScaffold {
  const SScaffoldMaterial({
    required this.body,
    this.title,
    this.parent,
    this.status,
    this.actions = const [],
    this.padded = true,
    this.scrollable = false,
    this.onRefresh,
    this.bottom,
    this.floating,
    this.showAppBar = true,
    this.maxWidth,
    this.centered = false,
    this.underStatusBar = false,
    super.key,
  });

  final Widget body;
  final String? title;
  final ScaffoldParent? parent;
  final Widget? status;
  final List<Widget> actions;
  final bool padded;
  final bool scrollable;
  final Future<void> Function()? onRefresh;
  final Widget? bottom;
  final Widget? floating;
  final bool showAppBar;
  final double? maxWidth;
  final bool centered;
  final bool underStatusBar;

  @override
  Widget build(BuildContext context) {
    // Phones keep the usual 16 at the sides, as the big apps do.
    final sides = context.style == StellarStyle.app ? Space.lg : Space.xl;
    // What floats over the page's foot (the tabs' banner, the floating
    // button), for lists to end above.
    final banner = NavBarRoom.of(context);
    final room =
        banner +
        (floating == null ? 0 : context.style.controlHeight + Space.lg);
    Widget body = this.body;
    if (padded) {
      body = Padding(
        padding: EdgeInsets.symmetric(horizontal: sides, vertical: Space.lg),
        child: body,
      );
    }
    if (maxWidth != null) {
      body = Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth!),
          child: body,
        ),
      );
    }
    if (centered) {
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
    } else if (scrollable) {
      final onRefresh = this.onRefresh;
      body = SingleChildScrollView(
        padding: EdgeInsets.only(bottom: banner),
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
    final hasParent = parent != null;
    final scaffold = Scaffold(
      appBar: showAppBar
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
              title: _title(context),
              actions: [...actions, const Gap(Space.sm)],
            )
          : null,
      body: SafeArea(
        top: !underStatusBar,
        child: room == 0 ? body : _RoomAtFoot(bottom: room, child: body),
      ),
      floatingActionButton: floating == null
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
              child: floating,
            ),
      bottomNavigationBar: bottom == null
          ? null
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(sides, Space.sm, sides, Space.lg),
                child: bottom,
              ),
            ),
    );
    if (!underStatusBar) return scaffold;
    // Without an app bar to set them, the status bar's clock and icons
    // take the page's colors.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.colors.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      child: scaffold,
    );
  }

  /// "Stores / Sweet Coast [Active]", as in ERPNext: the parent is a quiet
  /// link, the title stays on one line and gives way to the status.
  Widget? _title(BuildContext context) {
    final title = this.title;
    final parent = this.parent;
    if (title == null) return null;
    if (parent == null && status == null) return Text(title);
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
                child: Text(
                  parent.label,
                  style: TextStyle(color: c.textSubtle),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.sm),
            child: Text('/', style: TextStyle(color: c.textSubtle)),
          ),
        ],
        Flexible(child: Text(title, overflow: TextOverflow.ellipsis)),
        if (status case final status?) ...[const Gap(Space.md), status],
      ],
    );
  }
}

/// Asks lists for room at their end, so what floats over the page's foot
/// never hides the last row.
class _RoomAtFoot extends StatelessWidget {
  const _RoomAtFoot({required this.bottom, required this.child});

  final double bottom;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(padding: media.padding.copyWith(bottom: bottom)),
      child: child,
    );
  }
}
