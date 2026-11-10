/// How a job's last run went.
enum JobOutcome { succeeded, failed }

/// Work the server runs on a schedule (expiring missed pickups, deleting
/// old tokens), on one instance at a time.
class SystemJob {
  const SystemJob({
    required this.name,
    required this.description,
    required this.schedule,
    required this.nextRunAt,
    required this.running,
    required this.lastStartedAt,
    required this.lastDuration,
    required this.lastOutcome,
    required this.lastResult,
    required this.lastError,
    required this.runs,
    required this.failures,
    required this.backlog,
    required this.backlogLabel,
  });

  /// "expire-claims".
  final String name;

  /// In the server's words (English).
  final String description;

  /// Cron expression; null for a job only run by hand.
  final String? schedule;
  final DateTime? nextRunAt;
  final bool running;
  final DateTime? lastStartedAt;
  final Duration? lastDuration;

  /// Null before its first run.
  final JobOutcome? lastOutcome;

  /// What the last run did, e.g. {expired: 3}.
  final Map<String, Object?> lastResult;
  final String? lastError;
  final int runs;
  final int failures;

  /// Work waiting for the next run (what [backlogLabel] counts).
  final int? backlog;
  final String? backlogLabel;
}
