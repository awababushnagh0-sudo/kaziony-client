import 'package:kernel/kernel.dart';

import '../../features/activity/data/api_activity_repository.dart';
import '../../features/activity/domain/activity_entry.dart';
import '../../features/auth/data/session_auth_repository.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/dashboard/data/api_dashboard_repository.dart';
import '../../features/dashboard/domain/dashboard_stats.dart';
import '../../features/platform/data/api_platform_settings_repository.dart';
import '../../features/platform/data/api_service_area_repository.dart';
import '../../features/platform/domain/platform_settings.dart';
import '../../features/platform/domain/service_area.dart';
import '../../features/reports/data/api_report_repository.dart';
import '../../features/reports/domain/customer_report.dart';
import '../../features/search/data/api_search_term_repository.dart';
import '../../features/search/domain/search_term.dart';
import '../../features/stores/data/api_store_repository.dart';
import '../../features/stores/domain/store.dart';
import '../../features/system/data/api_system_repository.dart';
import '../../features/system/domain/system_repository.dart';
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
  platformSettingsRepositoryProvider.overrideWith(
    (ref) => ApiPlatformSettingsRepository(ref.watch(apiProvider)),
  ),
  serviceAreaRepositoryProvider.overrideWith(
    (ref) => ApiServiceAreaRepository(ref.watch(apiProvider)),
  ),
  searchTermRepositoryProvider.overrideWith(
    (ref) => ApiSearchTermRepository(ref.watch(apiProvider)),
  ),
  systemRepositoryProvider.overrideWith(
    (ref) => ApiSystemRepository(ref.watch(apiProvider)),
  ),
  activityRepositoryProvider.overrideWith(
    (ref) => ApiActivityRepository(ref.watch(apiProvider)),
  ),
  reportRepositoryProvider.overrideWith(
    (ref) => ApiReportRepository(ref.watch(apiProvider)),
  ),
];
