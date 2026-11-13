// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_claim_report_customer_dto.g.dart';

@JsonSerializable()
class AdminClaimReportCustomerDto {
  const AdminClaimReportCustomerDto({
    required this.id,
    required this.name,
    required this.email,
    required this.contactPhone,
    required this.noShowCount,
    required this.pausedUntil,
  });
  
  factory AdminClaimReportCustomerDto.fromJson(Map<String, Object?> json) => _$AdminClaimReportCustomerDtoFromJson(json);
  
  final String id;

  /// Null once they deleted their account.
  final String? name;
  final String? email;
  final String? contactPhone;

  /// Missed pickups in all.
  final num noShowCount;

  /// Booking is paused until then; null when it isn't now.
  final DateTime? pausedUntil;

  Map<String, Object?> toJson() => _$AdminClaimReportCustomerDtoToJson(this);
}
