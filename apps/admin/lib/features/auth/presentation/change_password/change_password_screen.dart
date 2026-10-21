import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/admin_localizations.dart';
import '../auth_page.dart';
import 'change_password_view_model.dart';

/// Shown right after signing in with a temporary password.
class ChangePasswordScreen extends AppView {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final state = ref.watch(changePasswordViewModel);
    final viewModel = ref.read(changePasswordViewModel.notifier);

    Future<void> submit() async {
      final changed = await viewModel.submit();
      if (changed && context.mounted) {
        SSnack.success(context, s.passwordChanged);
      }
    }

    final error = state.wrongCurrentPassword
        ? s.wrongCurrentPassword
        : state.failure == null
        ? null
        : failureMessage(context, state.failure!);

    return AuthPage(
      title: s.changePasswordTitle,
      subtitle: s.changePasswordSubtitle,
      footer: [SButton.text(label: s.logout, onPressed: viewModel.logout)],
      child: SForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            STextInput(
              controlName: 'current',
              label: s.currentPasswordLabel,
              kind: TextInputKind.password,
            ),
            const Gap(Space.lg),
            STextInput(
              controlName: 'password',
              label: s.newPasswordLabel,
              kind: TextInputKind.password,
              autofillHints: const ['newPassword'],
            ),
            const Gap(Space.lg),
            STextInput(
              controlName: 'confirm',
              label: s.confirmPasswordLabel,
              kind: TextInputKind.password,
              autofillHints: const ['newPassword'],
              isLast: true,
              onSubmitted: submit,
            ),
            if (error != null) ...[
              const Gap(Space.lg),
              SText(error, color: SColor.danger),
            ],
            const Gap(Space.xl),
            SButton(
              label: s.savePasswordButton,
              onPressed: submit,
              loading: state.submitting,
              expand: true,
            ),
          ],
        ),
      ),
    );
  }
}
