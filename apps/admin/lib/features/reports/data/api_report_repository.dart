import 'package:kernel/kernel.dart';
import 'package:offers_api/admin.dart' as api;

import '../domain/customer_report.dart';

class ApiReportRepository implements ReportRepository {
  ApiReportRepository(this._api);

  final Api _api;
  late final _reports = _api.client(api.AdminReportsClient.new);

  @override
  Future<Result<ReportPage>> list(ReportQuery query) async {
    final result = await _api.guard(
      () => _reports.list(
        page: query.page,
        pageSize: query.pageSize,
        search: query.search.isEmpty ? null : query.search,
        status: switch (query.filter) {
          null => null,
          ReportState.open => api.ReportStatus.open,
          ReportState.resolved => api.ReportStatus.resolved,
        },
      ),
    );
    return result.map(
      (dto) => ReportPage(
        total: dto.meta.total.toInt(),
        items: [for (final report in dto.items) _toReport(report)],
      ),
    );
  }

  @override
  Future<Result<CustomerReport>> resolve(
    String id,
    ReportResolution resolution,
  ) async {
    final note = resolution.note?.trim();
    final result = await _api.guard(
      () => _reports.resolve(
        id: id,
        body: api.ResolveClaimReportDto(
          removeStrike: resolution.removeStrike,
          endPause: resolution.endPause,
          resolution: note == null || note.isEmpty ? null : note,
        ),
      ),
    );
    return result.map(_toReport);
  }
}

CustomerReport _toReport(api.AdminClaimReportDto dto) => CustomerReport(
  id: dto.id,
  reason: switch (dto.reason) {
    api.ReportReason.storeClosed => ReportReason.storeClosed,
    api.ReportReason.notGiven => ReportReason.notGiven,
    api.ReportReason.priceDifferent => ReportReason.priceDifferent,
    api.ReportReason.quality => ReportReason.quality,
    // A reason this version doesn't know reads as "something else".
    api.ReportReason.other || api.ReportReason.$unknown => ReportReason.other,
  },
  note: dto.note,
  state: dto.status == api.ReportStatus.resolved
      ? ReportState.resolved
      : ReportState.open,
  createdAt: dto.createdAt,
  booking: ReportedBooking(
    id: dto.claim.id,
    code: dto.claim.code,
    status: switch (dto.claim.status) {
      api.ClaimStatus.reserved => ReportedBookingStatus.waiting,
      api.ClaimStatus.outForDelivery => ReportedBookingStatus.outForDelivery,
      api.ClaimStatus.redeemed => ReportedBookingStatus.pickedUp,
      api.ClaimStatus.expired => ReportedBookingStatus.missed,
      api.ClaimStatus.cancelled => ReportedBookingStatus.cancelled,
      api.ClaimStatus.$unknown => null,
    },
    quantity: dto.claim.quantity.toInt(),
    totalPrice: dto.claim.totalPrice,
    offerTitle: dto.claim.offerTitle,
    createdAt: dto.claim.createdAt,
    expiresAt: dto.claim.expiresAt,
  ),
  store: ReportedStore(
    id: dto.store.id,
    name: dto.store.name,
    area: dto.store.area,
  ),
  customer: ReportCustomer(
    id: dto.customer.id,
    name: dto.customer.name,
    email: dto.customer.email,
    contactPhone: dto.customer.contactPhone,
    missedPickups: dto.customer.noShowCount.toInt(),
    pausedUntil: dto.customer.pausedUntil,
  ),
  hasStrike: dto.hasStrike,
  strikeRemoved: dto.strikeRemoved,
  pauseEnded: dto.pauseEnded,
  resolution: dto.resolution,
  resolvedAt: dto.resolvedAt,
  resolverName: dto.resolvedBy?.name,
);
