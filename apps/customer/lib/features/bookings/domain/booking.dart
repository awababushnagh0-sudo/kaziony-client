import 'package:kernel/kernel.dart';

import '../../offers/domain/offer.dart';

enum BookingStatus {
  /// Waiting to be picked up.
  reserved,
  pickedUp,

  /// Not picked up in time.
  expired,
  cancelled,
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
    required this.branches,
    required this.canCancel,
    required this.limited,
    this.canRate = false,
    this.thumbUrl,
    this.storeLogoUrl,
    this.pickedUpAt,
    this.myRating,
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

  /// Where it can be picked up, closest first.
  final List<Branch> branches;
  final bool canCancel;

  /// Held for a short time (a counted offer); else good until the offer
  /// ends.
  final bool limited;

  /// Picked up and not rated yet: the customer can rate the store, once.
  final bool canRate;

  /// The stars (1 to 5) the customer gave the store for this pickup.
  final int? myRating;

  /// Still to be picked up: reserved and not past its time.
  bool isActiveAt(DateTime now) =>
      status == BookingStatus.reserved && expiresAt.isAfter(now);
}

abstract interface class BookingsRepository {
  /// Reserves [quantity] pieces of an offer.
  Future<Result<Booking>> reserve(String offerId, {required int quantity});

  /// Newest first.
  /// Newest first; [rated], only the pickups the customer rated, the
  /// latest rating first.
  Future<Result<PageResult<Booking>>> list({
    required int page,
    required int pageSize,
    bool rated = false,
  });

  Future<Result<Booking>> get(String bookingId);

  Future<Result<Booking>> cancel(String bookingId);

  /// Rates the store [stars] from 1 to 5, once the booking is picked up.
  Future<Result<Booking>> rate(String bookingId, int stars);
}

final bookingsRepositoryProvider = Provider<BookingsRepository>(
  (ref) => throw UnimplementedError('Overridden in dependencies.dart'),
);
