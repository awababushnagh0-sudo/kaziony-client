// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'claim_counts_dto.dart';
import 'offer_state.dart';
import 'offer_status.dart';
import 'offer_type.dart';

part 'partner_offer_dto.g.dart';

@JsonSerializable()
class PartnerOfferDto {
  const PartnerOfferDto({
    required this.type,
    required this.status,
    required this.state,
    required this.id,
    required this.productId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.thumbUrl,
    required this.originalPrice,
    required this.offerPrice,
    required this.discountPercent,
    required this.totalQuantity,
    required this.remainingQuantity,
    required this.maxPerUser,
    required this.claimWindowMinutes,
    required this.startsAt,
    required this.endsAt,
    required this.branchIds,
    required this.viewCount,
    required this.claims,
    required this.canEditDetails,
    required this.createdAt,
  });
  
  factory PartnerOfferDto.fromJson(Map<String, Object?> json) => _$PartnerOfferDtoFromJson(json);
  
  final OfferType type;
  final OfferStatus status;

  /// What customers see right now.
  final OfferState state;
  final String id;
  final String productId;
  final String title;
  final String? description;
  final String? imageUrl;
  final String? thumbUrl;

  /// LD with 3 decimals, e.g. "8.000"
  final String originalPrice;

  /// LD with 3 decimals, e.g. "4.000"
  final String offerPrice;

  /// e.g. 50 for half price
  final num discountPercent;
  final num? totalQuantity;
  final num? remainingQuantity;

  /// Pieces one customer can take in all; null for no limit.
  final num? maxPerUser;
  final num claimWindowMinutes;
  final DateTime startsAt;
  final DateTime endsAt;
  final List<String> branchIds;
  final num viewCount;
  final ClaimCountsDto claims;

  /// False while customers hold a reservation: the title and description stay.
  /// as they reserved them (editing them returns 409 `OfferHasReservations`).
  /// The end time can always change.
  final bool canEditDetails;
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$PartnerOfferDtoToJson(this);
}
