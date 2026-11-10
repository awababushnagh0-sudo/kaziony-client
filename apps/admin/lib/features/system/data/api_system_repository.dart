import 'package:kernel/kernel.dart';
import 'package:offers_api/admin.dart';

import '../domain/database_stats.dart';
import '../domain/system_error.dart';
import '../domain/system_job.dart';
import '../domain/system_overview.dart';
import '../domain/system_repository.dart';
import '../domain/system_traffic.dart';

class ApiSystemRepository implements SystemRepository {
  ApiSystemRepository(this._api);

  final Api _api;
  late final _system = _api.client(AdminSystemClient.new);

  @override
  Future<Result<SystemOverview>> overview() async {
    final result = await _api.guard(_system.overview);
    return result.map(
      (dto) => SystemOverview(
        checkedAt: dto.checkedAt,
        database: _check(dto.checks.database),
        redis: _check(dto.checks.redis),
        instances: dto.instances.map(_instance).toList(),
        requestsPerMinute: dto.traffic.requestsPerMinute.toDouble(),
        serverErrors: dto.traffic.serverErrors.toInt(),
        errorRate: dto.traffic.errorRate?.toDouble(),
        p95Ms: dto.traffic.p95Ms?.toInt(),
        jobs: dto.jobs.total.toInt(),
        failingJobs: dto.jobs.failing.toInt(),
        runningJobs: dto.jobs.running.toInt(),
        errorGroups: dto.errorGroups.toInt(),
      ),
    );
  }

  @override
  Future<Result<SystemTraffic>> traffic({required int minutes}) async {
    final result = await _api.guard(() => _system.traffic(minutes: minutes));
    return result.map(
      (dto) => SystemTraffic(
        minutes: [
          for (final point in dto.series)
            TrafficMinute(
              at: point.at,
              requests: point.requests.toInt(),
              serverErrors: point.serverErrors.toInt(),
              p95Ms: point.p95Ms?.toInt(),
            ),
        ],
        routes: [
          for (final route in dto.routes)
            RouteTraffic(
              method: route.method,
              route: route.route,
              requests: route.requests.toInt(),
              clientErrors: route.clientErrors.toInt(),
              serverErrors: route.serverErrors.toInt(),
              p50Ms: route.p50Ms?.toInt(),
              p95Ms: route.p95Ms?.toInt(),
              p99Ms: route.p99Ms?.toInt(),
            ),
        ],
      ),
    );
  }

  @override
  Future<Result<List<SystemError>>> errors() async {
    final result = await _api.guard(_system.errors);
    return result.map(
      (dto) => [
        for (final error in dto.items)
          SystemError(
            name: error.name,
            message: error.message,
            method: error.method,
            route: error.route,
            statusCode: error.statusCode.toInt(),
            count: error.count.toInt(),
            firstSeenAt: error.firstSeenAt,
            lastSeenAt: error.lastSeenAt,
            lastRequestId: error.lastRequestId,
            stack: error.stack,
            instances: error.instanceCount.toInt(),
          ),
      ],
    );
  }

  @override
  Future<Result<List<SystemJob>>> jobs() async {
    final result = await _api.guard(_system.jobs);
    return result.map((dto) => dto.items.map(_job).toList());
  }

  @override
  Future<Result<SystemJob>> runJob(String name) async {
    final result = await _api.guard(() => _system.runJob(name: name));
    return result.map(_job);
  }

  @override
  Future<Result<DatabaseStats>> database() async {
    final result = await _api.guard(_system.databaseStats);
    return result.map(
      (dto) => DatabaseStats(
        version: dto.version,
        sizeBytes: dto.sizeBytes.toInt(),
        connections: dto.connections.total.toInt(),
        activeConnections: dto.connections.active.toInt(),
        idleInTransaction: dto.connections.idleInTransaction.toInt(),
        waitingOnLocks: dto.connections.waitingOnLocks.toInt(),
        maxConnections: dto.connections.max.toInt(),
        cacheHitRatio: dto.cacheHitRatio?.toDouble(),
        statementsAvailable: dto.statementsAvailable,
        slowestQueries: [
          for (final query in dto.topQueries)
            DatabaseQuery(
              text: query.query,
              calls: query.calls.toInt(),
              totalMs: query.totalMs.toDouble(),
              meanMs: query.meanMs.toDouble(),
            ),
        ],
        running: [
          for (final activity in dto.running)
            RunningQuery(
              text: activity.query,
              duration: Duration(milliseconds: activity.durationMs.round()),
              waitingFor: activity.waitEvent,
            ),
        ],
        tables: [
          for (final table in dto.tables)
            DatabaseTable(
              name: table.name,
              rows: table.rows.toInt(),
              bytes: table.totalBytes.toInt(),
              deadRows: table.deadRows.toInt(),
            ),
        ],
      ),
    );
  }

  ServiceCheck _check(SystemCheckDto dto) => ServiceCheck(
    health: switch (dto.status) {
      ServiceStatus.up => ServiceHealth.up,
      ServiceStatus.off => ServiceHealth.off,
      // Unknown to this version of the dashboard: worth a look.
      ServiceStatus.down || ServiceStatus.$unknown => ServiceHealth.down,
    },
    latencyMs: dto.latencyMs?.toDouble(),
    detail: dto.detail,
  );

  SystemInstance _instance(SystemInstanceDto dto) => SystemInstance(
    id: dto.id,
    hostname: dto.hostname,
    version: dto.version,
    nodeVersion: dto.nodeVersion,
    startedAt: dto.startedAt,
    reportedAt: dto.reportedAt,
    uptime: Duration(seconds: dto.uptimeSeconds.toInt()),
    memoryBytes: dto.rssBytes.toInt(),
    heapBytes: dto.heapUsedBytes.toInt(),
    cpuPercent: dto.cpuPercent.toDouble(),
    eventLoopDelayMs: dto.eventLoopDelayMs.toDouble(),
    connections: dto.pool.total.toInt(),
    idleConnections: dto.pool.idle.toInt(),
    waitingForConnection: dto.pool.waiting.toInt(),
    maxConnections: dto.pool.max.toInt(),
    requestsPerMinute: dto.requestsPerMinute.toDouble(),
    current: dto.current,
  );

  SystemJob _job(SystemJobDto dto) => SystemJob(
    name: dto.name,
    description: dto.description,
    schedule: dto.schedule,
    nextRunAt: dto.nextRunAt,
    running: dto.running,
    lastStartedAt: dto.lastStartedAt,
    lastDuration: switch (dto.lastDurationMs) {
      final ms? => Duration(milliseconds: ms.toInt()),
      null => null,
    },
    lastOutcome: switch (dto.lastStatus) {
      JobRunStatus.succeeded => JobOutcome.succeeded,
      JobRunStatus.failed => JobOutcome.failed,
      JobRunStatus.$unknown || null => null,
    },
    lastResult: switch (dto.lastResult) {
      final Map<String, Object?> result => result,
      _ => const {},
    },
    lastError: dto.lastError,
    runs: dto.runCount.toInt(),
    failures: dto.failureCount.toInt(),
    backlog: dto.backlog?.toInt(),
    backlogLabel: dto.backlogLabel,
  );
}
