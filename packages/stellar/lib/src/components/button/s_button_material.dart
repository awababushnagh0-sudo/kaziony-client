import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../icon/s_icon.dart';
import '../icon/s_icon_material.dart';
import 's_button.dart';

enum _Variant {
  primary,
  secondary,
  text,

  /// Gray on the surface: the quieter one of two side by side.
  soft,

  /// Light red with red words: a for-good action that isn't the page's
  /// main one.
  dangerSoft,

  /// Red words and icon on the surface, from the start like a page's row:
  /// leaving (logging out), at the foot of a page.
  dangerSecondary,
}

/// [SButton] with a label, drawn with Material's buttons.
class SButtonMaterial extends StatelessWidget implements SButton {
  const SButtonMaterial({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.expand = false,
    this.icon,
    super.key,
  }) : _variant = _Variant.primary,
       _smallIcon = false;

  const SButtonMaterial.secondary({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.expand = false,
    this.icon,
    super.key,
  }) : _variant = _Variant.secondary,
       _smallIcon = false;

  const SButtonMaterial.soft({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.expand = false,
    this.icon,
    super.key,
  }) : _variant = _Variant.soft,
       _smallIcon = false;

  const SButtonMaterial.dangerSoft({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.expand = false,
    this.icon,
    super.key,
  }) : _variant = _Variant.dangerSoft,
       _smallIcon = false;

  const SButtonMaterial.dangerSecondary({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.expand = false,
    this.icon,
    super.key,
  }) : _variant = _Variant.dangerSecondary,
       _smallIcon = false;

  const SButtonMaterial.text({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  }) : _variant = _Variant.text,
       loading = false,
       expand = false,
       _smallIcon = false;

  const SButtonMaterial.menu({
    required this.label,
    required this.onPressed,
    super.key,
  }) : _variant = _Variant.primary,
       icon = SIcons.chevronUpDown,
       loading = false,
       expand = false,
       _smallIcon = true;

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool expand;
  final SIcons? icon;
  final _Variant _variant;

  /// A smaller icon: a menu button's chevron.
  final bool _smallIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spinnerColor = switch (_variant) {
      _Variant.primary => colors.onPrimary,
      _Variant.soft => colors.text,
      _Variant.dangerSoft || _Variant.dangerSecondary => colors.danger,
      _ => colors.primary,
    };
    final Widget child = loading
        ? SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: spinnerColor,
            ),
          )
        : Text(label);
    final icon = this.icon;
    final iconWidget = icon == null || loading
        ? null
        : Icon(
            materialIcon(icon),
            size: (_smallIcon ? SIconSize.xs : SIconSize.md).pixels,
          );
    const iconAlignment = IconAlignment.end;
    // While loading the button keeps its look but ignores taps.
    final onPressed = loading ? () {} : this.onPressed;

    final Widget button = switch (_variant) {
      _Variant.primary =>
        iconWidget == null
            ? FilledButton(onPressed: onPressed, child: child)
            : FilledButton.icon(
                onPressed: onPressed,
                icon: iconWidget,
                iconAlignment: iconAlignment,
                label: child,
              ),
      _Variant.secondary =>
        iconWidget == null
            ? OutlinedButton(onPressed: onPressed, child: child)
            : OutlinedButton.icon(
                onPressed: onPressed,
                icon: iconWidget,
                iconAlignment: iconAlignment,
                label: child,
              ),
      _Variant.soft => _filled(
        background: colors.fieldFill,
        foreground: colors.text,
        onPressed: onPressed,
        icon: iconWidget,
        iconAlignment: iconAlignment,
        child: child,
      ),
      _Variant.dangerSoft => _filled(
        background: colors.dangerSoft,
        foreground: colors.danger,
        onPressed: onPressed,
        icon: iconWidget,
        iconAlignment: iconAlignment,
        child: child,
      ),
      _Variant.dangerSecondary => () {
        // Laid out like a row of the page: the icon first, at the start.
        final style = OutlinedButton.styleFrom(
          backgroundColor: colors.surface,
          foregroundColor: colors.danger,
          side: BorderSide.none,
          alignment: AlignmentDirectional.centerStart,
          padding: const EdgeInsets.symmetric(horizontal: Space.lg),
        );
        return iconWidget == null
            ? OutlinedButton(style: style, onPressed: onPressed, child: child)
            : OutlinedButton.icon(
                style: style,
                onPressed: onPressed,
                icon: iconWidget,
                label: child,
              );
      }(),
      _Variant.text =>
        iconWidget == null
            ? TextButton(onPressed: onPressed, child: child)
            : TextButton.icon(
                onPressed: onPressed,
                icon: iconWidget,
                iconAlignment: iconAlignment,
                label: child,
              ),
    };
    final Widget guarded = AbsorbPointer(absorbing: loading, child: button);
    return expand ? SizedBox(width: double.infinity, child: guarded) : guarded;
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
}

/// [SButton.onPhoto], drawn with Material's [FilledButton].
class SPhotoButtonMaterial extends StatelessWidget implements SButton {
  const SPhotoButtonMaterial({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final SIcons icon;
  final VoidCallback? onPressed;

  /// Lower than a page's buttons, to leave the photo seen; taps still get
  /// the usual room around it.
  static const _height = 36.0;
  static const _lift = 3.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: c.surface,
        foregroundColor: c.primary,
        elevation: _lift,
        shadowColor: c.shadow,
        minimumSize: const Size(0, _height),
        padding: const EdgeInsets.symmetric(horizontal: Space.md),
        textStyle: TextStyle(
          fontFamily: stellarFont,
          fontSize: context.style.text.small,
          fontWeight: SFontWeight.bold.value,
        ),
      ),
      onPressed: onPressed,
      icon: Icon(materialIcon(icon), size: SIconSize.xs.pixels),
      iconAlignment: IconAlignment.end,
      label: Text(label),
    );
  }
}

/// [SButton.icon], drawn with Material's [IconButton].
class SIconButtonMaterial extends StatelessWidget implements SButton {
  const SIconButtonMaterial({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final SIcons icon;

  /// Also what screen readers say.
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: Icon(materialIcon(icon), size: SIconSize.md.pixels),
  );
}
