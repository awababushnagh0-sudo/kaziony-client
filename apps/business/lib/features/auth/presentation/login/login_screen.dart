import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/business_localizations.dart';
import '../../../../core/widgets/language_button.dart';
import 'login_view_model.dart';

class LoginScreen extends AppView {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = BusinessLocalizations.of(context);
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

    return AppScaffold(
      actions: const [LanguageButton()],
      scrollable: true,
      body: AppForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(Space.xl),
            AppText.display(s.loginTitle),
            const Gap(Space.sm),
            AppText(s.loginSubtitle, tone: TextTone.muted),
            const Gap(Space.xxl),
            AppTextInput(
              controlName: 'phone',
              label: s.phoneLabel,
              hint: '0912345678',
              kind: TextInputKind.phone,
              autofillHints: const ['telephoneNumber'],
            ),
            const Gap(Space.lg),
            AppTextInput(
              controlName: 'password',
              label: s.passwordLabel,
              kind: TextInputKind.password,
              autofillHints: const ['password'],
              isLast: true,
              onSubmitted: viewModel.submit,
            ),
            if (error != null) ...[
              const Gap(Space.lg),
              AppText(error, tone: TextTone.danger),
            ],
            const Gap(Space.xl),
            AppButton(
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
