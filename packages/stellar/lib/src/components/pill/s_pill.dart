import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import 's_pill_renderer.dart';

/// A small toggle (filters, page size): outlined, and filled with
/// [activeColor] when [selected].
class SPill extends StatelessWidget {
  const SPill({
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
    this.activeColor = SColor.primary,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final SIcons? icon;

  /// The fill when [selected]; the words on it turn light or dark to read.
  final SColor activeColor;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).pill.render(
    context,
    PillSpec(
      label: label,
      selected: selected,
      onTap: onTap,
      icon: icon,
      activeColor: activeColor,
    ),
  );
}
