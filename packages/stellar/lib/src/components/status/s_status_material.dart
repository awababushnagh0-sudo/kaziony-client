import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
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

  Widget _status(BuildContext context, StatusSpec spec, Color iconColor) {
    final theme = Theme.of(context).textTheme;
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (spec.icon != null)
              Icon(
                materialIcon(spec.icon!),
                size: SIconSize.xl.pixels,
                color: iconColor,
              ),
            const Gap(Space.lg),
            Text(
              spec.title,
              textAlign: TextAlign.center,
              style: theme.titleMedium?.copyWith(color: colors.text),
            ),
            if (spec.message != null) ...[
              const Gap(Space.sm),
              Text(
                spec.message!,
                textAlign: TextAlign.center,
                style: theme.bodyMedium?.copyWith(color: colors.textMuted),
              ),
            ],
            if (spec.actionLabel != null && spec.onAction != null) ...[
              const Gap(Space.xl),
              OutlinedButton.icon(
                onPressed: spec.onAction,
                icon: Icon(
                  materialIcon(spec.actionIcon),
                  size: SIconSize.sm.pixels,
                ),
                label: Text(spec.actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
