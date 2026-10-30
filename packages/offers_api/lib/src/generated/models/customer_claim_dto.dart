// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'claim_status.dart';
import 'customer_claim_offer_dto.dart';
import 'customer_claim_store_dto.dart';
import 'public_branch_dto.dart';

part 'customer_claim_dto.g.dart';

@JsonSerializable()
class CustomerClaimDto {
  const CustomerClaimDto({
    required this.status,
    required this.id,
    required this.code,
    required this.quantity,
    required this.totalPrice,
    required this.expiresAt,
    required this.redeemedAt,
    required this.cancelledAt,
    required this.createdAt,
    required this.offer,
    required this.store,
    required this.branches,
    required this.canCancel,
  });
  
  factory CustomerClaimDto.fromJson(Map<String, Object?> json) => _$CustomerClaimDtoFromJson(json);
  
  /// EXPIRED as soon as expiresAt passes, even before the cleanup job runs.
  final ClaimStatus status;
  final String id;

  /// Show this as a QR code at the counter.
  final String code;

  /// Pieces taken with this code.
  final num quantity;

  /// What to pay in cash: offerPrice × quantity, LD with 3 decimals.
  final String totalPrice;

  /// Pick up and pay before this time.
  final DateTime expiresAt;
  final DateTime? redeemedAt;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final CustomerClaimOfferDto offer;
  final CustomerClaimStoreDto store;

  /// Where it can be picked up.
  final List<PublicBranchDto> branches;
  final bool canCancel;

  Map<String, Object?> toJson() => _$CustomerClaimDtoToJson(this);
}
