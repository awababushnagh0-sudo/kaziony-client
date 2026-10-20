// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'claim_offer_dto.g.dart';

@JsonSerializable()
class ClaimOfferDto {
  const ClaimOfferDto({
    required this.id,
    required this.title,
    required this.offerPrice,
    required this.originalPrice,
    required this.thumbUrl,
  });
  
  factory ClaimOfferDto.fromJson(Map<String, Object?> json) => _$ClaimOfferDtoFromJson(json);
  
  final String id;
  final String title;

  /// LD with 3 decimals
  final String offerPrice;

  /// LD with 3 decimals
  final String originalPrice;
  final String? thumbUrl;

  Map<String, Object?> toJson() => _$ClaimOfferDtoToJson(this);
}
