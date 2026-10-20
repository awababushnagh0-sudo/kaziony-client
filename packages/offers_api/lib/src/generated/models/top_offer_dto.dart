// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'top_offer_dto.g.dart';

@JsonSerializable()
class TopOfferDto {
  const TopOfferDto({
    required this.offerId,
    required this.title,
    required this.views,
    required this.claims,
    required this.redeemed,
  });
  
  factory TopOfferDto.fromJson(Map<String, Object?> json) => _$TopOfferDtoFromJson(json);
  
  final String offerId;
  final String title;
  final num views;
  final num claims;
  final num redeemed;

  Map<String, Object?> toJson() => _$TopOfferDtoToJson(this);
}
