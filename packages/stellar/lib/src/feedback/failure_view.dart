import 'package:kernel/kernel.dart';

import '../components/app_icon.dart';
import '../kit/contracts.dart';
import '../kit/stellar_kit.dart';
import '../l10n/generated/stellar_localizations.dart';

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
class AppErrorView extends StatelessWidget {
  const AppErrorView({required this.failure, this.onRetry, super.key});

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
        icon: offline ? AppIcon.noConnection : AppIcon.error,
        actionLabel: onRetry == null ? null : s.retry,
        onAction: onRetry,
      ),
    );
  }
}

/// Shows loading, error (with retry) or the data of an [AsyncValue].
class AppAsyncView<T> extends StatelessWidget {
  const AppAsyncView({
    required this.value,
    required this.builder,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) builder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => switch (value) {
    AsyncData(:final value) => builder(context, value),
    AsyncError(:final error) => AppErrorView(
      failure: error is AppFailure ? error : UnknownFailure(error),
      onRetry: onRetry,
    ),
    _ => const _Loading(),
  };
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) =>
      StellarKit.of(context).status.loading(context);
}

/// Full-screen "please update" shown when this version is too old.
class AppUpdateRequiredView extends StatelessWidget {
  const AppUpdateRequiredView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = StellarLocalizations.of(context);
    return StellarKit.of(context).status.empty(
      context,
      StatusSpec(
        title: s.updateRequiredTitle,
        message: s.updateRequiredMessage,
        icon: AppIcon.update,
      ),
    );
  }
}
