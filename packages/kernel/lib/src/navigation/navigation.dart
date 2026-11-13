import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import '../errors/error_reporter.dart';

// go_router does the routing; apps get it only through kernel.
export 'package:go_router/go_router.dart'
    show
        GoRoute,
        GoRouter,
        GoRouterHelper,
        GoRouterState,
        NoTransitionPage,
        RouteBase,
        ShellRoute,
        StatefulNavigationShell,
        StatefulShellBranch,
        StatefulShellRoute;

/// Makes the router re-run its redirects whenever one of [sources] changes
/// (e.g. the session or the update check). Pass it as `refreshListenable`.
class RouterRefresh extends ChangeNotifier {
  RouterRefresh(Ref ref, List<ProviderListenable<Object?>> sources) {
    for (final source in sources) {
      ref.listen(source, (_, _) => notifyListeners());
    }
  }
}

/// Tells the [ErrorReporter] each page the user opens (its pattern, like
/// `/offers/:id`), so an error report shows how they got there. Call once,
/// where the app makes its router.
void reportRoutes(Ref ref, GoRouter router) {
  final reporter = ref.read(errorReporterProvider);
  final delegate = router.routerDelegate;
  String? last;
  void changed() {
    final route = delegate.currentConfiguration.fullPath;
    if (route == last) return;
    last = route;
    reporter.routeChanged(route);
  }

  delegate.addListener(changed);
  ref.onDispose(() => delegate.removeListener(changed));
}

/// Web only: clean URLs (`/stores`) instead of hash URLs (`/#/stores`).
/// The web server must then send index.html for every path.
/// Does nothing on phones. Call before runApp (bootstrap does).
void usePathUrls() => usePathUrlStrategy();
