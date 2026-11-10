/// How a service the API depends on is doing.
enum ServiceHealth {
  up,
  down,

  /// Not set up (Redis in development): fine, not a failure.
  off,
}

class ServiceCheck {
  const ServiceCheck({required this.health, this.latencyMs, this.detail});

  final ServiceHealth health;

  /// Round trip; null unless up.
  final double? latencyMs;

  /// Why it's down or off, in the server's words (English).
  final String? detail;
}

/// One running copy of the API.
class SystemInstance {
  const SystemInstance({
    required this.id,
    required this.hostname,
    required this.version,
    required this.nodeVersion,
    required this.startedAt,
    required this.reportedAt,
    required this.uptime,
    required this.memoryBytes,
    required this.heapBytes,
    required this.cpuPercent,
    required this.eventLoopDelayMs,
    required this.connections,
    required this.idleConnections,
    required this.waitingForConnection,
    required this.maxConnections,
    required this.requestsPerMinute,
    required this.current,
  });

  final String id;
  final String hostname;

  /// The release it runs.
  final String version;
  final String nodeVersion;
  final DateTime startedAt;

  /// Its last report: instances report every 10 seconds.
  final DateTime reportedAt;
  final Duration uptime;
  final int memoryBytes;
  final int heapBytes;

  /// Share of one CPU core.
  final double cpuPercent;

  /// How late its timers ran: high means it's too busy.
  final double eventLoopDelayMs;

  /// Its database connections: open, idle, and queries waiting for one.
  final int connections;
  final int idleConnections;
  final int waitingForConnection;
  final int maxConnections;

  /// Over the last 5 minutes.
  final double requestsPerMinute;

  /// The instance that answered.
  final bool current;
}

/// The system at a glance: its services, its instances and the last 5
/// minutes.
class SystemOverview {
  const SystemOverview({
    required this.checkedAt,
    required this.database,
    required this.redis,
    required this.instances,
    required this.requestsPerMinute,
    required this.serverErrors,
    required this.errorRate,
    required this.p95Ms,
    required this.jobs,
    required this.failingJobs,
    required this.runningJobs,
    required this.errorGroups,
  });

  final DateTime checkedAt;
  final ServiceCheck database;
  final ServiceCheck redis;
  final List<SystemInstance> instances;
  final double requestsPerMinute;

  /// Our errors (5xx) in the last 5 minutes.
  final int serverErrors;

  /// Server errors / requests, 0 to 1. Null without requests.
  final double? errorRate;
  final int? p95Ms;
  final int jobs;
  final int failingJobs;
  final int runningJobs;

  /// Kinds of server errors seen in the last 24 hours.
  final int errorGroups;

  /// Something needs looking at.
  bool get needsAttention =>
      database.health == ServiceHealth.down ||
      redis.health == ServiceHealth.down ||
      failingJobs > 0 ||
      serverErrors > 0;
}
