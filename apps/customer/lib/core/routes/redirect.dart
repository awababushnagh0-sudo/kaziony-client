import 'package:kernel/kernel.dart';

import 'routes.dart';

/// Where the user must be. Null means "stay where you are".
///
/// Browsing needs no account, but it needs a place to show offers around:
/// until the customer has one ([hasLocation]) they go through the welcome
/// pages, which end by asking for it. Nothing sends them back out: those
/// pages move on by themselves.
String? redirectFor({
  required UpdateStatus update,
  required bool hasLocation,
  required String location,
}) {
  final target = switch (location) {
    _ when update == UpdateStatus.updateRequired => Routes.update,
    Routes.update => Routes.home,
    // The terms open from the welcome pages too.
    Routes.terms => null,
    _ when !hasLocation && !location.startsWith(Routes.welcome) =>
      Routes.welcome,
    _ => null,
  };
  return target == location ? null : target;
}
