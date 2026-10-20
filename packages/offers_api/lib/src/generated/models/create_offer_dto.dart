// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'offer_type.dart';

part 'create_offer_dto.g.dart';

@JsonSerializable()
class CreateOfferDto {
  const CreateOfferDto({
    required this.type,
    required this.productId,
    required this.offerPrice,
    required this.endsAt,
    this.totalQuantity,
    this.maxPerUser,
    this.claimWindowMinutes,
    this.startsAt,
    this.branchIds,
    this.title,
    this.description,
  });
  
  factory CreateOfferDto.fromJson(Map<String, Object?> json) => _$CreateOfferDtoFromJson(json);
  
  final OfferType type;

  /// The product this offer is for. Its photo and regular price are used.
  final String productId;

  /// Discounted price in LD. Must be lower than the product's regular price.
  final String offerPrice;

  /// Required for LIMITED offers, not allowed for UNLIMITED.
  final num? totalQuantity;

  /// How many times one customer can claim it.
  final num? maxPerUser;

  /// How long a claim is held before it expires (LIMITED offers).
  final num? claimWindowMinutes;

  /// Defaults to now.
  final DateTime? startsAt;

  /// At most 30 days after the start.
  final DateTime endsAt;

  /// Branches where it's valid. Defaults to all active branches.
  final List<String>? branchIds;

  /// Defaults to the product title.
  final String? title;

  /// Defaults to the product description.
  final String? description;

  Map<String, Object?> toJson() => _$CreateOfferDtoToJson(this);
}
