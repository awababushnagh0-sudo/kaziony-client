import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/widgets/partner_illustrations.dart';
import 'login_view_model.dart';

class LoginScreen extends AppView {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final state = ref.watch(loginViewModel);
    final viewModel = ref.read(loginViewModel.notifier);
    final expired = switch (ref.watch(sessionProvider)) {
      SignedOut(:final expired) => expired,
      _ => false,
    };

    final error = switch (state) {
      LoginState(problem: LoginProblem.wrongCredentials) => s.wrongCredentials,
      LoginState(problem: LoginProblem.accountDisabled) => s.accountDisabled,
      LoginState(problem: LoginProblem.notStoreAccount) => s.notStoreAccount,
      LoginState(:final failure?) => failureMessage(context, failure),
      _ when expired => s.sessionExpired,
      _ => null,
    };

    return SAuthPage(
      title: s.loginTitle,
      subtitle: s.loginSubtitle,
      hero: const SAuthHero(
        mark: PartnerIllustrations.partnerMark,
        illustration: PartnerIllustrations.signInHero,
      ),
      actions: const [SLanguageButton()],
      footer: [
        Column(
          children: [
            SLinkText(
              text: s.loginJoinHint,
              link: s.contactUs,
              onTap: () => context.push(Routes.contact),
              align: TextAlign.center,
            ),
            const Gap(Space.sm),
            SLinkText(
              text: s.termsAgreement,
              link: s.termsTitle,
              onTap: () => context.push(Routes.terms),
              align: TextAlign.center,
            ),
          ],
        ),
      ],
      child: SForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            STextInput(
              controlName: 'phone',
              label: s.phoneLabel,
              hint: '091-000-000',
              kind: TextInputKind.phone,
              autofillHints: const ['telephoneNumber'],
            ),
            const Gap(Space.lg),
            STextInput(
              controlName: 'password',
              label: s.passwordLabel,
              kind: TextInputKind.password,
              autofillHints: const ['password'],
              isLast: true,
              onSubmitted: viewModel.submit,
            ),
            // Our team resets it: there's no code by SMS.
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: SButton.text(
                label: s.forgotPassword,
                onPressed: () => context.push(Routes.contact),
              ),
            ),
            if (error != null) ...[
              const Gap(Space.lg),
              SText(error, color: SColor.danger),
            ],
            const Gap(Space.xl),
            SButton(
              label: s.loginButton,
              onPressed: viewModel.submit,
              loading: state.submitting,
              expand: true,
            ),
          ],
        ),
      ),
    );
  }
}
