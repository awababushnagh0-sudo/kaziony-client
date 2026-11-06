import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import '../illustration/s_illustration.dart';
import 's_status_material.dart';

/// Nothing to show: a picture ([illustration]) or an icon, a title, a line
/// on what to do, and the button that does it. Centered where it's shown,
/// a whole page or a section of one.
abstract interface class SEmptyView implements Widget {
  /// [illustration] is shown instead of [icon], where the state deserves a
  /// picture (a list that's empty because nothing was added yet). The
  /// button shows when there's both an [actionLabel] and an [onAction];
  /// its [actionIcon] is refresh by default, as most actions here are
  /// "Try again", and left out under an [illustration].
  const factory SEmptyView({
    required String title,
    String? message,
    SIcons icon,
    Illustration? illustration,
    String? actionLabel,
    SIcons actionIcon,
    VoidCallback? onAction,
    Key? key,
  }) = SEmptyViewMaterial;
}
