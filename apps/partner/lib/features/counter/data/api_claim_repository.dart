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
  }) async {
    final result = await _api.guard(
      () => _claims.list(
        storeId: storeId,
        page: page,
        pageSize: pageSize,
        status: api.ClaimStatus.reserved,
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
  Future<Result<Claim>> redeem(
    String storeId,
    String code, {
    String? branchId,
  }) async => (await _api.guard(
    () => _claims.redeem(
      storeId: storeId,
      body: api.RedeemClaimDto(code: code, branchId: branchId),
    ),
  )).map(_toClaim);
}

Claim _toClaim(api.PartnerClaimDto dto) => Claim(
  id: dto.id,
  code: dto.code,
  quantity: dto.quantity.toInt(),
  totalPrice: dto.totalPrice,
  status: switch (dto.status) {
    api.ClaimStatus.reserved => ClaimStatus.reserved,
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
  redeemedBranchId: dto.redeemedBranchId,
  canRedeem: dto.canRedeem,
);
