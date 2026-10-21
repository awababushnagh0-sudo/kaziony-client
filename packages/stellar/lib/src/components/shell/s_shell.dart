import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_shell_renderer.dart';

/// Side menu layout: the dashboard's frame around every page.
class SShell extends StatelessWidget {
  const SShell({
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
  Widget build(BuildContext context) => StellarKit.of(context).shell.render(
    context,
    ShellSpec(
      title: title,
      items: items,
      body: body,
      subtitle: subtitle,
      userName: userName,
      userDetail: userDetail,
      userActions: userActions,
    ),
  );
}
