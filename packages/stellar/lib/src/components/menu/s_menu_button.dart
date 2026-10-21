import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import 's_menu_renderer.dart';

/// A button with a menu of [entries]; null entries draw a divider.
/// [builder] draws the button and gets the function that opens the menu.
class SMenuButton extends StatelessWidget {
  const SMenuButton({
    required this.entries,
    required this.builder,
    this.alignEnd = true,
    this.width = 184,
    super.key,
  });

  final List<MenuEntry?> entries;
  final Widget Function(BuildContext context, VoidCallback toggle) builder;
  final bool alignEnd;
  final double width;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).menu.render(
    context,
    entries: entries,
    builder: builder,
    alignEnd: alignEnd,
    width: width,
  );
}
