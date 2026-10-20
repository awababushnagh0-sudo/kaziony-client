// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'category_dto.dart';

part 'offer_store_summary_dto.g.dart';

@JsonSerializable()
class OfferStoreSummaryDto {
  const OfferStoreSummaryDto({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.category,
  });
  
  factory OfferStoreSummaryDto.fromJson(Map<String, Object?> json) => _$OfferStoreSummaryDtoFromJson(json);
  
  final String id;
  final String name;
  final String? logoUrl;
  final CategoryDto category;

  Map<String, Object?> toJson() => _$OfferStoreSummaryDtoToJson(this);
}
