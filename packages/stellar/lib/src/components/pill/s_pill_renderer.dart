import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';

/// A filter toggle or a small choice, dark when [selected].
@immutable
class PillSpec {
  const PillSpec({
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final SIcons? icon;
}

abstract interface class PillRenderer {
  Widget render(BuildContext context, PillSpec spec);
}
