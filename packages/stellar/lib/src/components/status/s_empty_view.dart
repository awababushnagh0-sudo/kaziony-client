import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../icon/s_icon.dart';
import '../illustration/s_illustration_renderer.dart';
import 's_status_renderer.dart';

/// Nothing to show: a picture ([illustration]) or an icon, a title, a line
/// on what to do, and the button that does it. Centered where it's shown,
/// a whole page or a section of one.
class SEmptyView extends StatelessWidget {
  const SEmptyView({
    required this.title,
    this.message,
    this.icon = SIcons.empty,
    this.illustration,
    this.actionLabel,
    this.actionIcon = SIcons.refresh,
    this.onAction,
    super.key,
  });

  final String title;
  final String? message;
  final SIcons icon;

  /// Shown instead of [icon].
  final Illustration? illustration;
  final String? actionLabel;
  final SIcons actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => StellarKit.of(context).status.empty(
    context,
    StatusSpec(
      title: title,
      message: message,
      icon: icon,
      illustration: illustration,
      actionLabel: actionLabel,
      actionIcon: actionIcon,
      onAction: onAction,
    ),
  );
}
