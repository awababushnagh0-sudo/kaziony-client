import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../icon/s_icon.dart';
import 's_confirmation_renderer.dart';

/// A whole page on the brand's green that says something went through, as
/// payment apps do: a big tick that pops in, the [title], an [amount] under
/// its [label], and one button at the bottom for what comes next.
class SConfirmationPage extends StatelessWidget {
  const SConfirmationPage({
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.label,
    this.amount,
    this.note,
    this.actionIcon,
    super.key,
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

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).confirmation.page(
        context,
        ConfirmationSpec(
          title: title,
          label: label,
          amount: amount,
          note: note,
          actionLabel: actionLabel,
          actionIcon: actionIcon,
          onAction: onAction,
        ),
      );
}
