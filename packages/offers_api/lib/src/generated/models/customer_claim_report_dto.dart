// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'report_reason.dart';
import 'report_status.dart';

part 'customer_claim_report_dto.g.dart';

@JsonSerializable()
class CustomerClaimReportDto {
  const CustomerClaimReportDto({
    required this.reason,
    required this.status,
    required this.note,
    required this.strikeRemoved,
    required this.createdAt,
    required this.resolvedAt,
  });
  
  factory CustomerClaimReportDto.fromJson(Map<String, Object?> json) => _$CustomerClaimReportDtoFromJson(json);
  
  final ReportReason reason;
  final ReportStatus status;
  final String? note;

  /// Our team took back the strike this booking gave me.
  final bool strikeRemoved;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  Map<String, Object?> toJson() => _$CustomerClaimReportDtoToJson(this);
}
