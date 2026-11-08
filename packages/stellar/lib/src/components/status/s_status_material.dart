import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart' show AppFailure, NoConnectionFailure;

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../button/s_button.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration.dart';
import 's_empty_view.dart';
import 's_error_view.dart';
import 's_loading_view.dart';
import 's_success_view.dart';
import 's_update_required_view.dart';

/// [SLoadingView], with Material's [CircularProgressIndicator].
class SLoadingViewMaterial extends StatelessWidget implements SLoadingView {
  const SLoadingViewMaterial({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const Gap(Space.lg),
            Text(message, style: TextStyle(color: context.colors.textMuted)),
          ],
        ],
      ),
    );
  }
}

/// [SEmptyView]: its icon in the muted color.
class SEmptyViewMaterial extends StatelessWidget implements SEmptyView {
  const SEmptyViewMaterial({
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
  final Illustration? illustration;
  final String? actionLabel;
  final SIcons actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => _status(
    context,
    iconColor: context.colors.textMuted,
    title: title,
    message: message,
    icon: icon,
    illustration: illustration,
    actionLabel: actionLabel,
    actionIcon: actionIcon,
    onAction: onAction,
  );
}

/// [SErrorView]: its icon in red, with a page of its own for being
/// offline.
class SErrorViewMaterial extends StatelessWidget implements SErrorView {
  const SErrorViewMaterial({required this.failure, this.onRetry, super.key});

  final AppFailure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final s = StellarLocalizations.of(context);
    final offline = failure is NoConnectionFailure;
    return _status(
      context,
      iconColor: context.colors.danger,
      title: offline
          ? s.errorNoConnectionTitle
          : failureMessage(context, failure),
      message: offline ? s.errorNoConnectionMessage : null,
      icon: offline ? SIcons.noConnection : SIcons.error,
      actionLabel: onRetry == null ? null : s.retry,
      onAction: onRetry,
    );
  }
}

/// [SUpdateRequiredView], laid out like an [SEmptyView].
class SUpdateRequiredViewMaterial extends StatelessWidget
    implements SUpdateRequiredView {
  const SUpdateRequiredViewMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    final s = StellarLocalizations.of(context);
    return _status(
      context,
      iconColor: context.colors.textMuted,
      title: s.updateRequiredTitle,
      message: s.updateRequiredMessage,
      icon: SIcons.update,
    );
  }
}

/// [SSuccessView]: the icon big on a soft green circle.
class SSuccessViewMaterial extends StatelessWidget implements SSuccessView {
  const SSuccessViewMaterial({
    required this.title,
    this.message,
    this.icon = SIcons.success,
    super.key,
  });

  final String title;
  final String? message;
  final SIcons icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colors = context.colors;
    final message = this.message;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              materialIcon(icon),
              size: SIconSize.xl.pixels,
              color: colors.success,
            ),
            const Gap(Space.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.headlineMedium?.copyWith(color: colors.text),
            ),
            if (message != null) ...[
              const Gap(Space.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.bodyLarge?.copyWith(color: colors.textMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The picture or icon, the title and message, and the action, in a
/// column a little narrower than the page.
Widget _status(
  BuildContext context, {
  required Color iconColor,
  required String title,
  String? message,
  SIcons? icon,
  Illustration? illustration,
  String? actionLabel,
  SIcons actionIcon = SIcons.refresh,
  VoidCallback? onAction,
}) {
  final colors = context.colors;
  final text = context.style.text;
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(Space.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (illustration != null)
            SIllustration(illustration)
          else if (icon != null)
            Icon(
              materialIcon(icon),
              size: SIconSize.xl.pixels,
              color: iconColor,
            ),
          const Gap(Space.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: text.title,
              fontWeight: SFontWeight.bold.value,
              color: colors.text,
            ),
          ),
          if (message != null) ...[
            const Gap(Space.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: text.body, color: colors.textMuted),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const Gap(Space.xl),
            SButton(
              label: actionLabel,
              // Under a picture, words alone: an icon too would crowd it.
              icon: illustration == null ? actionIcon : null,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    ),
  );
}
