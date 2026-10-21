import 'package:kernel/kernel.dart';

import 'routes.dart';

/// Where the user must be, given the session and the version check.
/// Null means "stay where you are".
String? redirectFor({
  required SessionState session,
  required UpdateStatus update,
  required String location,
}) {
  final target = switch ((update, session)) {
    (UpdateStatus.updateRequired, _) => Routes.update,
    (_, SessionRestoring()) => Routes.splash,
    (_, SignedOut()) => Routes.login,
    (_, SignedIn(:final user)) when user.mustChangePassword =>
      Routes.changePassword,
    // Signed in: stay on app screens, leave the entry screens.
    (_, SignedIn()) =>
      const {
            Routes.splash,
            Routes.update,
            Routes.login,
            Routes.changePassword,
          }.contains(location)
          ? Routes.home
          : null,
  };
  return target == location ? null : target;
}
