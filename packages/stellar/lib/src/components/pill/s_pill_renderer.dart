import 'package:flutter/widgets.dart';

import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';

/// A filter toggle or a small choice, filled with [activeColor] when
/// [selected].
@immutable
class PillSpec {
  const PillSpec({
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
    this.activeColor = SColor.primary,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final SIcons? icon;
  final SColor activeColor;
}

abstract interface class PillRenderer {
  Widget render(BuildContext context, PillSpec spec);
}
