import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../icon/s_icon.dart';
import 's_pill_renderer.dart';

/// A small toggle (filters, page size), dark when [selected].
class SPill extends StatelessWidget {
  const SPill({
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final SIcons? icon;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).pill.render(
    context,
    PillSpec(label: label, selected: selected, onTap: onTap, icon: icon),
  );
}
