import 'package:kernel/kernel.dart';

enum ClaimStatus {
  /// Waiting for the customer to come.
  reserved,

  /// Picked up at the counter.
  redeemed,

  /// Not picked up in time.
  expired,
  cancelled,
}

/// Why a code can't be picked up at this counter.
enum ClaimProblem { alreadyRedeemed, cancelled, expired, otherBranch, other }

/// The 8 characters customers show as a QR code, or read out when it won't
/// scan.
abstract final class ClaimCode {
  static const length = 8;

  /// Capitals and digits without look-alikes (no 0, O, 1, I or L), as the
  /// backend makes them.
  static final _valid = RegExp('^[A-HJKMNP-Z2-9]{$length}\$');

  /// The code in [raw] (scanned or typed, with any case, spaces or dashes),
  /// or null when it isn't one.
  static String? read(String raw) {
    final code = raw.toUpperCase().replaceAll(RegExp(r'[\s-]'), '');
    return _valid.hasMatch(code) ? code : null;
  }
}

/// The offer a claim is for, as the counter needs it.
class ClaimOffer {
  const ClaimOffer({
    required this.id,
    required this.title,
    required this.offerPrice,
    required this.originalPrice,
    required this.thumbUrl,
  });

  final String id;
  final String title;

  /// What the customer pays, LD with 3 decimals.
  final String offerPrice;
  final String originalPrice;
  final String? thumbUrl;
}

/// A customer's reservation, looked up by its code at the counter.
class Claim {
  const Claim({
    required this.id,
    required this.code,
    required this.status,
    required this.customerName,
    required this.offer,
    required this.expiresAt,
    required this.redeemedAt,
    required this.canRedeem,
  });

  final String id;
  final String code;

  /// Null for a status added after this version of the app.
  final ClaimStatus? status;
  final String? customerName;
  final ClaimOffer offer;

  /// Until when it's held for the customer.
  final DateTime expiresAt;
  final DateTime? redeemedAt;

  /// The server's answer: it can be picked up here, right now.
  final bool canRedeem;

  /// Why it can't be picked up, in terms the counter can show; null when
  /// it can.
  ClaimProblem? get problem {
    if (canRedeem) return null;
    return switch (status) {
      ClaimStatus.redeemed => ClaimProblem.alreadyRedeemed,
      ClaimStatus.cancelled => ClaimProblem.cancelled,
      ClaimStatus.expired => ClaimProblem.expired,
      // Still reserved: either its time ran out a moment ago, or the offer
      // isn't valid at this staff member's branch.
      ClaimStatus.reserved when !expiresAt.isAfter(DateTime.now()) =>
        ClaimProblem.expired,
      ClaimStatus.reserved => ClaimProblem.otherBranch,
      null => ClaimProblem.other,
    };
  }
}

/// Owners and staff both work the counter.
abstract interface class ClaimRepository {
  /// Reservations waiting to be picked up, soonest to expire first. Staff
  /// limited to a branch only get their branch's.
  Future<Result<PageResult<Claim>>> upcoming(
    String storeId, {
    required int page,
    required int pageSize,
  });

  Future<Result<Claim>> lookup(String storeId, String code);

  /// Marks it picked up at [branchId] (null when the backend can tell: staff
  /// limited to a branch, or an offer at one branch only).
  Future<Result<Claim>> redeem(String storeId, String code, {String? branchId});
}

/// Wired to the real implementation in `core/providers/dependencies.dart`.
final claimRepositoryProvider = Provider<ClaimRepository>(
  (ref) =>
      throw UnimplementedError('Provided by core/providers/dependencies.dart'),
);
