import 'package:kernel/kernel.dart';

import '../../offers/domain/offer.dart';

enum BookingStatus {
  /// Waiting to be picked up.
  reserved,

  /// With the store's driver, on its way: no time limit, until the store
  /// says it was delivered.
  outForDelivery,

  /// Picked up, or delivered.
  pickedUp,

  /// Not picked up in time.
  expired,
  cancelled,
}

/// Who cancelled a booking. Only the customer's own cancels count against
/// them.
enum CancelReason {
  /// The customer did.
  customer,

  /// Our team took the offer down.
  offerRemoved,

  /// Our team turned the store off.
  storeOff,

  /// The store's delivery didn't happen: the customer called it off, or
  /// wasn't there. Between them and the store.
  notDelivered,

  /// Not the customer, for a reason added after this version of the app.
  other,
}

/// A reservation of an offer: the code to show at the counter.
class Booking {
  const Booking({
    required this.id,
    required this.code,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.expiresAt,
    required this.createdAt,
    required this.offerId,
    required this.offerTitle,
    required this.offerPrice,
    required this.storeName,
    required this.location,
    required this.canCancel,
    required this.limited,
    this.cancelEndsBooking = false,
    this.canRate = false,
    this.thumbUrl,
    this.storeLogoUrl,
    this.pickedUpAt,
    this.myRating,
    this.cancelReason,
    this.deliveryPhone,
    this.sentForDeliveryAt,
  });

  final String id;

  /// 8 characters; the QR code holds it as it is.
  final String code;
  final int quantity;

  /// LD with 3 decimals, to pay at the counter.
  final String totalPrice;
  final BookingStatus status;

  /// Until when the pieces are held.
  final DateTime expiresAt;
  final DateTime createdAt;
  final DateTime? pickedUpAt;
  final String offerId;
  final String offerTitle;
  final String offerPrice;
  final String? thumbUrl;
  final String storeName;
  final String? storeLogoUrl;

  /// Where to pick it up: the store's place.
  final StoreLocation location;
  final bool canCancel;

  /// Cancelled once already: cancelling again closes the offer to the
  /// customer, which the app says before.
  final bool cancelEndsBooking;

  /// Held for a short time (a counted offer); else good until the offer
  /// ends.
  final bool limited;

  /// Picked up, and the store not rated since: the customer can rate it,
  /// and the stars replace the ones given after an earlier pickup.
  final bool canRate;

  /// The stars (1 to 5) the customer gave the store: one rating per store,
  /// from this pickup or another. Null before they rate it.
  final int? myRating;

  /// Who cancelled it, once cancelled.
  final CancelReason? cancelReason;

  /// Set when the store brings bookings with its own drivers: the number
  /// to call for that. Delivery and any fee are between the customer and
  /// the store.
  final String? deliveryPhone;

  /// When the store's driver took it.
  final DateTime? sentForDeliveryAt;

  bool get isOutForDelivery => status == BookingStatus.outForDelivery;

  /// Not over yet, as the server last said: waiting, or being brought.
  bool get underWay => status == BookingStatus.reserved || isOutForDelivery;

  /// Cancelled, but not by the customer: it doesn't count against them,
  /// and the app says why.
  bool get cancelledForCustomer =>
      status == BookingStatus.cancelled &&
      cancelReason != null &&
      cancelReason != CancelReason.customer;

  /// Still to come: reserved and not past its time, or on its way with the
  /// store's driver, which has no time limit.
  bool isActiveAt(DateTime now) =>
      isOutForDelivery ||
      (status == BookingStatus.reserved && expiresAt.isAfter(now));
}

/// Where the customer stands with booking: missed pickups that count, a
/// pause they led to, and the reservations held.
class BookingStanding {
  const BookingStanding({
    required this.strikes,
    required this.strikesBeforePause,
    required this.nextPauseDays,
    required this.activeReservations,
    required this.maxActiveReservations,
    this.strikeFadesAt,
    this.pausedUntil,
  });

  /// Missed pickups that count now: those of the last few weeks, since
  /// the last pause.
  final int strikes;

  /// Missed pickups that pause booking.
  final int strikesBeforePause;

  /// When the oldest that counts stops counting; null without one.
  final DateTime? strikeFadesAt;

  /// Booking is paused until then; null when it isn't.
  final DateTime? pausedUntil;

  /// How long the next pause would be.
  final int nextPauseDays;

  /// Reservations of counted offers held now, and the most at once.
  final int activeReservations;
  final int maxActiveReservations;

  bool pausedAt(DateTime now) => pausedUntil?.isAfter(now) ?? false;

  /// More missed pickups before booking pauses.
  int get strikesLeft =>
      (strikesBeforePause - strikes).clamp(0, strikesBeforePause);

  /// Holding the most at once: a counted offer can't be booked until one
  /// is picked up or cancelled.
  bool get full => activeReservations >= maxActiveReservations;
}

abstract interface class BookingsRepository {
  /// Reserves [quantity] pieces of an offer.
  Future<Result<Booking>> reserve(String offerId, {required int quantity});

  /// Newest first; [rated], only the pickups the customer rated, the
  /// latest rating first: one per store, the pickup the rating is from.
  Future<Result<PageResult<Booking>>> list({
    required int page,
    required int pageSize,
    bool rated = false,
  });

  Future<Result<Booking>> get(String bookingId);

  Future<Result<Booking>> cancel(String bookingId);

  /// Rates the store [stars] from 1 to 5, once the booking is picked up:
  /// one rating per store, which a later pickup's replaces.
  Future<Result<Booking>> rate(String bookingId, int stars);

  /// Where the signed-in customer stands with booking.
  Future<Result<BookingStanding>> standing();
}

final bookingsRepositoryProvider = Provider<BookingsRepository>(
  (ref) => throw UnimplementedError('Overridden in dependencies.dart'),
);
