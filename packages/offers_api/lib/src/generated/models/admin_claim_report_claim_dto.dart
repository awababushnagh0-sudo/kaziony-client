// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'cancel_reason.dart';
import 'claim_status.dart';
import 'offer_type.dart';

part 'admin_claim_report_claim_dto.g.dart';

@JsonSerializable()
class AdminClaimReportClaimDto {
  const AdminClaimReportClaimDto({
    required this.status,
    required this.cancelReason,
    required this.offerType,
    required this.id,
    required this.code,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
    required this.expiresAt,
    required this.redeemedAt,
    required this.cancelledAt,
    required this.offerId,
    required this.offerTitle,
  });
  
  factory AdminClaimReportClaimDto.fromJson(Map<String, Object?> json) => _$AdminClaimReportClaimDtoFromJson(json);
  
  /// EXPIRED once a waiting booking's time is up, before the job runs.
  final ClaimStatus status;
  final CancelReason? cancelReason;
  final OfferType offerType;
  final String id;
  final String code;
  final num quantity;
  final String totalPrice;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? redeemedAt;
  final DateTime? cancelledAt;
  final String offerId;
  final String offerTitle;

  Map<String, Object?> toJson() => _$AdminClaimReportClaimDtoToJson(this);
}
