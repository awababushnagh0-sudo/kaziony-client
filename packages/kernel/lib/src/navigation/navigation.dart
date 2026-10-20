import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

// go_router does the routing; apps get it only through kernel.
export 'package:go_router/go_router.dart'
    show
        GoRoute,
        GoRouter,
        GoRouterHelper,
        GoRouterState,
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
