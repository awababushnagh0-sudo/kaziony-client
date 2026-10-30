import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';

/// A page that says something went through: a big tick on the brand's
/// green, what happened, and the one thing to do next.
@immutable
class ConfirmationSpec {
  const ConfirmationSpec({
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.label,
    this.amount,
    this.note,
    this.actionIcon,
  });

  final String title;

  /// Over [amount] ("Collect from the customer").
  final String? label;

  /// Already written for people (`formatPrice`).
  final String? amount;

  /// A quiet line at the end (what and who).
  final String? note;
  final String actionLabel;
  final SIcons? actionIcon;
  final VoidCallback onAction;
}

abstract interface class ConfirmationRenderer {
  Widget page(BuildContext context, ConfirmationSpec spec);
}
