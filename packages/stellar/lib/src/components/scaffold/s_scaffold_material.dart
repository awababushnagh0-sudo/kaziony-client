import 'package:flutter/material.dart';

import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../shell/s_shell_material.dart';
import 's_scaffold_renderer.dart';

class MaterialScaffoldRenderer implements ScaffoldRenderer {
  const MaterialScaffoldRenderer();

  @override
  Widget render(BuildContext context, ScaffoldSpec spec) {
    Widget body = spec.body;
    if (spec.padded) {
      body = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Space.xl,
          vertical: Space.lg,
        ),
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
    final openMenu = ShellScope.maybeOf(context)?.openMenu;
    final canPop = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
    return Scaffold(
      appBar: spec.showAppBar
          ? AppBar(
              leading: openMenu != null && !canPop
                  ? IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                      icon: Icon(materialIcon(SIcons.menu)),
                      onPressed: openMenu,
                    )
                  : null,
              title: spec.title == null ? null : Text(spec.title!),
              actions: [...spec.actions, const Gap(Space.sm)],
            )
          : null,
      body: SafeArea(child: body),
      bottomNavigationBar: spec.bottom == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Space.xl,
                  Space.sm,
                  Space.xl,
                  Space.lg,
                ),
                child: spec.bottom,
              ),
            ),
    );
  }
}
