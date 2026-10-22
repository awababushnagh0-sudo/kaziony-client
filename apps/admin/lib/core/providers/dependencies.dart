import 'package:kernel/kernel.dart';

import '../../features/auth/data/session_auth_repository.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/dashboard/data/api_dashboard_repository.dart';
import '../../features/dashboard/domain/dashboard_stats.dart';
import '../../features/stores/data/api_store_repository.dart';
import '../../features/stores/domain/store.dart';
import '../../features/users/data/api_dashboard_user_repository.dart';
import '../../features/users/domain/dashboard_user.dart';

/// Composition root: connects each feature's domain interfaces to their
/// data implementations. Screens and view models only know the interfaces;
/// tests replace these with fakes.
final List<Override> dependencies = [
  authRepositoryProvider.overrideWith(SessionAuthRepository.new),
  dashboardRepositoryProvider.overrideWith(
    (ref) => ApiDashboardRepository(ref.watch(apiProvider)),
  ),
  storeRepositoryProvider.overrideWith(
    (ref) => ApiStoreRepository(ref.watch(apiProvider)),
  ),
  dashboardUserRepositoryProvider.overrideWith(
    (ref) => ApiDashboardUserRepository(ref.watch(apiProvider)),
  ),
];
