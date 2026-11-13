import 'package:kernel/kernel.dart';

import '../l10n/generated/customer_localizations.dart';

/// The customer app's words for the conflicts it can meet on more than one screen,
/// which every `failureMessage` uses (SApp's `failureWording`). Screens
/// still word the ones only they meet; null leaves the rest to them.
String? customerFailureWording(BuildContext context, AppFailure failure) {
  final s = CustomerLocalizations.of(context);
  return switch (failure) {
    ConflictFailure(code: 'NotCancellable') => s.errorNotCancellable,
    ConflictFailure(code: 'TooManyPlaces') => s.errorTooManyPlaces,
    _ => null,
  };
}
