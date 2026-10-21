import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/business_localizations.dart';
import 'change_password_view_model.dart';

/// Shown right after logging in with a temporary password.
class ChangePasswordScreen extends AppView {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = BusinessLocalizations.of(context);
    final state = ref.watch(changePasswordViewModel);
    final viewModel = ref.read(changePasswordViewModel.notifier);

    Future<void> submit() async {
      final changed = await viewModel.submit();
      if (changed && context.mounted) {
        AppSnack.success(context, s.passwordChanged);
      }
    }

    final error = state.wrongCurrentPassword
        ? s.wrongCurrentPassword
        : state.failure == null
        ? null
        : failureMessage(context, state.failure!);

    return AppScaffold(
      actions: [AppButton.text(label: s.logout, onPressed: viewModel.logout)],
      scrollable: true,
      body: AppForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(Space.lg),
            AppText.display(s.changePasswordTitle),
            const Gap(Space.sm),
            AppText(s.changePasswordSubtitle, tone: TextTone.muted),
            const Gap(Space.xxl),
            AppTextInput(
              controlName: 'current',
              label: s.currentPasswordLabel,
              kind: TextInputKind.password,
            ),
            const Gap(Space.lg),
            AppTextInput(
              controlName: 'password',
              label: s.newPasswordLabel,
              kind: TextInputKind.password,
              autofillHints: const ['newPassword'],
            ),
            const Gap(Space.lg),
            AppTextInput(
              controlName: 'confirm',
              label: s.confirmPasswordLabel,
              kind: TextInputKind.password,
              autofillHints: const ['newPassword'],
              isLast: true,
              onSubmitted: submit,
            ),
            if (error != null) ...[
              const Gap(Space.lg),
              AppText(error, tone: TextTone.danger),
            ],
            const Gap(Space.xl),
            AppButton(
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
