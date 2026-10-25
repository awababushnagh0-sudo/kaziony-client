import 'package:flutter/material.dart';

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
      body = SingleChildScrollView(child: body);
    }

    // Inside a narrow dashboard shell, top-level pages open the side menu.
    // A breadcrumb is the way back, so pages with one get no back arrow.
    final openMenu = ShellScope.maybeOf(context)?.openMenu;
    final canPop = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
    final hasParent = spec.parent != null;
    return Scaffold(
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
      body: SafeArea(child: body),
      bottomNavigationBar: spec.bottom == null
          ? null
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(sides, Space.sm, sides, Space.lg),
                child: spec.bottom,
              ),
            ),
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
