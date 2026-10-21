import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/auth/presentation/change_password/change_password_screen.dart';
import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import 'redirect.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = RouterRefresh(ref, [sessionProvider, versionGateProvider]);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) => redirectFor(
      session: ref.read(sessionProvider),
      update: ref.read(versionGateProvider),
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (_, _) =>
            const AppScaffold(showAppBar: false, body: AppLoadingView()),
      ),
      GoRoute(
        path: Routes.update,
        builder: (_, _) =>
            const AppScaffold(showAppBar: false, body: AppUpdateRequiredView()),
      ),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: Routes.changePassword,
        builder: (_, _) => const ChangePasswordScreen(),
      ),
      GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
    ],
  );
});
