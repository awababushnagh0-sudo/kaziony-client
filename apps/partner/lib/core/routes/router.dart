import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/auth/presentation/change_password/change_password_screen.dart';
import '../../features/auth/presentation/login/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/products/presentation/product_form_screen.dart';
import '../../features/products/presentation/products_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/store/domain/current_store.dart';
import '../../features/store/presentation/branches_screen.dart';
import '../../features/store/presentation/choose_store_screen.dart';
import '../../features/store/presentation/edit_store_info_screen.dart';
import '../../features/store/presentation/no_store_screen.dart';
import '../../features/store/presentation/store_info_screen.dart';
import '../../features/store/presentation/team_screen.dart';
import '../widgets/partner_shell.dart';
import 'redirect.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = RouterRefresh(ref, [
    sessionProvider,
    chosenStoreProvider,
    versionGateProvider,
  ]);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) => redirectFor(
      session: ref.read(sessionProvider),
      chosenStore: ref.read(chosenStoreProvider),
      update: ref.read(versionGateProvider),
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (_, _) =>
            const SScaffold(showAppBar: false, body: SLoadingView()),
      ),
      GoRoute(
        path: Routes.update,
        builder: (_, _) =>
            const SScaffold(showAppBar: false, body: SUpdateRequiredView()),
      ),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: Routes.changePassword,
        builder: (_, _) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: Routes.chooseStore,
        builder: (_, _) => const ChooseStoreScreen(),
      ),
      GoRoute(path: Routes.noStore, builder: (_, _) => const NoStoreScreen()),
      // Opened from Profile, over the tabs.
      GoRoute(
        path: Routes.storeInfo,
        builder: (_, _) => const StoreInfoScreen(),
      ),
      GoRoute(
        path: Routes.editStoreInfo,
        builder: (_, _) => const EditStoreInfoScreen(),
      ),
      GoRoute(path: Routes.branches, builder: (_, _) => const BranchesScreen()),
      GoRoute(path: Routes.team, builder: (_, _) => const TeamScreen()),
      GoRoute(
        path: Routes.password,
        builder: (_, _) => const ChangePasswordScreen(temporary: false),
      ),
      // Before the product's page, so "new" isn't taken for an id.
      GoRoute(
        path: Routes.newProduct,
        builder: (_, _) => const ProductFormScreen(),
      ),
      GoRoute(
        path: Routes.product(':productId'),
        builder: (_, state) =>
            ProductFormScreen(productId: state.pathParameters['productId']),
      ),
      // One branch per [PartnerTab], in its order.
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => PartnerShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.products,
                builder: (_, _) => const ProductsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
