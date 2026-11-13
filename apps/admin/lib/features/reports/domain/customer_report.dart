import 'package:kernel/kernel.dart';

import '../../../core/list/list_query.dart';

/// What a customer said went wrong with a booking.
enum ReportReason { storeClosed, notGiven, priceDifferent, quality, other }

/// Whether our team has answered a report yet.
enum ReportState { open, resolved }

/// Where the booking a report is about stands.
enum ReportedBookingStatus {
  /// Waiting to be picked up.
  waiting,
  outForDelivery,
  pickedUp,

  /// Not picked up in time: it gave the customer a strike.
  missed,
  cancelled,
}

/// A customer's report of a problem with one of their bookings, with the
/// booking and the customer as they are now, and what our team made of it.
class CustomerReport {
  const CustomerReport({
    required this.id,
    required this.reason,
    required this.note,
    required this.state,
    required this.createdAt,
    required this.booking,
    required this.store,
    required this.customer,
    required this.hasStrike,
    required this.strikeRemoved,
    required this.pauseEnded,
    required this.resolution,
    required this.resolvedAt,
    required this.resolverName,
  });

  final String id;
  final ReportReason reason;

  /// In the customer's words; always there for [ReportReason.other].
  final String? note;
  final ReportState state;
  final DateTime createdAt;
  final ReportedBooking booking;
  final ReportedStore store;
  final ReportCustomer customer;

  /// The booking gave a strike that still stands, so it can be taken back.
  final bool hasStrike;
  final bool strikeRemoved;
  final bool pauseEnded;

  /// What our team found.
  final String? resolution;
  final DateTime? resolvedAt;

  /// Their name; null for an account removed since.
  final String? resolverName;

  bool get open => state == ReportState.open;
}

class ReportedBooking {
  const ReportedBooking({
    required this.id,
    required this.code,
    required this.status,
    required this.quantity,
    required this.totalPrice,
    required this.offerTitle,
    required this.createdAt,
    required this.expiresAt,
  });

  final String id;
  final String code;

  /// Null for a status this version doesn't know.
  final ReportedBookingStatus? status;
  final int quantity;

  /// "13.500"
  final String totalPrice;
  final String offerTitle;
  final DateTime createdAt;

  /// When it had to be picked up by.
  final DateTime expiresAt;
}

class ReportedStore {
  const ReportedStore({
    required this.id,
    required this.name,
    required this.area,
  });

  final String id;
  final String name;
  final String area;
}

class ReportCustomer {
  const ReportCustomer({
    required this.id,
    required this.name,
    required this.email,
    required this.contactPhone,
    required this.missedPickups,
    required this.pausedUntil,
  });

  final String id;

  /// Null once they deleted their account.
  final String? name;
  final String? email;
  final String? contactPhone;

  /// Missed pickups in all.
  final int missedPickups;

  /// Booking is paused until then; null when it isn't now.
  final DateTime? pausedUntil;
}

/// What our team decided about a report.
class ReportResolution {
  const ReportResolution({
    this.removeStrike = false,
    this.endPause = false,
    this.note,
  });

  final bool removeStrike;
  final bool endPause;

  /// What our team found, for the team.
  final String? note;
}

/// The error codes resolving a report can fail with.
abstract final class ReportCodes {
  /// Someone on the team resolved it first.
  static const alreadyResolved = 'AlreadyResolved';

  /// The booking's strike was taken back already, or it gave none.
  static const noStrike = 'NoStrike';

  /// The customer's pause ended already.
  static const notPaused = 'NotPaused';
}

typedef ReportQuery = ListQuery<ReportState>;
typedef ReportPage = PageResult<CustomerReport>;

abstract interface class ReportRepository {
  /// Open ones first, oldest first, to answer in turn; then resolved ones,
  /// the latest resolved first.
  Future<Result<ReportPage>> list(ReportQuery query);

  /// Closes the report, once. Fails with a [ConflictFailure] of one of
  /// the [ReportCodes]; then nothing changes.
  Future<Result<CustomerReport>> resolve(
    String id,
    ReportResolution resolution,
  );
}

/// Wired to the real implementation in `app/dependencies.dart`.
final reportRepositoryProvider = Provider<ReportRepository>(
  (ref) => throw UnimplementedError('Provided by app/dependencies.dart'),
);
