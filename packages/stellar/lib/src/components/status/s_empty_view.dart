import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../icon/s_icon.dart';
import 's_status_renderer.dart';

class SEmptyView extends StatelessWidget {
  const SEmptyView({
    required this.title,
    this.message,
    this.icon = SIcons.empty,
    this.actionLabel,
    this.actionIcon = SIcons.refresh,
    this.onAction,
    super.key,
  });

  final String title;
  final String? message;
  final SIcons icon;
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
      actionLabel: actionLabel,
      actionIcon: actionIcon,
      onAction: onAction,
    ),
  );
}
