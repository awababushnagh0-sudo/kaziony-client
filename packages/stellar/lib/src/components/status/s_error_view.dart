import 'package:kernel/kernel.dart';

import '../../l10n/generated/stellar_localizations.dart';
import 's_status_material.dart';

/// A short, translated message for a failure, for snacks and form errors.
String failureMessage(BuildContext context, AppFailure failure) {
  final s = StellarLocalizations.of(context);
  return switch (failure) {
    NoConnectionFailure() => s.errorNoConnectionTitle,
    TimeoutFailure() => s.errorTimeout,
    UnauthorizedFailure() => s.errorUnauthorized,
    PasswordChangeRequiredFailure() => s.errorPasswordChangeRequired,
    ForbiddenFailure() => s.errorForbidden,
    ValidationFailure() => s.errorInvalid,
    NotFoundFailure() => s.errorNotFound,
    // Conflicts explain themselves ("Sold out"); features translate the
    // ones they expect, the rest show the server's text.
    ConflictFailure(:final serverMessage) => serverMessage ?? s.errorUnknown,
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
