// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'offer_state.dart';
import 'offer_store_summary_dto.dart';
import 'offer_type.dart';
import 'public_branch_dto.dart';

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
    required this.claimWindowMinutes,
    required this.startsAt,
    required this.endsAt,
    required this.store,
    required this.nearestBranch,
    required this.branchCount,
    required this.branches,
    required this.myActiveClaimId,
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

  /// How long a reservation is held after claiming.
  final num claimWindowMinutes;
  final DateTime startsAt;
  final DateTime endsAt;
  final OfferStoreSummaryDto store;

  /// The closest branch where this offer is valid (or the first one).
  final PublicBranchDto nearestBranch;

  /// Number of branches where it's valid.
  final num branchCount;

  /// All branches where it's valid, closest first when a location is sent.
  final List<PublicBranchDto> branches;

  /// The logged-in customer's active reservation for this offer, if any.
  final String? myActiveClaimId;

  Map<String, Object?> toJson() => _$PublicOfferDetailDtoToJson(this);
}
