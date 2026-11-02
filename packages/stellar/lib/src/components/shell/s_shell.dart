import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_shell_material.dart';

/// Side menu layout: the dashboard's frame around every page. Wide screens
/// get a fixed side menu; narrow ones get a drawer that pages open from
/// their app bar.
abstract interface class SShell implements Widget {
  /// [title] is the app's name at the top of the side menu, with a quiet
  /// [subtitle] under it. [body] is the current page, usually an SScaffold.
  /// [userName] and [userDetail] show at the bottom of the side menu;
  /// tapping them opens [userActions].
  const factory SShell({
    required String title,
    required List<NavItemSpec> items,
    required Widget body,
    String? subtitle,
    String? userName,
    String? userDetail,
    List<ShellMenuAction> userActions,
    Key? key,
  }) = SShellMaterial;
}

/// One page in the side menu.
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

/// One choice in the signed-in user's menu at the bottom of the side menu.
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
