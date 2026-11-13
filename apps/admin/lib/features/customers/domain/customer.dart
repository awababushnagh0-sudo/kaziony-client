import 'package:kernel/kernel.dart';

import '../../../core/list/list_query.dart';
import '../../bookings/domain/booking_status.dart';

/// Where a customer stands.
enum CustomerStanding {
  /// Booking as usual.
  active,

  /// Booking is paused for missed pickups, until [Customer.pausedUntil].
  paused,

  /// Disabled by our team.
  disabled,

  /// They deleted their account.
  deleted,
}

/// How they sign in.
enum SignInMethod { google, apple }

/// A customer, a row in the customers list.
class Customer {
  const Customer({
    required this.id,
    required this.standing,
    required this.strikes,
    required this.missedPickups,
    required this.bookings,
    required this.pickedUp,
    required this.createdAt,
    this.name,
    this.email,
    this.contactPhone,
    this.pausedUntil,
    this.lastBookedAt,
    this.lastLoginAt,
  });

  final String id;

  /// Null once they deleted their account.
  final String? name;

  /// From Google or Apple.
  final String? email;

  /// Unverified, given on their first booking.
  final String? contactPhone;
  final CustomerStanding standing;
  final DateTime? pausedUntil;

  /// Missed pickups that count toward a pause now.
  final int strikes;

  /// Missed pickups ever, those taken back aside.
  final int missedPickups;
  final int bookings;
  final int pickedUp;
  final DateTime? lastBookedAt;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
}

/// A missed pickup that gave a strike.
class CustomerStrike {
  const CustomerStrike({
    required this.id,
    required this.createdAt,
    required this.counts,
    this.booking,
  });

  final String id;
  final DateTime createdAt;

  /// It counts toward a pause now: within 30 days and after the last pause.
  final bool counts;

  /// The booking missed; null for strikes from before they were linked.
  final StrikeBooking? booking;
}

class StrikeBooking {
  const StrikeBooking({
    required this.code,
    required this.offerTitle,
    required this.storeName,
    required this.storeArea,
  });

  final String code;
  final String offerTitle;
  final String storeName;
  final String storeArea;
}

/// Their bookings by status.
class BookingCounts {
  const BookingCounts({
    required this.waiting,
    required this.outForDelivery,
    required this.pickedUp,
    required this.missed,
    required this.cancelled,
  });

  final int waiting;
  final int outForDelivery;
  final int pickedUp;
  final int missed;
  final int cancelled;
}

/// A customer's page: the row, and where they stand and why.
class CustomerDetails {
  const CustomerDetails({
    required this.customer,
    required this.signsInWith,
    required this.strikesBeforePause,
    required this.strikeHistory,
    required this.bookingCounts,
    required this.openReports,
    required this.following,
    required this.ratings,
    this.lastPauseEndedAt,
    this.deletedAt,
  });

  final Customer customer;
  final List<SignInMethod> signsInWith;

  /// Strikes that count before booking pauses.
  final int strikesBeforePause;

  /// Every strike, the latest first.
  final List<CustomerStrike> strikeHistory;
  final BookingCounts bookingCounts;

  /// When their last pause ended, or ends: a pause soon after is longer.
  final DateTime? lastPauseEndedAt;
  final int openReports;
  final int following;
  final int ratings;
  final DateTime? deletedAt;

  String get id => customer.id;
}

/// One of a customer's bookings.
class CustomerBooking {
  const CustomerBooking({
    required this.id,
    required this.code,
    required this.quantity,
    required this.totalPrice,
    required this.offerTitle,
    required this.storeId,
    required this.storeName,
    required this.storeArea,
    required this.createdAt,
    required this.expiresAt,
    required this.hasStrike,
    this.status,
    this.cancelReason,
    this.redeemedAt,
    this.cancelledAt,
  });

  final String id;
  final String code;

  /// Null for a status this version doesn't know.
  final BookingStatus? status;
  final int quantity;

  /// "8.000"
  final String totalPrice;
  final String offerTitle;
  final String storeId;
  final String storeName;
  final String storeArea;
  final DateTime createdAt;

  /// When it had to be picked up by.
  final DateTime expiresAt;
  final DateTime? redeemedAt;
  final DateTime? cancelledAt;
  final CancelReason? cancelReason;

  /// Missing it gave a strike that still stands.
  final bool hasStrike;
}

/// Null (no filter) shows everyone.
typedef CustomerQuery = ListQuery<CustomerStanding>;
typedef CustomerPage = PageResult<Customer>;

/// Null (no filter) shows every booking.
typedef CustomerBookingQuery = ListQuery<BookingStatus>;
typedef CustomerBookingPage = PageResult<CustomerBooking>;

/// What the dashboard says when a customer's page changed meanwhile.
abstract final class CustomerCodes {
  /// Ending a pause that's over already (409).
  static const notPaused = 'NotPaused';
}

abstract interface class CustomerRepository {
  Future<Result<CustomerPage>> list(CustomerQuery query);
  Future<Result<CustomerDetails>> get(String id);

  /// The latest first.
  Future<Result<CustomerBookingPage>> bookings(
    String id,
    CustomerBookingQuery query,
  );

  /// Ends their pause now. Fails with a [ConflictFailure]
  /// ([CustomerCodes.notPaused]) when it's over already.
  Future<Result<CustomerDetails>> endPause(String id);

  /// Takes back one strike. Fails with a [NotFoundFailure] when it was taken
  /// back already.
  Future<Result<CustomerDetails>> takeBackStrike(String id, String strikeId);

  /// Disabling logs them out and cancels their waiting bookings (admins
  /// only).
  Future<Result<void>> setActive(String id, {required bool active});
}

/// Wired to the real implementation in `app/dependencies.dart`.
final customerRepositoryProvider = Provider<CustomerRepository>(
  (ref) => throw UnimplementedError('Provided by app/dependencies.dart'),
);
