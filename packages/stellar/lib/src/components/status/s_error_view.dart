import 'package:kernel/kernel.dart';

import '../../foundation/s_scope.dart';
import '../../l10n/generated/stellar_localizations.dart';
import 's_status_material.dart';

/// A short, translated message for a failure, for snacks and form errors:
/// in the app's words when it has some (SApp's `failureWording`).
String failureMessage(BuildContext context, AppFailure failure) {
  final scope = context.getInheritedWidgetOfExactType<StellarScope>();
  if (scope?.failureWording?.call(context, failure) case final words?) {
    return words;
  }
  final s = StellarLocalizations.of(context);
  final english = Localizations.localeOf(context).languageCode == 'en';
  return switch (failure) {
    NoConnectionFailure() => s.errorNoConnectionTitle,
    TimeoutFailure() => s.errorTimeout,
    UnauthorizedFailure() => s.errorUnauthorized,
    PasswordChangeRequiredFailure() => s.errorPasswordChangeRequired,
    ForbiddenFailure() => s.errorForbidden,
    ValidationFailure() => s.errorInvalid,
    NotFoundFailure() => s.errorNotFound,
    // Conflicts explain themselves ("Sold out"), in English: features and
    // apps word the ones they expect, and the server's text is shown as it
    // is only to someone reading English.
    ConflictFailure(:final serverMessage?) when english => serverMessage,
    ConflictFailure() => s.errorConflict,
    RateLimitedFailure() => s.errorRateLimited,
    ServerFailure() => s.errorServer,
    UnknownFailure() => s.errorUnknown,
  };
}

/// A full-screen error with a retry button.
abstract interface class SErrorView implements Widget {
  /// Without [onRetry] there's no button.
  const factory SErrorView({
    required AppFailure failure,
    VoidCallback? onRetry,
    Key? key,
  }) = SErrorViewMaterial;
}
