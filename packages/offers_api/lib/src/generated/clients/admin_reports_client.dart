// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/admin_claim_report_dto.dart';
import '../models/admin_claim_report_list_dto.dart';
import '../models/report_status.dart';
import '../models/resolve_claim_report_dto.dart';

part 'admin_reports_client.g.dart';

@RestApi()
abstract class AdminReportsClient {
  factory AdminReportsClient(Dio dio, {String? baseUrl}) = _AdminReportsClient;

  /// Customers' reports of problems with bookings.
  ///
  /// Open ones first, oldest first; then resolved ones, the latest resolved first.
  ///
  /// [status] - Only reports in this state; all of them without it.
  ///
  /// [search] - Search by booking code, store, or the customer's name or email.
  @GET('/api/v1/admin/reports')
  Future<AdminClaimReportListDto> list({
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('status') ReportStatus? status,
    @Query('search') String? search,
  });

  /// One report, with its booking and customer.
  ///
  /// The name has been replaced because it contains a keyword. Original name: `get`.
  @GET('/api/v1/admin/reports/{id}')
  Future<AdminClaimReportDto> getApiV1AdminReportsId({
    @Path('id') required String id,
  });

  /// Resolve a report, taking back its strike or the pause if asked.
  ///
  /// Once: 409 with error "AlreadyResolved" after. "NoStrike" when asked to take back a strike the booking didn't give, "NotPaused" to end a pause the customer isn't in; then nothing changes.
  @POST('/api/v1/admin/reports/{id}/resolve')
  Future<AdminClaimReportDto> resolve({
    @Path('id') required String id,
    @Body() required ResolveClaimReportDto body,
  });
}
