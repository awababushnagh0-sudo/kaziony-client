import 'package:kernel/kernel.dart';

import '../l10n/generated/partner_localizations.dart';

/// The partner app's words for the conflicts it can meet on more than one screen,
/// which every `failureMessage` uses (SApp's `failureWording`). Screens
/// still word the ones only they meet; null leaves the rest to them.
String? partnerFailureWording(BuildContext context, AppFailure failure) {
  final s = PartnerLocalizations.of(context);
  return switch (failure) {
    ConflictFailure(code: 'NotOutForDelivery') => s.errorNotOutForDelivery,
    ConflictFailure(code: 'AlreadyOutForDelivery') =>
      s.errorAlreadyOutForDelivery,
    ConflictFailure(code: 'NotRedeemable') => s.errorNotRedeemable,
    ConflictFailure(code: 'StoreDoesNotDeliver') => s.errorStoreDoesNotDeliver,
    ConflictFailure(code: 'OfferHasReservations') =>
      s.errorOfferHasReservations,
    _ => null,
  };
}
