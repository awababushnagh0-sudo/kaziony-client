// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/audit_area.dart';
import '../models/audit_entry_list_dto.dart';

part 'admin_audit_log_client.g.dart';

@RestApi()
abstract class AdminAuditLogClient {
  factory AdminAuditLogClient(Dio dio, {String? baseUrl}) = _AdminAuditLogClient;

  /// Who changed what in the dashboard, the latest first.
  ///
  /// One entry per change that succeeded, with what was sent (never passwords). Filter by who, by what it was done to, or by area.
  ///
  /// [area] - Only changes in this part of the dashboard.
  ///
  /// [search] - Only entries whose target, or whoever made them, has this in its name.
  ///
  /// [actorId] - Only what this person did.
  ///
  /// [targetId] - Only what was done to this store, user, offer, category or area.
  @GET('/api/v1/admin/audit-log')
  Future<AuditEntryListDto> list({
    @Query('page') required num page,
    @Query('pageSize') required num pageSize,
    @Query('area') AuditArea? area,
    @Query('search') String? search,
    @Query('actorId') String? actorId,
    @Query('targetId') String? targetId,
  });
}
