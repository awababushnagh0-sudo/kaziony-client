import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../button/s_button.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import '../illustration/s_illustration.dart';
import 's_status_renderer.dart';

class MaterialStatusRenderer implements StatusRenderer {
  const MaterialStatusRenderer();

  @override
  Widget loading(BuildContext context, {String? message}) => Center(
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

  @override
  Widget error(BuildContext context, StatusSpec spec) =>
      _status(context, spec, context.colors.danger);

  @override
  Widget empty(BuildContext context, StatusSpec spec) =>
      _status(context, spec, context.colors.textMuted);

  @override
  Widget success(BuildContext context, StatusSpec spec) {
    final theme = Theme.of(context).textTheme;
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.successSoft,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(Space.xl),
                child: Icon(
                  materialIcon(spec.icon ?? SIcons.success),
                  size: SIconSize.xl.pixels,
                  color: colors.success,
                ),
              ),
            ),
            const Gap(Space.xl),
            Text(
              spec.title,
              textAlign: TextAlign.center,
              style: theme.headlineMedium?.copyWith(color: colors.text),
            ),
            if (spec.message != null) ...[
              const Gap(Space.sm),
              Text(
                spec.message!,
                textAlign: TextAlign.center,
                style: theme.bodyLarge?.copyWith(color: colors.textMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// The picture or icon, the title and message, and the action, in a
  /// column a little narrower than the page.
  Widget _status(BuildContext context, StatusSpec spec, Color iconColor) {
    final colors = context.colors;
    final text = context.style.text;
    final message = spec.message;
    final actionLabel = spec.actionLabel;
    final onAction = spec.onAction;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (spec.illustration case final illustration?)
              SIllustration(illustration)
            else if (spec.icon case final icon?)
              Icon(
                materialIcon(icon),
                size: SIconSize.xl.pixels,
                color: iconColor,
              ),
            const Gap(Space.lg),
            Text(
              spec.title,
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
                icon: spec.actionIcon,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
