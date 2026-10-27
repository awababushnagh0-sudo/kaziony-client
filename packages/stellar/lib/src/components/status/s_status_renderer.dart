import 'package:flutter/widgets.dart';

import '../icon/s_icon.dart';

@immutable
class StatusSpec {
  const StatusSpec({
    required this.title,
    this.message,
    this.icon,
    this.actionLabel,
    this.actionIcon = SIcons.refresh,
    this.onAction,
  });

  final String title;
  final String? message;
  final SIcons? icon;
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
