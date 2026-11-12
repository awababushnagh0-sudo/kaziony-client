import 'package:kernel/kernel.dart';

/// Limited offers have pieces, each held for a while once claimed;
/// unlimited ones give every customer a code until they end.
enum OfferType { limited, unlimited }

/// The store's switch on the offer, and the list's filter.
enum OfferStatus { active, paused, ended, removed }

/// What customers see right now.
enum OfferState { live, scheduled, soldOut, paused, ended, removed }

class ClaimCounts {
  const ClaimCounts({
    required this.reserved,
    required this.outForDelivery,
    required this.redeemed,
    required this.expired,
    required this.cancelled,
  });

  /// Waiting for the customer to come.
  final int reserved;

  /// With the store's drivers.
  final int outForDelivery;

  /// Picked up at the counter, or delivered.
  final int redeemed;
  final int expired;
  final int cancelled;

  /// Taken and not handed over yet: coming to the counter or being brought.
  int get onTheWay => reserved + outForDelivery;
}

class Offer {
  const Offer({
    required this.id,
    required this.productId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.thumbUrl,
    required this.originalPrice,
    required this.offerPrice,
    required this.discountPercent,
    required this.type,
    required this.status,
    required this.state,
    required this.totalQuantity,
    required this.remainingQuantity,
    required this.maxPerUser,
    required this.claimWindowMinutes,
    required this.startsAt,
    required this.endsAt,
    required this.viewCount,
    required this.claims,
  });

  final String id;
  final String productId;
  final String title;
  final String? description;

  /// The photo at full size, for the offer's page; [thumbUrl] for lists.
  final String? imageUrl;
  final String? thumbUrl;

  /// LD with 3 decimals, shown with `formatPrice`.
  final String originalPrice;
  final String offerPrice;

  /// 50 for half price.
  final int discountPercent;
  final OfferType type;

  /// Null for a status or state added after this version of the app.
  final OfferStatus? status;
  final OfferState? state;

  /// Null for unlimited offers.
  final int? totalQuantity;
  final int? remainingQuantity;

  /// Pieces one customer can take in all; null for no limit.
  final int? maxPerUser;

  /// How long a claim is held for the customer (limited offers): our
  /// team's setting, the same for every store, not the offer's own.
  final int claimWindowMinutes;
  final DateTime startsAt;
  final DateTime endsAt;
  final int viewCount;
  final ClaimCounts claims;

  /// A limited offer with a fifth of its pieces or fewer left.
  bool get isRunningOut {
    final total = totalQuantity;
    final left = remainingQuantity;
    return total != null && left != null && left * 5 <= total;
  }

  bool get canPause => status == OfferStatus.active;
  bool get canResume => status == OfferStatus.paused;

  /// Ended and removed offers stay as they are.
  bool get canChange =>
      status == OfferStatus.active || status == OfferStatus.paused;
}

/// What the owner chooses to post an offer from a product.
class NewOffer {
  const NewOffer({
    required this.productId,
    required this.offerPrice,
    required this.type,
    required this.totalQuantity,
    required this.maxPerUser,
    required this.endsAt,
  });

  final String productId;

  /// As the backend takes it: `parsePrice` of what was typed.
  final String offerPrice;
  final OfferType type;

  /// Limited offers only.
  final int? totalQuantity;

  /// Null for no limit.
  final int? maxPerUser;
  final DateTime endsAt;
}

/// What can change once an offer is posted.
class OfferChanges {
  const OfferChanges({
    required this.title,
    required this.description,
    required this.endsAt,
  });

  final String title;
  final String? description;
  final DateTime endsAt;
}

/// Everyone in the store can see offers; only owners post and change them.
abstract interface class OfferRepository {
  /// [ended] picks one of the Offers tab's lists: false the current offers
  /// (running, then starting later, then paused, in that order), true the
  /// finished ones (the latest first); null every offer, the newest first.
  Future<Result<PageResult<Offer>>> list(
    String storeId, {
    required int page,
    required int pageSize,
    OfferStatus? status,
    bool? ended,
  });

  Future<Result<Offer>> get(String storeId, String offerId);

  Future<Result<Offer>> create(String storeId, NewOffer offer);

  Future<Result<Offer>> update(
    String storeId,
    String offerId,
    OfferChanges changes,
  );

  /// Hides it from customers until resumed.
  Future<Result<Offer>> pause(String storeId, String offerId);

  Future<Result<Offer>> resume(String storeId, String offerId);

  /// For good. Reservations already made can still be picked up.
  Future<Result<Offer>> end(String storeId, String offerId);
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final offerRepositoryProvider = Provider<OfferRepository>(
  (ref) =>
      throw UnimplementedError('Provided by core/providers/dependencies.dart'),
);
