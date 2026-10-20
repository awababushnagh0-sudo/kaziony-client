// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'offer_store_dto.g.dart';

@JsonSerializable()
class OfferStoreDto {
  const OfferStoreDto({
    required this.id,
    required this.name,
  });
  
  factory OfferStoreDto.fromJson(Map<String, Object?> json) => _$OfferStoreDtoFromJson(json);
  
  final String id;
  final String name;

  Map<String, Object?> toJson() => _$OfferStoreDtoToJson(this);
}
