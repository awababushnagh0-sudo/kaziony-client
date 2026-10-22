import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/dashboard_user.dart';
import 'add_user_view_model.dart';
import 'role_label.dart';

/// The form for someone new on the team. Pops with the added user.
class AddUserDialog extends AppView {
  const AddUserDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final state = ref.watch(addUserViewModel);
    final viewModel = ref.read(addUserViewModel.notifier);

    Future<void> submit() async {
      final created = await viewModel.submit();
      if (created != null && context.mounted) Navigator.pop(context, created);
    }

    final failure = state.failure;
    return SDialog(
      title: s.addUserTitle,
      width: 480,
      primaryLabel: s.addUser,
      onPrimary: submit,
      busy: state.submitting,
      body: SForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            STextInput(
              controlName: 'name',
              label: s.userName,
              required: true,
              autofocus: true,
            ),
            const Gap(Space.lg),
            STextInput(
              controlName: 'email',
              label: s.userEmail,
              helper: s.userEmailHelp,
              kind: TextInputKind.email,
              required: true,
              validationMessages: {emailTakenError: (_) => s.emailTaken},
            ),
            const Gap(Space.lg),
            SSelectInput<DashboardRole>(
              controlName: 'role',
              label: s.userRole,
              required: true,
              options: [
                for (final role in DashboardRole.values)
                  SelectOption(role, roleLabel(s, role)),
              ],
            ),
            const Gap(Space.sm),
            SText(
              s.userRoleHelp,
              variant: TextVariant.caption,
              color: SColor.textMuted,
            ),
            if (failure != null) ...[
              const Gap(Space.lg),
              SText(failureMessage(context, failure), color: SColor.danger),
            ],
          ],
        ),
      ),
    );
  }
}
