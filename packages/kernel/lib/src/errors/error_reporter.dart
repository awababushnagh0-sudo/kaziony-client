import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sends crashes and unexpected errors somewhere we can see them: Sentry
/// when the build has a `SENTRY_DSN` (see `bootstrap`), the console
/// otherwise.
abstract interface class ErrorReporter {
  void report(Object error, StackTrace? stack, {bool fatal = false});

  /// Attach the logged-in user to future reports (null when logged out).
  void setUser(String? userId);

  /// The page now open, as its route pattern (`/offers/:id`, never the
  /// values), so a report shows how the user got there.
  void routeChanged(String route);
}

class ConsoleErrorReporter implements ErrorReporter {
  const ConsoleErrorReporter();

  @override
  void report(Object error, StackTrace? stack, {bool fatal = false}) {
    debugPrint('${fatal ? 'FATAL' : 'ERROR'}: $error');
    if (stack != null) debugPrint(stack.toString());
  }

  @override
  void setUser(String? userId) {}

  @override
  void routeChanged(String route) {}
}

/// Set by `bootstrap`; defaults to the console in tests.
final errorReporterProvider = Provider<ErrorReporter>(
  (ref) => const ConsoleErrorReporter(),
);
