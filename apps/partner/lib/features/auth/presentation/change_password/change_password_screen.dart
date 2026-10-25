import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import 'change_password_view_model.dart';

/// Right after logging in with a temporary password ([temporary]), or
/// from Profile to change one's own.
class ChangePasswordScreen extends AppView {
  const ChangePasswordScreen({this.temporary = true, super.key});

  final bool temporary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final state = ref.watch(changePasswordViewModel);
    final viewModel = ref.read(changePasswordViewModel.notifier);

    Future<void> submit() async {
      final changed = await viewModel.submit();
      if (!changed || !context.mounted) return;
      SSnack.success(context, s.passwordChanged);
      // A temporary password: the router moves on by itself.
      if (!temporary) context.pop();
    }

    final error = state.wrongCurrentPassword
        ? (temporary ? s.wrongCurrentPassword : s.wrongOldPassword)
        : state.failure == null
        ? null
        : failureMessage(context, state.failure!);

    final form = SForm(
      form: viewModel.form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          STextInput(
            controlName: 'current',
            label: temporary ? s.currentPasswordLabel : s.oldPasswordLabel,
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
            label: temporary ? s.savePasswordButton : s.save,
            onPressed: submit,
            loading: state.submitting,
            expand: true,
          ),
        ],
      ),
    );

    if (!temporary) {
      return SScaffold(
        title: s.changePasswordAction,
        scrollable: true,
        body: form,
      );
    }
    return SAuthPage(
      title: s.changePasswordTitle,
      subtitle: s.changePasswordSubtitle,
      footer: [SButton.text(label: s.logout, onPressed: viewModel.logout)],
      child: form,
    );
  }
}
