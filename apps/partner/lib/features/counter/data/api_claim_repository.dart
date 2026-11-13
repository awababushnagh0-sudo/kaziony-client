import 'package:kernel/kernel.dart';
import 'package:offers_api/partner.dart' as api;
import 'package:offers_api/partner.dart' show PartnerClaimsClient;

import '../domain/claim.dart';

class ApiClaimRepository implements ClaimRepository {
  ApiClaimRepository(this._api);

  final Api _api;
  late final _claims = _api.client(PartnerClaimsClient.new);

  @override
  Future<Result<PageResult<Claim>>> upcoming(
    String storeId, {
    required int page,
    required int pageSize,
  }) => _list(storeId, api.ClaimStatus.reserved, page, pageSize);

  @override
  Future<Result<PageResult<Claim>>> deliveries(
    String storeId, {
    required int page,
    required int pageSize,
  }) => _list(storeId, api.ClaimStatus.outForDelivery, page, pageSize);

  Future<Result<PageResult<Claim>>> _list(
    String storeId,
    api.ClaimStatus status,
    int page,
    int pageSize,
  ) async {
    final result = await _api.guard(
      () => _claims.list(
        storeId: storeId,
        page: page,
        pageSize: pageSize,
        status: status,
      ),
    );
    return result.map(
      (list) => PageResult(
        items: [for (final claim in list.items) _toClaim(claim)],
        total: list.meta.total.toInt(),
      ),
    );
  }

  @override
  Future<Result<Claim>> lookup(String storeId, String code) async =>
      (await _api.guard(() => _claims.lookup(storeId: storeId, code: code)))
          .map(_toClaim);

  @override
  Future<Result<Claim>> redeem(String storeId, String code) async =>
      (await _api.guard(
        () => _claims.redeem(
          storeId: storeId,
          body: api.RedeemClaimDto(code: code),
        ),
      )).map(_toClaim);

  @override
  Future<Result<Claim>> sendForDelivery(String storeId, String code) async =>
      (await _api.guard(
        () => _claims.sendForDelivery(
          storeId: storeId,
          body: api.RedeemClaimDto(code: code),
        ),
      )).map(_toClaim);

  @override
  Future<Result<Claim>> delivered(String storeId, String claimId) async =>
      (await _api.guard(
        () => _claims.delivered(storeId: storeId, claimId: claimId),
      )).map(_toClaim);

  @override
  Future<Result<Claim>> notDelivered(String storeId, String claimId) async =>
      (await _api.guard(
        () => _claims.notDelivered(storeId: storeId, claimId: claimId),
      )).map(_toClaim);
}

Claim _toClaim(api.PartnerClaimDto dto) => Claim(
  id: dto.id,
  code: dto.code,
  quantity: dto.quantity.toInt(),
  totalPrice: dto.totalPrice,
  status: switch (dto.status) {
    api.ClaimStatus.reserved => ClaimStatus.reserved,
    api.ClaimStatus.outForDelivery => ClaimStatus.outForDelivery,
    api.ClaimStatus.redeemed => ClaimStatus.redeemed,
    api.ClaimStatus.expired => ClaimStatus.expired,
    api.ClaimStatus.cancelled => ClaimStatus.cancelled,
    api.ClaimStatus.$unknown => null,
  },
  customerName: dto.customerName,
  offer: ClaimOffer(
    id: dto.offer.id,
    title: dto.offer.title,
    offerPrice: dto.offer.offerPrice,
    originalPrice: dto.offer.originalPrice,
    thumbUrl: dto.offer.thumbUrl,
  ),
  expiresAt: dto.expiresAt,
  redeemedAt: dto.redeemedAt,
  sentForDeliveryAt: dto.sentForDeliveryAt,
  canRedeem: dto.canRedeem,
  canSendForDelivery: dto.canSendForDelivery,
  cancelledBy: switch (dto.cancelReason) {
    api.CancelReason.customer => CancelledBy.customer,
    api.CancelReason.offerRemoved ||
    api.CancelReason.storeOff => CancelledBy.team,
    api.CancelReason.storeClosed ||
    api.CancelReason.hoursChanged ||
    api.CancelReason.notDelivered => CancelledBy.store,
    api.CancelReason.$unknown || null => null,
  },
);
