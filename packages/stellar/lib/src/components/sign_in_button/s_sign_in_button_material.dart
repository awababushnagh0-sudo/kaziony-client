import 'package:flutter/material.dart';

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import 's_sign_in_button.dart';

/// [SSignInButton], drawn with Material's [OutlinedButton].
class SSignInButtonMaterial extends StatelessWidget implements SSignInButton {
  const SSignInButtonMaterial({
    required this.brand,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  final SignInBrand brand;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final s = StellarLocalizations.of(context);
    final label = switch (brand) {
      SignInBrand.apple => s.continueWithApple,
      SignInBrand.google => s.continueWithGoogle,
    };
    final colors = context.colors;
    // Each company's rules: Apple's is solid, dark on a light screen and
    // light on a dark one, its mark in the words' color; Google's is plain
    // with a border, its mark in color.
    final (background, foreground, border, mark, tint) = switch (brand) {
      SignInBrand.apple => (
        colors.text,
        colors.surface,
        BorderSide.none,
        'apple',
        colors.surface,
      ),
      SignInBrand.google => (
        colors.surface,
        colors.text,
        BorderSide(color: colors.border),
        'google',
        null,
      ),
    };
    final icon = loading
        ? SizedBox.square(
            dimension: SIconSize.md.pixels,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: foreground,
            ),
          )
        : Image.asset(
            'assets/brands/$mark.png',
            package: 'stellar',
            width: SIconSize.md.pixels,
            height: SIconSize.md.pixels,
            color: tint,
            excludeFromSemantics: true,
          );
    return SizedBox(
      width: double.infinity,
      child: AbsorbPointer(
        absorbing: loading,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            side: border,
          ),
          onPressed: loading ? () {} : onPressed,
          icon: icon,
          label: Text(label),
        ),
      ),
    );
  }
}
