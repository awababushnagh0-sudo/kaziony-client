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
    required this.quantity,
    required this.totalPrice,
    required this.customerName,
    required this.offer,
    required this.expiresAt,
    required this.redeemedAt,
    required this.sentForDeliveryAt,
    required this.createdAt,
    required this.canRedeem,
    required this.canSendForDelivery,
    required this.problem,
    required this.problemCode,
  });
  
  factory PartnerClaimDto.fromJson(Map<String, Object?> json) => _$PartnerClaimDtoFromJson(json);
  
  final ClaimStatus status;
  final String id;
  final String code;

  /// Pieces to hand over.
  final num quantity;

  /// What to collect in cash: offerPrice × quantity, LD with 3 decimals.
  final String totalPrice;
  final String? customerName;
  final ClaimOfferDto offer;
  final DateTime expiresAt;
  final DateTime? redeemedAt;

  /// When the store sent it with its driver (OUT_FOR_DELIVERY, or delivered).
  final DateTime? sentForDeliveryAt;
  final DateTime createdAt;

  /// True if it can be redeemed right now at this store: handed over at the.
  /// counter, or at the door by a driver with the app.
  final bool canRedeem;

  /// The store delivers, and it's still waiting: it can go with the driver.
  final bool canSendForDelivery;

  /// Why it can't be redeemed, to show the cashier.
  final String? problem;

  /// The same, as a code the app can put in its own words (the `error` code.
  /// redeeming would answer with): AlreadyRedeemed, ClaimCancelled or.
  /// ClaimExpired. More may be added later.
  final String? problemCode;

  Map<String, Object?> toJson() => _$PartnerClaimDtoToJson(this);
}
