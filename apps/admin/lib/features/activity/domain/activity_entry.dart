import 'package:kernel/kernel.dart';

import '../../../core/list/list_query.dart';

/// The part of the dashboard a change was made in. Null shows them all.
enum ActivityArea {
  stores,
  users,
  categories,
  serviceAreas,
  settings,
  offers,
  reports,
  jobs,
}

/// One change made in the dashboard, as the audit log recorded it.
class ActivityEntry {
  const ActivityEntry({
    required this.id,
    required this.action,
    required this.actorName,
    required this.targetLabel,
    required this.changes,
    required this.requestId,
    required this.createdAt,
  });

  final String id;

  /// What was done, as the backend names it ("store.update"); see
  /// `activityActionText` for how it reads.
  final String action;

  /// Their name, or their email without one. Null for an account removed
  /// from the database since.
  final String? actorName;

  /// The name of what it was done to, at the time; a store's with its area
  /// ("name · area").
  final String? targetLabel;

  /// What was sent with it, without passwords.
  final List<ActivityChange> changes;

  /// Finds the request in the server's logs.
  final String? requestId;
  final DateTime createdAt;
}

/// A field sent with a change, and its value as text.
class ActivityChange {
  const ActivityChange({required this.field, required this.value});

  /// Dotted for nested fields ("openingHours.sat.0.open").
  final String field;
  final String? value;
}

typedef ActivityQuery = ListQuery<ActivityArea>;
typedef ActivityPage = PageResult<ActivityEntry>;

abstract interface class ActivityRepository {
  /// The latest first.
  Future<Result<ActivityPage>> list(ActivityQuery query);
}

/// Wired to the real implementation in `app/dependencies.dart`.
final activityRepositoryProvider = Provider<ActivityRepository>(
  (ref) => throw UnimplementedError('Provided by app/dependencies.dart'),
);
