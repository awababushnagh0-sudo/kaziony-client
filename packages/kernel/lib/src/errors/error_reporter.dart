import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sends crashes and unexpected errors somewhere we can see them.
/// Swap [ConsoleErrorReporter] for a Sentry/Crashlytics implementation
/// once there's an account; nothing else changes.
abstract interface class ErrorReporter {
  void report(Object error, StackTrace? stack, {bool fatal = false});

  /// Attach the logged-in user to future reports (null when logged out).
  void setUser(String? userId);
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
}

/// Set by `bootstrap`; defaults to the console in tests.
final errorReporterProvider = Provider<ErrorReporter>(
  (ref) => const ConsoleErrorReporter(),
);
