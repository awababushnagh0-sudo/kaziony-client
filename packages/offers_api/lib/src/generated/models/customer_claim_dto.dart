// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'cancel_reason.dart';
import 'claim_status.dart';
import 'customer_claim_offer_dto.dart';
import 'customer_claim_store_dto.dart';
import 'public_location_dto.dart';

part 'customer_claim_dto.g.dart';

@JsonSerializable()
class CustomerClaimDto {
  const CustomerClaimDto({
    required this.status,
    required this.cancelReason,
    required this.id,
    required this.code,
    required this.quantity,
    required this.totalPrice,
    required this.expiresAt,
    required this.redeemedAt,
    required this.sentForDeliveryAt,
    required this.cancelledAt,
    required this.createdAt,
    required this.offer,
    required this.store,
    required this.location,
    required this.canCancel,
    required this.cancelEndsBooking,
    required this.myRating,
    required this.canRate,
  });
  
  factory CustomerClaimDto.fromJson(Map<String, Object?> json) => _$CustomerClaimDtoFromJson(json);
  
  /// EXPIRED as soon as expiresAt passes, even before the cleanup job runs.
  /// OUT_FOR_DELIVERY has no time limit: the store closes it.
  final ClaimStatus status;

  /// Who cancelled it, when CANCELLED: anything but CUSTOMER wasn't the.
  /// customer's doing, and doesn't count against them.
  final CancelReason? cancelReason;
  final String id;

  /// Show this as a QR code at the counter.
  final String code;

  /// Pieces taken with this code.
  final num quantity;

  /// What to pay in cash: offerPrice × quantity, LD with 3 decimals.
  final String totalPrice;

  /// Pick up and pay before this time (not once out for delivery).
  final DateTime expiresAt;
  final DateTime? redeemedAt;

  /// When the store sent it with its driver (OUT_FOR_DELIVERY, or delivered).
  final DateTime? sentForDeliveryAt;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final CustomerClaimOfferDto offer;
  final CustomerClaimStoreDto store;

  /// Where to pick it up.
  final PublicLocationDto location;
  final bool canCancel;

  /// This offer was cancelled once already: cancelling again means it can't.
  /// be booked again. For the app to say so before.
  final bool cancelEndsBooking;

  /// The stars I gave the store (one rating per store); null until I rate it.
  final num? myRating;

  /// Picked up, and the store not rated since: rating replaces my earlier.
  /// stars for it.
  final bool canRate;

  Map<String, Object?> toJson() => _$CustomerClaimDtoToJson(this);
}
