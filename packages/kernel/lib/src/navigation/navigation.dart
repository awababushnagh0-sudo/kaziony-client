import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

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

/// Web only: clean URLs (`/stores`) instead of hash URLs (`/#/stores`).
/// The web server must then send index.html for every path.
/// Does nothing on phones. Call before runApp (bootstrap does).
void usePathUrls() => usePathUrlStrategy();
