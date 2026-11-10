import 'package:kernel/kernel.dart';

import 'database_stats.dart';
import 'system_error.dart';
import 'system_job.dart';
import 'system_overview.dart';
import 'system_traffic.dart';

/// How the backend is doing. Admins only: the backend refuses editors.
abstract interface class SystemRepository {
  Future<Result<SystemOverview>> overview();

  /// The last [minutes] minutes (5 to 60).
  Future<Result<SystemTraffic>> traffic({required int minutes});

  /// The last 24 hours, most recent first.
  Future<Result<List<SystemError>>> errors();
  Future<Result<List<SystemJob>>> jobs();

  /// Runs [name] now and returns how it went. Fails with a conflict
  /// (`JobRunning`) while it's already running.
  Future<Result<SystemJob>> runJob(String name);
  Future<Result<DatabaseStats>> database();
}

/// Wired to the real implementation in `app/dependencies.dart`.
final systemRepositoryProvider = Provider<SystemRepository>(
  (ref) => throw UnimplementedError('Provided by app/dependencies.dart'),
);
