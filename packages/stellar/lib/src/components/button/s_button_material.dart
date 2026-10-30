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
      ButtonVariant.soft => colors.text,
      ButtonVariant.dangerSoft ||
      ButtonVariant.dangerSecondary => colors.danger,
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
            size: (spec.smallIcon ? SIconSize.xs : SIconSize.md).pixels,
          );
    const iconAlignment = IconAlignment.end;
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
      ButtonVariant.soft => _filled(
        background: colors.fieldFill,
        foreground: colors.text,
        onPressed: onPressed,
        icon: icon,
        iconAlignment: iconAlignment,
        child: child,
      ),
      ButtonVariant.dangerSoft => _filled(
        background: colors.dangerSoft,
        foreground: colors.danger,
        onPressed: onPressed,
        icon: icon,
        iconAlignment: iconAlignment,
        child: child,
      ),
      ButtonVariant.dangerSecondary => () {
        // Laid out like a row of the page: the icon first, at the start.
        final style = OutlinedButton.styleFrom(
          backgroundColor: colors.surface,
          foregroundColor: colors.danger,
          side: BorderSide.none,
          alignment: AlignmentDirectional.centerStart,
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
        );
        return icon == null
            ? OutlinedButton(style: style, onPressed: onPressed, child: child)
            : OutlinedButton.icon(
                style: style,
                onPressed: onPressed,
                icon: icon,
                label: child,
              );
      }(),
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

  /// A filled button in quieter colors than the primary one.
  static Widget _filled({
    required Color background,
    required Color foreground,
    required VoidCallback? onPressed,
    required Widget? icon,
    required IconAlignment iconAlignment,
    required Widget child,
  }) {
    final style = FilledButton.styleFrom(
      backgroundColor: background,
      foregroundColor: foreground,
    );
    return icon == null
        ? FilledButton(style: style, onPressed: onPressed, child: child)
        : FilledButton.icon(
            style: style,
            onPressed: onPressed,
            icon: icon,
            iconAlignment: iconAlignment,
            label: child,
          );
  }

  @override
  Widget icon(BuildContext context, IconButtonSpec spec) => IconButton(
    tooltip: spec.tooltip,
    onPressed: spec.onPressed,
    icon: Icon(materialIcon(spec.icon), size: SIconSize.md.pixels),
  );
}
