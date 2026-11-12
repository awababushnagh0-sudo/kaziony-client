// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'offer_state.dart';
import 'offer_store_summary_dto.dart';
import 'offer_type.dart';
import 'public_location_dto.dart';

part 'public_offer_detail_dto.g.dart';

@JsonSerializable()
class PublicOfferDetailDto {
  const PublicOfferDetailDto({
    required this.type,
    required this.state,
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.thumbUrl,
    required this.originalPrice,
    required this.offerPrice,
    required this.discountPercent,
    required this.remainingQuantity,
    required this.totalQuantity,
    required this.maxPerUser,
    required this.claimWindowMinutes,
    required this.lastBookingMinutes,
    required this.startsAt,
    required this.endsAt,
    required this.store,
    required this.location,
    required this.myActiveClaimId,
    required this.pickupInstructions,
  });
  
  factory PublicOfferDetailDto.fromJson(Map<String, Object?> json) => _$PublicOfferDetailDtoFromJson(json);
  
  final OfferType type;
  final OfferState state;
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? thumbUrl;

  /// LD with 3 decimals
  final String originalPrice;

  /// LD with 3 decimals
  final String offerPrice;
  final num discountPercent;

  /// Pieces left (LIMITED offers only).
  final num? remainingQuantity;

  /// Pieces it started with (LIMITED offers only), for "3 of 10 left".
  final num? totalQuantity;

  /// Pieces one customer can take in all; null for no limit.
  final num? maxPerUser;

  /// How long a reservation is held after claiming (our setting, the same.
  /// everywhere), unless the offer ends first, or the store closes first and.
  /// isn't open again by then (location.openingHours, Libya time): then.
  /// until it closes.
  final num claimWindowMinutes;

  /// LIMITED offers can't be booked while the store is closed, nor in the.
  /// last this many minutes before it closes.
  final num lastBookingMinutes;
  final DateTime startsAt;
  final DateTime endsAt;
  final OfferStoreSummaryDto store;

  /// Where to pick it up: the store's place.
  final PublicLocationDto location;

  /// The logged-in customer's open booking for this offer, if any: waiting.
  /// to be picked up, or out for delivery.
  final String? myActiveClaimId;

  /// The store's: where to go in the shop, what to bring.
  final String? pickupInstructions;

  Map<String, Object?> toJson() => _$PublicOfferDetailDtoToJson(this);
}
