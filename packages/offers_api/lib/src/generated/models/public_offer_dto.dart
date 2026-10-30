// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'offer_state.dart';
import 'offer_store_summary_dto.dart';
import 'offer_type.dart';
import 'public_branch_dto.dart';

part 'public_offer_dto.g.dart';

@JsonSerializable()
class PublicOfferDto {
  const PublicOfferDto({
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
    required this.maxPerUser,
    required this.claimWindowMinutes,
    required this.startsAt,
    required this.endsAt,
    required this.store,
    required this.nearestBranch,
    required this.branchCount,
  });
  
  factory PublicOfferDto.fromJson(Map<String, Object?> json) => _$PublicOfferDtoFromJson(json);
  
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

  /// Pieces one customer can take in all; null for no limit.
  final num? maxPerUser;

  /// How long a reservation is held after claiming.
  final num claimWindowMinutes;
  final DateTime startsAt;
  final DateTime endsAt;
  final OfferStoreSummaryDto store;

  /// The closest branch where this offer is valid (or the first one).
  final PublicBranchDto nearestBranch;

  /// Number of branches where it's valid.
  final num branchCount;

  Map<String, Object?> toJson() => _$PublicOfferDtoToJson(this);
}
