import 'package:kernel/kernel.dart';

import 'routes.dart';

/// Where the user must be, given the session and the version check.
/// Null means "stay where you are".
///
/// Pages the user can't see yet (still restoring the session, signed out)
/// send them to the splash or login with `?from=<page>`, so a reload or a
/// shared link lands on that page once they're in, as in ERPNext.
String? redirectFor({
  required SessionState session,
  required UpdateStatus update,
  required Uri uri,
}) {
  final location = uri.path;
  final from = _safeFrom(uri.queryParameters['from']);

  /// [target], remembering where the user was heading.
  String keepingFrom(String target) {
    final next = Routes.entry.contains(location) ? from : uri.toString();
    return next == null
        ? target
        : Uri(path: target, queryParameters: {'from': next}).toString();
  }

  final target = switch ((update, session)) {
    (UpdateStatus.updateRequired, _) => Routes.update,
    (_, SessionRestoring()) => keepingFrom(Routes.splash),
    (_, SignedOut()) => keepingFrom(Routes.login),
    (_, SignedIn(:final user)) when user.mustChangePassword => keepingFrom(
      Routes.changePassword,
    ),
    // Signed in: stay on dashboard pages, leave the entry pages.
    (_, SignedIn()) =>
      Routes.entry.contains(location) ? from ?? Routes.home : null,
  };
  return target == uri.toString() ? null : target;
}

/// Only our own dashboard pages, never an entry page or another site.
String? _safeFrom(String? from) {
  if (from == null || !from.startsWith('/') || from.startsWith('//')) {
    return null;
  }
  return Routes.entry.contains(Uri.parse(from).path) ? null : from;
}
