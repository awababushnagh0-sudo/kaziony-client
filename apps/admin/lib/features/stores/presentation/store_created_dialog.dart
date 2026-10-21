import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/store.dart';

/// The new owner's login, shown once: their phone and temporary password,
/// each with a copy button.
class StoreCreatedDialog extends StatelessWidget {
  const StoreCreatedDialog({required this.store, super.key});

  final CreatedStore store;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    final password = store.temporaryPassword;
    return AppDialog(
      title: s.storeCreatedTitle,
      width: 440,
      showCancel: false,
      primaryLabel: s.done,
      onPrimary: () => Navigator.pop(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppText(
            password == null
                ? s.ownerLinkedMessage(store.storeName)
                : s.storeCreatedMessage(store.storeName),
          ),
          const Gap(Space.xl),
          AppCopyField(
            label: s.loginPhone,
            value: _localPhone(store.ownerPhone),
          ),
          if (password != null) ...[
            const Gap(Space.lg),
            AppCopyField(label: s.temporaryPassword, value: password),
            const Gap(Space.md),
            AppText(
              s.passwordShownOnce,
              variant: TextVariant.caption,
              tone: TextTone.danger,
            ),
          ],
        ],
      ),
    );
  }
}

/// +218912345678 → 0912345678, the way owners type it in the store app.
String _localPhone(String phone) =>
    phone.startsWith('+218') ? '0${phone.substring(4)}' : phone;
