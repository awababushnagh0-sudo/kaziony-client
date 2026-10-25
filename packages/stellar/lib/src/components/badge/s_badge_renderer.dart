import 'package:flutter/widgets.dart';

enum BadgeTone {
  success,
  warning,
  danger,
  neutral,

  /// The brand's orange, solid: discounts.
  accent,
}

abstract interface class BadgeRenderer {
  Widget render(BuildContext context, String label, BadgeTone tone);
}
