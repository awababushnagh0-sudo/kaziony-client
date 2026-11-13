import 'package:kernel/kernel.dart';

import '../l10n/generated/admin_localizations.dart';

/// The dashboard's words for the conflicts it can meet on more than one screen,
/// which every `failureMessage` uses (SApp's `failureWording`). Screens
/// still word the ones only they meet; null leaves the rest to them.
String? adminFailureWording(BuildContext context, AppFailure failure) {
  final s = AdminLocalizations.of(context);
  return switch (failure) {
    ConflictFailure(code: 'AccountDeleted') => s.errorAccountDeleted,
    ConflictFailure(code: 'EmailTaken') => s.errorEmailTaken,
    ConflictFailure(code: 'PhoneTaken') => s.errorPhoneTaken,
    ConflictFailure(code: 'AlreadyMember') => s.errorAlreadyMember,
    ConflictFailure(code: 'StoreIsLive') => s.errorStoreIsLive,
    _ => null,
  };
}
