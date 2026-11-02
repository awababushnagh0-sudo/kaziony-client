import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/back_button.dart';
import '../../../core/widgets/customer_illustrations.dart';
import 'sign_in_view_model.dart';

/// Every way to sign in, on one page, or go on as a guest. At the end of
/// the welcome pages ([onboarding]) either leads home; from elsewhere,
/// back where they were.
class SignInScreen extends AppView {
  const SignInScreen({this.onboarding = false, super.key});

  final bool onboarding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final state = ref.watch(signInViewModel);

    void done() => onboarding ? context.go(Routes.home) : context.pop();

    return SWelcomePage(
      top: [if (!onboarding) const CustomerBackButton()],
      actions: [
        SSignInButton(
          brand: SignInBrand.apple,
          // Needs the Apple Developer account first.
          onPressed: () => SSnack.info(context, s.appleSignInSoon),
        ),
        SSignInButton(
          brand: SignInBrand.google,
          loading: state.signingIn,
          onPressed: () async {
            final signedIn = await ref
                .read(signInViewModel.notifier)
                .signInWithGoogle();
            if (signedIn && context.mounted) done();
          },
        ),
        // Browsing needs no account: a guest goes on, or back.
        SButton.text(label: s.continueAsGuest, onPressed: done),
        SLinkText(
          text: s.termsAgreement,
          link: s.termsTitle,
          onTap: () => context.push(Routes.terms),
          align: TextAlign.center,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SIllustration(CustomerIllustrations.logo),
          const Gap(Space.xl),
          SText.display(s.signInTitle, align: TextAlign.center),
          const Gap(Space.sm),
          SText(
            s.signInMessage,
            color: SColor.textMuted,
            align: TextAlign.center,
          ),
          if (state.failure case final failure?) ...[
            const Gap(Space.lg),
            SText(
              failureMessage(context, failure),
              color: SColor.danger,
              align: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
