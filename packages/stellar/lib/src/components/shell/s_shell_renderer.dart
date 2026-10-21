import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';

@immutable
class NavItemSpec {
  const NavItemSpec({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final SIcons icon;
  final bool selected;
  final VoidCallback onTap;
}

@immutable
class ShellMenuAction {
  const ShellMenuAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.destructive = false,
  });

  final String label;
  final SIcons icon;
  final VoidCallback onTap;

  /// Red, like logging out.
  final bool destructive;
}

@immutable
class ShellSpec {
  const ShellSpec({
    required this.title,
    required this.items,
    required this.body,
    this.subtitle,
    this.userName,
    this.userDetail,
    this.userActions = const [],
  });

  /// App name at the top of the side menu.
  final String title;

  /// A quiet line under [title].
  final String? subtitle;
  final List<NavItemSpec> items;

  /// The current page, usually an SScaffold.
  final Widget body;

  /// Shown at the bottom of the side menu; tapping opens [userActions].
  final String? userName;
  final String? userDetail;
  final List<ShellMenuAction> userActions;
}

/// Wide screens get a fixed side menu; narrow ones get a drawer that pages
/// open from their app bar.
abstract interface class ShellRenderer {
  Widget render(BuildContext context, ShellSpec spec);
}
