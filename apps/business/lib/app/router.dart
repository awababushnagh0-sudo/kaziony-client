import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../features/auth/presentation/change_password/change_password_screen.dart';
import '../features/auth/presentation/login/login_screen.dart';
import '../features/home/presentation/home_screen.dart';

abstract final class Routes {
  static const splash = '/';
  static const update = '/update';
  static const login = '/login';
  static const changePassword = '/change-password';
  static const home = '/home';
}

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
