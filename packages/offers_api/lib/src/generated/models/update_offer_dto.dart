// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_offer_dto.g.dart';

@JsonSerializable()
class UpdateOfferDto {
  const UpdateOfferDto({
    this.title,
    this.description,
    this.endsAt,
  });
  
  factory UpdateOfferDto.fromJson(Map<String, Object?> json) => _$UpdateOfferDtoFromJson(json);
  
  /// Defaults to the product title.
  final String? title;

  /// Defaults to the product description.
  final String? description;

  /// Extend or shorten the offer.
  final DateTime? endsAt;

  Map<String, Object?> toJson() => _$UpdateOfferDtoToJson(this);
}
