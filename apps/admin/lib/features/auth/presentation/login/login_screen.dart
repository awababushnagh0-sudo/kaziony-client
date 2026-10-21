import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/admin_localizations.dart';
import '../auth_page.dart';
import 'login_view_model.dart';

class LoginScreen extends AppView {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final state = ref.watch(loginViewModel);
    final viewModel = ref.read(loginViewModel.notifier);
    final expired = switch (ref.watch(sessionProvider)) {
      SignedOut(:final expired) => expired,
      _ => false,
    };

    final error = switch (state) {
      LoginState(problem: LoginProblem.wrongCredentials) => s.wrongCredentials,
      LoginState(problem: LoginProblem.accountDisabled) => s.accountDisabled,
      LoginState(problem: LoginProblem.notAdminAccount) => s.notAdminAccount,
      LoginState(:final failure?) => failureMessage(context, failure),
      _ when expired => s.sessionExpired,
      _ => null,
    };

    return AuthPage(
      title: s.loginTitle,
      subtitle: s.loginSubtitle,
      child: SForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            STextInput(
              controlName: 'email',
              label: s.emailLabel,
              hint: 'name@example.com',
              kind: TextInputKind.email,
              autofillHints: const ['email'],
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
