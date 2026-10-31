import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';
import '../illustration/s_illustration_renderer.dart';

@immutable
class StatusSpec {
  const StatusSpec({
    required this.title,
    this.message,
    this.icon,
    this.illustration,
    this.actionLabel,
    this.actionIcon = SIcons.refresh,
    this.onAction,
  });

  final String title;
  final String? message;
  final SIcons? icon;

  /// A picture in [icon]'s place, where the state deserves one (a list
  /// that's empty because nothing was added yet).
  final Illustration? illustration;
  final String? actionLabel;

  /// Refresh by default: most actions here are "Try again".
  final SIcons actionIcon;
  final VoidCallback? onAction;
}

/// Full-area states: loading, an error, or nothing to show.
abstract interface class StatusRenderer {
  Widget loading(BuildContext context, {String? message});
  Widget error(BuildContext context, StatusSpec spec);
  Widget empty(BuildContext context, StatusSpec spec);

  /// Something finished well: a big tick, [StatusSpec.title] and its
  /// message.
  Widget success(BuildContext context, StatusSpec spec);
}
