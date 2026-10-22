import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';

/// A user's login, shown once after they're added or their password is
/// reset: their email and temporary password, each with a copy button.
class UserLoginDialog extends StatelessWidget {
  const UserLoginDialog({
    required this.title,
    required this.message,
    required this.email,
    required this.password,
    super.key,
  });

  final String title;
  final String message;
  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    return SDialog(
      title: title,
      width: 440,
      showCancel: false,
      primaryLabel: s.done,
      onPrimary: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SText(message),
          const Gap(Space.xl),
          SCopyField(label: s.loginEmail, value: email),
          const Gap(Space.lg),
          SCopyField(label: s.temporaryPassword, value: password),
          const Gap(Space.md),
          SText(
            s.passwordShownOnce,
            variant: TextVariant.caption,
            color: SColor.danger,
          ),
        ],
      ),
    );
  }
}
