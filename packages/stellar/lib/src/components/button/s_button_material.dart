import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon_material.dart';
import 's_button_renderer.dart';

class MaterialButtonRenderer implements ButtonRenderer {
  const MaterialButtonRenderer();

  @override
  Widget render(BuildContext context, ButtonSpec spec) {
    final colors = context.colors;
    final spinnerColor = switch (spec.variant) {
      ButtonVariant.primary => colors.onPrimary,
      ButtonVariant.danger => colors.onDanger,
      _ => colors.primary,
    };
    final Widget child = spec.loading
        ? SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: spinnerColor,
            ),
          )
        : Text(spec.label);
    final icon = spec.icon == null || spec.loading
        ? null
        : Icon(
            materialIcon(spec.icon!),
            size: (spec.iconAtEnd ? SIconSize.xs : SIconSize.md).pixels,
          );
    final iconAlignment = spec.iconAtEnd
        ? IconAlignment.end
        : IconAlignment.start;
    // While loading the button keeps its look but ignores taps.
    final onPressed = spec.loading ? () {} : spec.onPressed;

    final Widget button = switch (spec.variant) {
      ButtonVariant.primary =>
        icon == null
            ? FilledButton(onPressed: onPressed, child: child)
            : FilledButton.icon(
                onPressed: onPressed,
                icon: icon,
                iconAlignment: iconAlignment,
                label: child,
              ),
      ButtonVariant.danger => FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: colors.danger,
          foregroundColor: colors.onDanger,
        ),
        onPressed: onPressed,
        child: child,
      ),
      ButtonVariant.secondary =>
        icon == null
            ? OutlinedButton(onPressed: onPressed, child: child)
            : OutlinedButton.icon(
                onPressed: onPressed,
                icon: icon,
                iconAlignment: iconAlignment,
                label: child,
              ),
      ButtonVariant.text =>
        icon == null
            ? TextButton(onPressed: onPressed, child: child)
            : TextButton.icon(
                onPressed: onPressed,
                icon: icon,
                iconAlignment: iconAlignment,
                label: child,
              ),
    };
    final Widget guarded = AbsorbPointer(
      absorbing: spec.loading,
      child: button,
    );
    return spec.expand
        ? SizedBox(width: double.infinity, child: guarded)
        : guarded;
  }

  @override
  Widget icon(BuildContext context, IconButtonSpec spec) => IconButton(
    tooltip: spec.tooltip,
    onPressed: spec.onPressed,
    icon: Icon(materialIcon(spec.icon), size: SIconSize.md.pixels),
  );
}
