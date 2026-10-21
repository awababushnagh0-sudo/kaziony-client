import 'package:kernel/kernel.dart';

import '../../foundation/s_kit.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import 's_status_renderer.dart';

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
class SErrorView extends StatelessWidget {
  const SErrorView({required this.failure, this.onRetry, super.key});

  final AppFailure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final s = StellarLocalizations.of(context);
    final offline = failure is NoConnectionFailure;
    return StellarKit.of(context).status.error(
      context,
      StatusSpec(
        title: offline
            ? s.errorNoConnectionTitle
            : failureMessage(context, failure),
        message: offline ? s.errorNoConnectionMessage : null,
        icon: offline ? SIcons.noConnection : SIcons.error,
        actionLabel: onRetry == null ? null : s.retry,
        onAction: onRetry,
      ),
    );
  }
}
