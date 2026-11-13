// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_claim_report_claim_dto.dart';
import 'admin_claim_report_customer_dto.dart';
import 'admin_claim_report_resolver_dto.dart';
import 'admin_claim_report_store_dto.dart';
import 'report_reason.dart';
import 'report_status.dart';

part 'admin_claim_report_dto.g.dart';

@JsonSerializable()
class AdminClaimReportDto {
  const AdminClaimReportDto({
    required this.reason,
    required this.status,
    required this.id,
    required this.note,
    required this.createdAt,
    required this.claim,
    required this.store,
    required this.customer,
    required this.hasStrike,
    required this.strikeRemoved,
    required this.pauseEnded,
    required this.resolution,
    required this.resolvedAt,
    required this.resolvedBy,
  });
  
  factory AdminClaimReportDto.fromJson(Map<String, Object?> json) => _$AdminClaimReportDtoFromJson(json);
  
  final ReportReason reason;
  final ReportStatus status;
  final String id;
  final String? note;
  final DateTime createdAt;
  final AdminClaimReportClaimDto claim;
  final AdminClaimReportStoreDto store;
  final AdminClaimReportCustomerDto customer;

  /// The booking gave a strike that still stands: it can be taken back.
  final bool hasStrike;
  final bool strikeRemoved;
  final bool pauseEnded;

  /// What our team found.
  final String? resolution;
  final DateTime? resolvedAt;
  final AdminClaimReportResolverDto? resolvedBy;

  Map<String, Object?> toJson() => _$AdminClaimReportDtoToJson(this);
}
