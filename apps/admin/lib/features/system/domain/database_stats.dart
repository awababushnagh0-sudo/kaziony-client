/// A query by the time it takes the database, all its runs together.
class DatabaseQuery {
  const DatabaseQuery({
    required this.text,
    required this.calls,
    required this.totalMs,
    required this.meanMs,
  });

  /// With $1, $2 where the values go: never customers' data.
  final String text;
  final int calls;
  final double totalMs;
  final double meanMs;
}

/// A query running for over a second right now.
class RunningQuery {
  const RunningQuery({
    required this.text,
    required this.duration,
    required this.waitingFor,
  });

  final String text;
  final Duration duration;

  /// What it waits for ("Lock: transactionid"), if anything.
  final String? waitingFor;
}

class DatabaseTable {
  const DatabaseTable({
    required this.name,
    required this.rows,
    required this.bytes,
    required this.deadRows,
  });

  final String name;

  /// Estimated.
  final int rows;

  /// With its indexes.
  final int bytes;

  /// Removed rows waiting for vacuum.
  final int deadRows;
}

class DatabaseStats {
  const DatabaseStats({
    required this.version,
    required this.sizeBytes,
    required this.connections,
    required this.activeConnections,
    required this.idleInTransaction,
    required this.waitingOnLocks,
    required this.maxConnections,
    required this.cacheHitRatio,
    required this.statementsAvailable,
    required this.slowestQueries,
    required this.running,
    required this.tables,
  });

  final String version;
  final int sizeBytes;
  final int connections;
  final int activeConnections;

  /// Holding a transaction open while doing nothing: should stay near 0.
  final int idleInTransaction;
  final int waitingOnLocks;
  final int maxConnections;

  /// Reads served from memory, 0 to 1.
  final double? cacheHitRatio;

  /// Whether the database counts its queries (pg_stat_statements).
  final bool statementsAvailable;

  /// Most total time first.
  final List<DatabaseQuery> slowestQueries;
  final List<RunningQuery> running;

  /// Biggest first.
  final List<DatabaseTable> tables;
}
