import 'package:kernel/kernel.dart';
import 'package:offers_api/partner.dart' as api;
import 'package:offers_api/partner.dart' show PartnerOffersClient;

import '../domain/offer.dart';

class ApiOfferRepository implements OfferRepository {
  ApiOfferRepository(this._api);

  final Api _api;
  late final _offers = _api.client(PartnerOffersClient.new);

  @override
  Future<Result<PageResult<Offer>>> list(
    String storeId, {
    required int page,
    required int pageSize,
    OfferStatus? status,
  }) async {
    final result = await _api.guard(
      () => _offers.list(
        storeId: storeId,
        page: page,
        pageSize: pageSize,
        status: switch (status) {
          null => null,
          OfferStatus.active => api.OfferStatus.active,
          OfferStatus.paused => api.OfferStatus.paused,
          OfferStatus.ended => api.OfferStatus.ended,
          OfferStatus.removed => api.OfferStatus.removed,
        },
      ),
    );
    return result.map(
      (list) => PageResult(
        items: [for (final offer in list.items) _toOffer(offer)],
        total: list.meta.total.toInt(),
      ),
    );
  }

  @override
  Future<Result<Offer>> get(String storeId, String offerId) =>
      _one(() => _offers.getOffer(storeId: storeId, offerId: offerId));

  @override
  Future<Result<Offer>> create(String storeId, NewOffer offer) => _one(
    () => _offers.create(
      storeId: storeId,
      body: api.CreateOfferDto(
        productId: offer.productId,
        offerPrice: offer.offerPrice,
        type: switch (offer.type) {
          OfferType.limited => api.OfferType.limited,
          OfferType.unlimited => api.OfferType.unlimited,
        },
        totalQuantity: offer.totalQuantity,
        claimWindowMinutes: offer.claimWindowMinutes,
        maxPerUser: offer.maxPerUser,
        // The generated client writes dates as they are; in UTC the
        // backend reads the right moment.
        endsAt: offer.endsAt.toUtc(),
        branchIds: offer.branchIds,
      ),
    ),
  );

  @override
  Future<Result<Offer>> update(
    String storeId,
    String offerId,
    OfferChanges changes,
  ) => _one(
    () => _offers.update(
      storeId: storeId,
      offerId: offerId,
      body: api.UpdateOfferDto(
        title: changes.title,
        description: changes.description ?? '',
        endsAt: changes.endsAt.toUtc(),
      ),
    ),
  );

  @override
  Future<Result<Offer>> pause(String storeId, String offerId) =>
      _one(() => _offers.pause(storeId: storeId, offerId: offerId));

  @override
  Future<Result<Offer>> resume(String storeId, String offerId) =>
      _one(() => _offers.resume(storeId: storeId, offerId: offerId));

  @override
  Future<Result<Offer>> end(String storeId, String offerId) =>
      _one(() => _offers.end(storeId: storeId, offerId: offerId));

  Future<Result<Offer>> _one(
    Future<api.PartnerOfferDto> Function() request,
  ) async => (await _api.guard(request)).map(_toOffer);
}

Offer _toOffer(api.PartnerOfferDto dto) => Offer(
  id: dto.id,
  productId: dto.productId,
  title: dto.title,
  description: dto.description,
  thumbUrl: dto.thumbUrl,
  originalPrice: dto.originalPrice,
  offerPrice: dto.offerPrice,
  discountPercent: dto.discountPercent.toInt(),
  type: switch (dto.type) {
    api.OfferType.unlimited => OfferType.unlimited,
    api.OfferType.limited => OfferType.limited,
    api.OfferType.$unknown =>
      dto.totalQuantity == null ? OfferType.unlimited : OfferType.limited,
  },
  status: switch (dto.status) {
    api.OfferStatus.active => OfferStatus.active,
    api.OfferStatus.paused => OfferStatus.paused,
    api.OfferStatus.ended => OfferStatus.ended,
    api.OfferStatus.removed => OfferStatus.removed,
    api.OfferStatus.$unknown => null,
  },
  state: switch (dto.state) {
    api.OfferState.live => OfferState.live,
    api.OfferState.scheduled => OfferState.scheduled,
    api.OfferState.soldOut => OfferState.soldOut,
    api.OfferState.paused => OfferState.paused,
    api.OfferState.ended => OfferState.ended,
    api.OfferState.removed => OfferState.removed,
    api.OfferState.$unknown => null,
  },
  totalQuantity: dto.totalQuantity?.toInt(),
  remainingQuantity: dto.remainingQuantity?.toInt(),
  maxPerUser: dto.maxPerUser.toInt(),
  claimWindowMinutes: dto.claimWindowMinutes.toInt(),
  startsAt: dto.startsAt,
  endsAt: dto.endsAt,
  branchIds: dto.branchIds,
  viewCount: dto.viewCount.toInt(),
  claims: ClaimCounts(
    reserved: dto.claims.reserved.toInt(),
    redeemed: dto.claims.redeemed.toInt(),
    expired: dto.claims.expired.toInt(),
    cancelled: dto.claims.cancelled.toInt(),
  ),
);
