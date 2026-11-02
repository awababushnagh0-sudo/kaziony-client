import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import 's_confirmation_material.dart';

/// A whole page on the brand's green that says something went through, as
/// payment apps do: a big tick that pops in, the [title], an [amount] under
/// its [label], and one button at the bottom for what comes next.
abstract interface class SConfirmationPage implements Widget {
  /// [amount] is already written for people (`formatPrice`); [note] is a
  /// quiet line at the end (what and who).
  const factory SConfirmationPage({
    required String title,
    required String actionLabel,
    required VoidCallback onAction,
    String? label,
    String? amount,
    String? note,
    SIcons? actionIcon,
    Key? key,
  }) = SConfirmationPageMaterial;
}
