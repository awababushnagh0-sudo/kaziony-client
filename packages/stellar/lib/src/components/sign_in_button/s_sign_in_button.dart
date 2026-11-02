import 'package:flutter/widgets.dart';

import 's_sign_in_button_material.dart';

/// Whose logo and colors a sign-in button wears. Only the look: signing in
/// itself is kernel's.
enum SignInBrand { apple, google }

/// Signs in with another company's account ("Continue with Google"): full
/// width, with its mark before the words, as each company's rules ask.
abstract interface class SSignInButton implements Widget {
  /// [loading] shows a spinner and ignores taps, so it can't start twice.
  const factory SSignInButton({
    required SignInBrand brand,
    required VoidCallback? onPressed,
    bool loading,
    Key? key,
  }) = SSignInButtonMaterial;
}
