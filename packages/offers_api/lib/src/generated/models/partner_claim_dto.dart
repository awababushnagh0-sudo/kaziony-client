// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'claim_offer_dto.dart';
import 'claim_status.dart';

part 'partner_claim_dto.g.dart';

@JsonSerializable()
class PartnerClaimDto {
  const PartnerClaimDto({
    required this.status,
    required this.id,
    required this.code,
    required this.customerName,
    required this.offer,
    required this.expiresAt,
    required this.redeemedAt,
    required this.redeemedBranchId,
    required this.createdAt,
    required this.canRedeem,
    required this.problem,
  });
  
  factory PartnerClaimDto.fromJson(Map<String, Object?> json) => _$PartnerClaimDtoFromJson(json);
  
  final ClaimStatus status;
  final String id;
  final String code;
  final String? customerName;
  final ClaimOfferDto offer;
  final DateTime expiresAt;
  final DateTime? redeemedAt;
  final String? redeemedBranchId;
  final DateTime createdAt;

  /// True if it can be redeemed right now at this store.
  final bool canRedeem;

  /// Why it can't be redeemed, to show the cashier.
  final String? problem;

  Map<String, Object?> toJson() => _$PartnerClaimDtoToJson(this);
}
