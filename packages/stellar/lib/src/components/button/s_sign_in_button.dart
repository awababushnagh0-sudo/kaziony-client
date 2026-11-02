import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../l10n/generated/stellar_localizations.dart';
import 's_button_renderer.dart';

/// Signs in with another company's account ("Continue with Google"): full
/// width, with its mark before the words.
class SSignInButton extends StatelessWidget {
  const SSignInButton({
    required this.provider,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  final SignInProvider provider;
  final VoidCallback? onPressed;

  /// Shows a spinner and ignores taps, so it can't start twice.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final s = StellarLocalizations.of(context);
    return StellarKit.of(context).button.signIn(
      context,
      SignInButtonSpec(
        provider: provider,
        label: switch (provider) {
          SignInProvider.apple => s.continueWithApple,
          SignInProvider.google => s.continueWithGoogle,
        },
        onPressed: onPressed,
        loading: loading,
      ),
    );
  }
}
